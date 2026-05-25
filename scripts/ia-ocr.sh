#!/usr/bin/env bash

if [ "$1" = "" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "Usage: se-ext ia-ocr [options] <phrase> [<ebook-directory>]"
  echo ""
  echo "Search the Internet Archive scan's OCR text for a phrase from the"
  echo "ebook's first archive.org source, and report the OCR'd context, the"
  echo "leaf and printed page it falls on, and a canonical page-scan URL."
  echo ""
  echo "Unlike 'page-scans', which opens a scan in your browser, this prints"
  echo "the OCR text to stdout — so it can be used to confirm a suspected"
  echo "transcription error before editing, and to produce the exact"
  echo "page/NNN?q=... URL to cite in a commit."
  echo ""
  echo "The OCR is a locator, not an authority: it is good for finding a word"
  echo "or phrase, but unreliable on letterforms (long-s, capitalization,"
  echo "punctuation). Confirm those visually on the scan."
  echo ""
  echo "OPTIONS"
  echo "  --url                  Print only the canonical page-scan URL"
  echo "  --json                 Emit the result as JSON (overrides --url)"
  echo "  --all-matches          Report every match in the OCR, not just the"
  echo "                         first (each with its own leaf, page, and URL)"
  echo "  --auto-retry           If the exact phrase is not found, retry with"
  echo "                         progressively shorter contiguous sub-phrases"
  echo "                         (OCR may split, hyphenate, or misread words)"
  echo "  --image-url            Print only the direct page-image (JPEG) URL"
  echo "  --image                Download the matching leaf's full-resolution"
  echo "                         JPEG to ./<id>_<leaf>.jpg and print the path"
  echo "                         (with --all-matches, one file per match)"
  echo "  -h, --help             Show this help"
  echo "  <ebook-directory>      Path to the ebook project root (default: .)"
  echo ""
  echo "EXIT STATUS"
  echo "  0   match found"
  echo "  5   phrase not found in the OCR (retry with a shorter sub-phrase,"
  echo "      or pass --auto-retry to narrow automatically)"
  echo "  4   no Internet Archive source in content.opf"
  echo "  2   usage error"
  echo "  1   error (network / bad API response / could not resolve item)"
  echo ""
  echo "EXAMPLES"
  echo "  se-ext ia-ocr 'I was to Journey thither on foot'"
  echo "  se-ext ia-ocr --auto-retry 'I was to Journey thither on foot'"
  echo "  se-ext ia-ocr --all-matches 'Journey thither' # every hit in the book"
  echo "  se-ext ia-ocr --url 'Journey thither'      # paste-ready commit URL"
  echo "  se-ext ia-ocr --image 'Journey thither'    # save the page JPEG"
  echo "  se-ext ia-ocr --image-url 'Journey thither' # direct JPEG URL"
  echo "  se-ext ia-ocr --json 'Journey thither'     # machine-readable"
  exit 0
fi

UA="se-ext ia-ocr"
# Minimum sub-phrase length (in words) when narrowing under --auto-retry.
MIN_WORDS=3

PHRASE=""
EBOOK_DIR=""
URL_ONLY=false
JSON_MODE=false
AUTO_RETRY=false
ALL_MATCHES=false
IMAGE=false
IMAGE_URL_ONLY=false

while [ $# -gt 0 ]; do
  case "$1" in
    --url) URL_ONLY=true; shift ;;
    --json) JSON_MODE=true; shift ;;
    --all-matches) ALL_MATCHES=true; shift ;;
    --auto-retry) AUTO_RETRY=true; shift ;;
    --image) IMAGE=true; shift ;;
    --image-url) IMAGE_URL_ONLY=true; shift ;;
    -h|--help) exec se-ext ia-ocr --help ;;
    -*)
      echo "Unknown option: $1" >&2
      echo "Run 'se-ext ia-ocr --help' for usage." >&2
      exit 2
      ;;
    *)
      if [ -z "$PHRASE" ]; then
        PHRASE="$1"
      elif [ -z "$EBOOK_DIR" ]; then
        EBOOK_DIR="$1"
      else
        echo "Error: too many arguments (expected <phrase> [<ebook-directory>])." >&2
        exit 2
      fi
      shift
      ;;
  esac
done

if [ -z "$PHRASE" ]; then
  echo "Error: no phrase given." >&2
  echo "Run 'se-ext ia-ocr --help' for usage." >&2
  exit 2
