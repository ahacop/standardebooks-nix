#!/usr/bin/env bash

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "Usage: se-ext preview [options] [<ebook-directory>]"
  echo ""
  echo "Build the ebook with 'se build' and open the resulting .epub"
  echo "in the system default reader via xdg-open."
  echo ""
  echo "OPTIONS"
  echo "  -o, --output-dir <dir>  Build output directory (default: a temp dir)"
  echo "  -a, --advanced          Open the advanced .epub instead of the compatible one"
  echo "  <ebook-directory>       Path to the ebook project root (default: .)"
  exit 0
fi

OUTPUT_DIR=""
OPEN_ADVANCED=false
EBOOK_DIR=""

while [ $# -gt 0 ]; do
  case "$1" in
    -o|--output-dir)
      OUTPUT_DIR="$2"
      shift 2
      ;;
    -a|--advanced)
      OPEN_ADVANCED=true
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

if [ ! -f "$EBOOK_DIR/src/epub/content.opf" ]; then
  echo "Error: $EBOOK_DIR does not look like a Standard Ebooks project." >&2
  echo "Expected src/epub/content.opf to exist." >&2
  exit 1
fi

if ! command -v se >/dev/null 2>&1; then
  echo "Error: 'se' command not found. Install standardebooks via pipx." >&2
  exit 1
fi

if ! command -v xdg-open >/dev/null 2>&1; then
  echo "Error: 'xdg-open' command not found." >&2
  exit 1
fi

if [ -z "$OUTPUT_DIR" ]; then
  OUTPUT_DIR="$(mktemp -d -t se-preview.XXXXXX)"
fi

mkdir -p "$OUTPUT_DIR"

echo "Building ebook in $OUTPUT_DIR..."
se build --output-dir "$OUTPUT_DIR" "$EBOOK_DIR"

# Pick the epub to open. 'se build' produces both a compatible .epub and an
# advanced *_advanced.epub in the output directory.
if [ "$OPEN_ADVANCED" = true ]; then
  EPUB=$(find "$OUTPUT_DIR" -maxdepth 1 -name '*_advanced.epub' -print -quit)
else
  EPUB=$(find "$OUTPUT_DIR" -maxdepth 1 -name '*.epub' ! -name '*_advanced.epub' ! -name '*.kepub.epub' -print -quit)
fi

if [ -z "$EPUB" ] || [ ! -f "$EPUB" ]; then
  echo "Error: no built .epub found in $OUTPUT_DIR" >&2
  exit 1
fi

echo "Opening: $EPUB"
xdg-open "$EPUB" >/dev/null 2>&1 &
