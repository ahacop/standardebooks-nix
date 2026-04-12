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
  echo "  -l, --list             List URLs without opening them"
  echo "  <ebook-directory>      Path to the ebook project root (default: .)"
  echo ""
  echo "EXAMPLES"
  echo "  se-ext page-scans"
  echo "  se-ext page-scans --search \"Chapter IV\""
  echo "  se-ext page-scans --list /path/to/ebook"
  exit 0
fi

SEARCH_TERM=""
LIST_ONLY=false
EBOOK_DIR=""

while [ $# -gt 0 ]; do
  case "$1" in
    -s|--search)
      SEARCH_TERM="$2"
      shift 2
      ;;
    -l|--list)
      LIST_ONLY=true
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

EBOOK_DIR="${EBOOK_DIR:-.}"
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
      echo "${url}?ui=theater&view=1up&q=${encoded}"
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
    xdg-open "$url" 2>/dev/null &
  fi
done <<< "$PAGE_SCANS"