fi

EBOOK_DIR="${EBOOK_DIR:-.}"
OPF="$EBOOK_DIR/src/epub/content.opf"

if [ ! -f "$OPF" ]; then
  echo "Error: content.opf not found at $OPF" >&2
  echo "Are you in a Standard Ebooks project directory?" >&2
  exit 1
fi

# Percent-encode a string, wrapping it in double quotes for exact-phrase search.
percent_encode_phrase() {
  local quoted="\"$1\""
  local encoded="" i char ord
  for (( i = 0; i < ${#quoted}; i++ )); do
    char="${quoted:i:1}"
    case "$char" in
      [a-zA-Z0-9._~-]) encoded+="$char" ;;
      ' ') encoded+="%20" ;;
      *) printf -v ord '%02X' "'$char"; encoded+="%$ord" ;;
    esac
  done
  printf '%s' "$encoded"
}

# Download an image URL to a file, verifying it is really a JPEG (IA returns an
# HTML error page, not an HTTP error, when an image request goes wrong). Prints
# the saved path on success; returns 1 (removing any partial file) on failure.
fetch_image() {
  local url="$1" out="$2" magic
  curl -s --max-time 180 -A "$UA" -o "$out" "$url" || { rm -f "$out"; return 1; }
  if [ ! -s "$out" ]; then
    rm -f "$out"; return 1
  fi
  magic=$(od -An -tx1 -N2 "$out" 2>/dev/null | tr -d ' \n')
  if [ "$magic" != "ffd8" ]; then
    rm -f "$out"; return 1
  fi
  printf '%s\n' "$out"
}

