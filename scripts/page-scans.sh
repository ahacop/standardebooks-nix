#!/usr/bin/env bash

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "Usage: se-ext page-scans [options] [<ebook-directory>]"
  echo ""
  echo "Extract page scan URLs from an ebook's content.opf and open them"
  echo "in a browser. If a search term is provided, it is appended to the"
  echo "URL as a query parameter where supported (Internet Archive, Google"
  echo "Books, HathiTrust)."
  echo ""
  echo "OPTIONS"
  echo "  -s, --search <term>    Search term to append to the page scan URL"
  echo "  -c, --chapter <spec>   Open the scan at a chapter by searching for the"
  echo "                         first sentence of its first paragraph. <spec> is"
  echo "                         a chapter number (chapter-N.xhtml) or a filename"
  echo "                         under src/epub/text/. Conflicts with --search."
  echo "  -l, --list             List URLs without opening them"
  echo "      --id <id|url>      Use this Internet Archive item instead of the"
  echo "                         ones in content.opf. Accepts a bare identifier"
  echo "                         or a full archive.org/details/<id> URL."
  echo "  <ebook-directory>      Path to the ebook project root (default: .)"
  echo ""
  echo "EXAMPLES"
  echo "  se-ext page-scans"
  echo "  se-ext page-scans --search \"Chapter IV\""
  echo "  se-ext page-scans --chapter 4               # open at chapter 4"
  echo "  se-ext page-scans --chapter preface.xhtml   # open at the preface"
  echo "  se-ext page-scans --list /path/to/ebook"
  echo "  se-ext page-scans --id someotheritem        # override source"
  exit 0
fi

SEARCH_TERM=""
CHAPTER=""
LIST_ONLY=false
EBOOK_DIR=""
IA_ID_OVERRIDE=""

while [ $# -gt 0 ]; do
  case "$1" in
    -s|--search)
      SEARCH_TERM="$2"
      shift 2
      ;;
    -c|--chapter)
      if [ -z "$2" ]; then
        echo "Error: --chapter requires an argument." >&2
        exit 2
      fi
      CHAPTER="$2"
      shift 2
      ;;
    --chapter=*)
      CHAPTER="${1#--chapter=}"
      shift
      ;;
    -l|--list)
      LIST_ONLY=true
      shift
      ;;
    --id)
      if [ -z "$2" ]; then
        echo "Error: --id requires an argument." >&2
        exit 2
      fi
      IA_ID_OVERRIDE="$2"
      shift 2
      ;;
    --id=*)
      IA_ID_OVERRIDE="${1#--id=}"
      shift
      ;;
    -*)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
    *)
      EBOOK_DIR="$1"
      shift
      ;;
  esac
done

if [ -n "$SEARCH_TERM" ] && [ -n "$CHAPTER" ]; then
  echo "Error: --search and --chapter are mutually exclusive." >&2
  exit 2
fi

# --chapter reads the chapter XHTML, so the ebook directory is needed even
# when --id overrides the scan source.
EBOOK_DIR="${EBOOK_DIR:-.}"