# Find the first archive.org/details identifier among the dc:source entries.
IA_ID=""
while IFS= read -r url; do
  case "$url" in
    *archive.org/details/*)
      IA_ID="${url#*archive.org/details/}"
      IA_ID="${IA_ID%%/*}"
      IA_ID="${IA_ID%%\?*}"
      break
      ;;
  esac
done < <(grep -oP '(?<=<dc:source>)[^<]+' "$OPF")

if [ -z "$IA_ID" ]; then
  echo "Error: no Internet Archive source found in $OPF." >&2
  echo "ia-ocr only works with archive.org/details/ sources." >&2
  exit 4
fi

# Resolve the item's data server and path from the IA metadata API.
META=$(curl -s --max-time 30 -A "$UA" "https://archive.org/metadata/$IA_ID") || {
  echo "Error: could not reach the Internet Archive metadata API." >&2
  exit 1
}
SERVER=$(printf '%s' "$META" | jq -r '.server // .d1 // empty' 2>/dev/null)
DIR=$(printf '%s' "$META" | jq -r '.dir // empty' 2>/dev/null)
if [ -z "$SERVER" ] || [ -z "$DIR" ]; then
  echo "Error: could not resolve the scan server for item '$IA_ID'." >&2
  exit 1
fi

# Run one "search inside" query. Stores the raw response in SEARCH_RESP.
# Returns 0 if there was at least one match, 1 if none, 2 on network/parse error.
SEARCH_RESP=""
do_search() {
  local enc resp n
  enc=$(percent_encode_phrase "$1")
  resp=$(curl -s --max-time 40 -A "$UA" \
    "https://$SERVER/fulltext/inside.php?item_id=$IA_ID&doc=$IA_ID&path=$DIR&q=$enc") || return 2
  SEARCH_RESP="$resp"
  n=$(printf '%s' "$resp" | jq -r '(.matches // []) | length' 2>/dev/null) || return 2
  [ "$n" -gt 0 ] 2>/dev/null
}

MATCHED=""
EXACT=true

do_search "$PHRASE"
rc=$?
if [ "$rc" -eq 0 ]; then
  MATCHED="$PHRASE"
elif [ "$rc" -eq 2 ]; then
  echo "Error: search-inside request failed for item '$IA_ID'." >&2
  exit 1
elif [ "$AUTO_RETRY" = true ]; then
  # Narrow to the longest matching contiguous sub-phrase: try every window of
  # length N-1, then N-2, ... down to MIN_WORDS, left to right, stopping at the
  # first hit. Each attempt is echoed to stderr so the narrowing is visible.
  echo "Exact phrase not found; trying shorter contiguous sub-phrases..." >&2
  read -ra WORDS <<< "$PHRASE"
  N=${#WORDS[@]}
  for (( L = N - 1; L >= MIN_WORDS; L-- )); do
    for (( start = 0; start + L <= N; start++ )); do
      sub="${WORDS[*]:start:L}"
      echo "  trying: \"$sub\"" >&2
      do_search "$sub"
      rc=$?
      if [ "$rc" -eq 0 ]; then
        MATCHED="$sub"; EXACT=false; break 2
      elif [ "$rc" -eq 2 ]; then
        echo "Error: search-inside request failed for item '$IA_ID'." >&2
        exit 1
      fi
    done
  done
fi

if [ -z "$MATCHED" ]; then
  if [ "$JSON_MODE" = true ]; then
    jq -n --arg phrase "$PHRASE" --arg id "$IA_ID" \
      '{found: false, phrase: $phrase, identifier: $id}'
  else
    echo "Not found in the OCR for '$IA_ID': \"$PHRASE\"" >&2
    if [ "$AUTO_RETRY" = true ]; then
      echo "No contiguous sub-phrase of $MIN_WORDS+ words matched either." >&2
    else
      echo "Try a shorter, distinctive sub-phrase, or pass --auto-retry." >&2
      echo "(OCR may split/hyphenate words or misread long-s and punctuation.)" >&2
    fi
  fi
  exit 5
fi

ENC=$(percent_encode_phrase "$MATCHED")

# Fetch the BookReader page data once and fold it into a leaf -> printed-page
# lookup, reused for every match below.
JSIA=$(curl -s --max-time 60 -A "$UA" \
  "https://$SERVER/BookReader/BookReaderJSIA.php?id=$IA_ID&itemPath=$DIR&server=$SERVER&format=json")
PAGEMAP=$(printf '%s' "$JSIA" | jq -c '
  [.. | objects
    | select(.leafNum != null and .pageNum != null and .pageNum != "")
    | {key: (.leafNum | tostring), value: .pageNum}]
  | from_entries' 2>/dev/null)
[ -n "$PAGEMAP" ] || PAGEMAP='{}'

# Fold the same BookReader data into a leaf -> image-URI lookup. Each leaf
# object carries the "uri" that BookReader itself loads (a BookReaderImages.php
# request against the item's jp2 zip); we reuse it verbatim, forcing scale=1 so
# the fetched JPEG is full resolution — needed to confirm letterforms.
IMGMAP=$(printf '%s' "$JSIA" | jq -c '
  [.. | objects
    | select(.leafNum != null and .uri != null and .uri != "")
    | {key: (.leafNum | tostring),
       value: (.uri | gsub("scale=[0-9]+"; "scale=1"))}]
  | from_entries' 2>/dev/null)
[ -n "$IMGMAP" ] || IMGMAP='{}'

# Reduce the winning response to the records we will print: each match's leaf,
# printed page (if any), bracketed snippet, and a canonical scan URL. Without
# --all-matches we keep only the first match (the historical behavior). The
# leaf-anchor "n<leaf>" page reference redirects to the printed page on IA.
# The leaf maps can carry one entry per page, so for a long book they grow
# large enough to overflow ARG_MAX if passed via --argjson. Feed them to jq as
# --slurpfile inputs (read through a pipe, not the argument vector) instead;
# --slurpfile wraps each file's value in an array, hence the [0] below.
RECORDS=$(printf '%s' "$SEARCH_RESP" | jq -c \
  --slurpfile pagemap <(printf '%s' "$PAGEMAP") \
  --slurpfile imgmap <(printf '%s' "$IMGMAP") \
  --arg id "$IA_ID" \
  --arg enc "$ENC" \
  --argjson all "$ALL_MATCHES" '
  [ .matches[]
    | (.par[0].page) as $leaf
    | ($pagemap[0][$leaf | tostring]) as $page
    | ($imgmap[0][$leaf | tostring]) as $imguri
    | ( if $page != null and $page != "" then $page
        elif $leaf != null then "n\($leaf)"
        else null end ) as $pageref
    | { leaf: $leaf,
        page: (if $page == "" then null else $page end),
        snippet: ( .text
          | gsub("<IA_FTS_MATCH>"; "[")
          | gsub("</IA_FTS_MATCH>"; "]")
          | gsub("\\s+"; " ")
          | gsub("^ +| +$"; "") ),
        url: ( if $pageref != null
               then "https://archive.org/details/\($id)/page/\($pageref)/mode/1up?q=\($enc)"
               else "https://archive.org/details/\($id)?q=\($enc)" end ),
        image_url: (if $imguri != null and $imguri != "" then $imguri else null end) }
  ]
  | if $all then . else .[0:1] end')

COUNT=$(printf '%s' "$RECORDS" | jq -r 'length' 2>/dev/null)
TOTAL=$(printf '%s' "$SEARCH_RESP" | jq -r '(.matches // []) | length' 2>/dev/null)

if [ "$JSON_MODE" = true ]; then
  if [ "$ALL_MATCHES" = true ]; then
    printf '%s' "$RECORDS" | jq \
      --arg id "$IA_ID" \
      --arg phrase "$PHRASE" \
      --arg matched "$MATCHED" \
      --argjson exact "$EXACT" \
      '{found: true, identifier: $id, phrase: $phrase, matched_phrase: $matched,
        exact: $exact, count: length, matches: .}'
  else
    printf '%s' "$RECORDS" | jq \
      --arg id "$IA_ID" \
      --arg phrase "$PHRASE" \
      --arg matched "$MATCHED" \
      --argjson exact "$EXACT" \
      '.[0] as $m
       | {found: true, identifier: $id, phrase: $phrase, matched_phrase: $matched,
          exact: $exact, leaf: $m.leaf, page: $m.page,
          snippet: $m.snippet, url: $m.url, image_url: $m.image_url}'
  fi
  exit 0
fi

if [ "$EXACT" = false ]; then
  echo "Exact phrase not found; matched narrower sub-phrase: \"$MATCHED\"" >&2
fi

if [ "$IMAGE_URL_ONLY" = true ]; then
  if printf '%s' "$RECORDS" | jq -e 'all(.[]; .image_url == null)' >/dev/null 2>&1; then
    echo "Error: could not determine a page-image URL for item '$IA_ID'." >&2
    exit 1
  fi
  printf '%s' "$RECORDS" | jq -r '.[].image_url // empty'
  exit 0
fi

if [ "$IMAGE" = true ]; then
  rc=0
  while IFS=$'\t' read -r leaf img; do
    if [ -z "$img" ]; then
      echo "Warning: no page-image URL for leaf ${leaf:-?}; skipping." >&2
      rc=1
      continue
    fi
    out="${IA_ID}_${leaf}.jpg"
    if ! fetch_image "$img" "$out"; then
      echo "Error: failed to download the page image for leaf ${leaf:-?}." >&2
      rc=1
    fi
  done < <(printf '%s' "$RECORDS" | jq -r '.[] | [(.leaf // "unknown" | tostring), (.image_url // "")] | @tsv')
  exit "$rc"
fi

if [ "$URL_ONLY" = true ]; then
  printf '%s' "$RECORDS" | jq -r '.[].url'
  exit 0
fi

if [ "$ALL_MATCHES" = true ]; then
  if [ "$COUNT" -eq 1 ]; then
    echo "1 match found:"
  else
    echo "$COUNT matches found:"
  fi
  printf '%s\n' "$RECORDS" | jq -r '
    to_entries[]
    | "",
      "[\(.key + 1)] " + (
        if .value.page != null then "leaf \(.value.leaf) (page \(.value.page))"
        elif .value.leaf != null then "leaf \(.value.leaf) (no printed page label)"
        else "leaf unknown" end),
      "    \(.value.snippet)",
      "    \(.value.url)"'
  exit 0
fi

# Default: report the single (first) match, exactly as before.
LEAF=$(printf '%s' "$RECORDS" | jq -r '.[0].leaf // empty')
PAGE=$(printf '%s' "$RECORDS" | jq -r '.[0].page // empty')
SNIPPET=$(printf '%s' "$RECORDS" | jq -r '.[0].snippet // empty')
URL=$(printf '%s' "$RECORDS" | jq -r '.[0].url')

if [ -n "$PAGE" ]; then
  echo "Found on leaf $LEAF (page $PAGE)"
else
  echo "Found on leaf $LEAF (no printed page label)"
fi
echo "$SNIPPET"
echo "$URL"
if [ "$TOTAL" -gt 1 ] 2>/dev/null; then
  echo "($TOTAL matches in the OCR; showing the first. Pass --all-matches for all.)" >&2
fi
exit 0