# Reduce an archive.org/details/<id> URL (or a bare identifier) to the identifier.
normalize_ia_id() {
  local id="$1"
  case "$id" in
    *archive.org/details/*)
      id="${id#*archive.org/details/}"
      id="${id%%/*}"
      id="${id%%\?*}"
      ;;
  esac
  printf '%s' "$id"
}

if [ -n "$IA_ID_OVERRIDE" ]; then
  # --id supplies the source directly, so content.opf is not consulted.
  IA_ID=$(normalize_ia_id "$IA_ID_OVERRIDE")
  if [ -z "$IA_ID" ]; then
    echo "Error: could not parse an Internet Archive identifier from --id '$IA_ID_OVERRIDE'." >&2
    exit 2
  fi
  PAGE_SCANS="https://archive.org/details/$IA_ID"
else
  OPF="$EBOOK_DIR/src/epub/content.opf"

  if [ ! -f "$OPF" ]; then
    echo "Error: content.opf not found at $OPF" >&2
    echo "Are you in a Standard Ebooks project directory?" >&2
    exit 1
  fi

  # Extract all dc:source URLs
  SOURCES=$(grep -oP '(?<=<dc:source>)[^<]+' "$OPF")

  if [ -z "$SOURCES" ]; then
    echo "No dc:source entries found in $OPF" >&2
    exit 1
  fi

  # Filter to page scan URLs (exclude Gutenberg transcription sources and Wikisource)
  PAGE_SCANS=""
  while IFS= read -r url; do
    case "$url" in
      *gutenberg.org*) ;;
      *wikisource.org*) ;;
      *) PAGE_SCANS="${PAGE_SCANS:+$PAGE_SCANS
}$url" ;;
    esac
  done <<< "$SOURCES"

  if [ -z "$PAGE_SCANS" ]; then
    echo "No page scan URLs found (only transcription sources)." >&2
    echo "All sources:" >&2
    echo "$SOURCES" >&2
    exit 1
  fi
fi

# Resolve a --chapter spec to a file under src/epub/text/. Accepts a bare
# number (chapter-4 -> chapter-4.xhtml), a filename with or without the
# .xhtml extension, or an explicit path.
resolve_chapter_file() {
  local spec="$1" textdir="$EBOOK_DIR/src/epub/text" f
  for f in "$spec" "$textdir/$spec" "$textdir/$spec.xhtml" \
           "$textdir/chapter-$spec.xhtml"; do
    if [ -f "$f" ]; then
      printf '%s' "$f"
      return 0
    fi
  done
  return 1
}

# Derive a search phrase from a chapter file: the first sentence (capped at
# eight words) of the first <p> after the chapter header. The phrase is
# normalized to plain ASCII words, since it is matched against OCR text by
# the scan site's search, which is loose about punctuation anyway.
chapter_phrase() {
  local file="$1" line
  # se clean keeps each <p> on a single line, so the first matching line is
  # the whole first paragraph. Skip <p> lines inside <header> or <hgroup>
  # (chapter titles live in a <p epub:type="title"> there, and title text
  # also appears in the book's index/TOC pages, so searching for it lands on
  # the wrong page), then strip tags, decode the entities SE sources use,
  # cut at the first sentence-ending punctuation, drop everything but plain
  # words, and keep the first eight.
  line=$(awk '/<(header|hgroup)[ >]/   { intitle = 1 }
              /<\/(header|hgroup)>/    { intitle = 0; next }
              /<p[ >]/                 { if (!intitle) { print; exit } }' "$file")
  [ -n "$line" ] || return 1
  printf '%s\n' "$line" | sed \
    -e 's/<[^>]*>//g' \
    -e 's/&amp;/\&/g; s/&lt;/</g; s/&gt;/>/g' \
    -e "s/’/'/g" \
    | awk '{ # Cut at the end of the first sentence, unless that leaves
             # fewer than three words (e.g. a leading abbreviation like
             # "Mr."), in which case keep the whole paragraph.
             s = $0
             if (match(s, /[.!?]/) && split(substr(s, 1, RSTART - 1), w0) >= 3)
               s = substr(s, 1, RSTART - 1)
             gsub(/[^a-zA-Z0-9'\'' -]/, " ", s)
             n = split(s, w)
             if (n > 8) n = 8
             out = ""
             for (i = 1; i <= n; i++) out = out (i > 1 ? " " : "") w[i]
             print out }'
}

if [ -n "$CHAPTER" ]; then
  if ! CHAPTER_FILE=$(resolve_chapter_file "$CHAPTER"); then
    echo "Error: could not find a chapter file for '$CHAPTER' under $EBOOK_DIR/src/epub/text/." >&2
    exit 1
  fi
  if ! SEARCH_TERM=$(chapter_phrase "$CHAPTER_FILE") || [ -z "$SEARCH_TERM" ]; then
    echo "Error: could not extract an opening phrase from $CHAPTER_FILE." >&2
    exit 1
  fi
  echo "Searching for: \"$SEARCH_TERM\" (from $(basename "$CHAPTER_FILE"))" >&2
fi

# Append search term to URL where supported
append_search() {
  local url="$1"
  local term="$2"
  # Wrap in double quotes for exact phrase matching
  local quoted="\"$term\""
  local encoded=""
  local i char ord
  for (( i = 0; i < ${#quoted}; i++ )); do
    char="${quoted:i:1}"
    case "$char" in
      [a-zA-Z0-9._~-]) encoded+="$char" ;;
      ' ') encoded+="%20" ;;
      *) printf -v ord '%02X' "'$char"; encoded+="%$ord" ;;
    esac
  done

  case "$url" in
    *archive.org/details/*)
      echo "${url%/}/mode/1up?q=${encoded}"
      ;;
    *books.google.com/*)
      if [[ "$url" == *"?"* ]]; then
        echo "${url}&q=${encoded}"
      else
        echo "${url}?q=${encoded}"
      fi
      ;;
    *hathitrust.org/*)
      echo "${url}?q1=${encoded}"
      ;;
    *)
      echo "$url"
      ;;
  esac
}

while IFS= read -r url; do
  if [ -n "$SEARCH_TERM" ]; then
    url=$(append_search "$url" "$SEARCH_TERM")
  fi

  if [ "$LIST_ONLY" = true ]; then
    echo "$url"
  else
    echo "Opening: $url"
    xdg-open "$url" >/dev/null 2>&1 &
  fi
done <<< "$PAGE_SCANS"
