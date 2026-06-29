#!/usr/bin/env bash

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "Usage: se-ext cover [options] [<ebook-directory>]"
  echo ""
  echo "Render the ebook cover — the cover art with the title and author"
  echo "text — to an optimized PNG."
  echo ""
  echo "By default this renders the built cover at src/epub/images/cover.svg,"
  echo "in which the title/author text has been converted to paths and the"
  echo "cover art is embedded, so no fonts or other files are needed. Run"
  echo "'se build-images' first if that file is missing. If it is absent the"
  echo "editable source images/cover.svg is used instead, which needs the"
  echo "League Spartan font installed to render the text correctly."
  echo ""
  echo "OPTIONS"
  echo "  -o, --output <file>   Output PNG path (default: cover.png in the"
  echo "                        current directory)"
  echo "  -w, --width <px>      Output width in pixels; the height scales to"
  echo "                        keep the 1400×2100 (2:3) aspect ratio"
  echo "                        (default: 1400, the native cover width)"
  echo "  -s, --source          Render the editable images/cover.svg instead"
  echo "                        of the built src/epub/images/cover.svg"
  echo "  -O, --open            Open the PNG after writing it (xdg-open)"
  echo "  <ebook-directory>     Path to the ebook project root (default: .)"
  echo ""
  echo "EXAMPLES"
  echo "  se-ext cover                       # cover.png at full resolution"
  echo "  se-ext cover -w 600 -o thumb.png   # 600px-wide thumbnail"
  echo "  se-ext cover --open /path/to/ebook"
  exit 0
fi

OUTPUT=""
WIDTH=""
USE_SOURCE=false
OPEN_AFTER=false
EBOOK_DIR=""

while [ $# -gt 0 ]; do
  case "$1" in
    -o|--output)
      if [ -z "$2" ]; then
        echo "Error: --output requires an argument." >&2
        exit 2
      fi
      OUTPUT="$2"
      shift 2
      ;;
    --output=*)
      OUTPUT="${1#--output=}"
      shift
      ;;
    -w|--width)
      if [ -z "$2" ]; then
        echo "Error: --width requires an argument." >&2
        exit 2
      fi
      WIDTH="$2"
      shift 2
      ;;
    --width=*)
      WIDTH="${1#--width=}"
      shift
      ;;
    -s|--source)
      USE_SOURCE=true
      shift
      ;;
    -O|--open)
      OPEN_AFTER=true
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
OUTPUT="${OUTPUT:-cover.png}"

if [ -n "$WIDTH" ] && ! [[ "$WIDTH" =~ ^[1-9][0-9]*$ ]]; then
  echo "Error: --width must be a positive integer (got '$WIDTH')." >&2
  exit 2
fi

if [ ! -f "$EBOOK_DIR/src/epub/content.opf" ]; then
  echo "Error: $EBOOK_DIR does not look like a Standard Ebooks project." >&2
  echo "Expected src/epub/content.opf to exist." >&2
  exit 1
fi

if ! command -v rsvg-convert >/dev/null 2>&1; then
  echo "Error: 'rsvg-convert' command not found." >&2
  exit 1
fi

if ! command -v oxipng >/dev/null 2>&1; then
  echo "Error: 'oxipng' command not found." >&2
  exit 1
fi

# Pick the cover SVG. The built src/epub/images/cover.svg is self-contained
# (text as paths, art embedded) and is preferred. images/cover.svg is the
# editable source; it references images/cover.jpg and needs the League
# Spartan font to render the title text.
BUILT_SVG="$EBOOK_DIR/src/epub/images/cover.svg"
SOURCE_SVG="$EBOOK_DIR/images/cover.svg"

if [ "$USE_SOURCE" = true ]; then
  SVG="$SOURCE_SVG"
  if [ ! -f "$SVG" ]; then
    echo "Error: source cover not found at $SVG" >&2
    exit 1
  fi
elif [ -f "$BUILT_SVG" ]; then
  SVG="$BUILT_SVG"
elif [ -f "$SOURCE_SVG" ]; then
  SVG="$SOURCE_SVG"
  echo "Note: $BUILT_SVG not found; rendering $SOURCE_SVG instead." >&2
  echo "      Run 'se build-images' for a font-independent cover." >&2
else
  echo "Error: no cover SVG found." >&2
  echo "Looked for $BUILT_SVG and $SOURCE_SVG." >&2
  exit 1
fi

# Render the SVG to PNG. rsvg-convert resolves any relative href (the source
# SVG's cover.jpg) against the SVG's own directory, so no cwd juggling needed.
RSVG_ARGS=(--format png --output "$OUTPUT")
if [ -n "$WIDTH" ]; then
  RSVG_ARGS+=(--width "$WIDTH" --keep-aspect-ratio)
fi

# Show the SVG path relative to the ebook dir so the built and source covers
# (both named cover.svg) are distinguishable in the output.
echo "Rendering ${SVG#"$EBOOK_DIR"/} → $OUTPUT..."
if ! rsvg-convert "${RSVG_ARGS[@]}" "$SVG"; then
  echo "Error: rsvg-convert failed to render the cover." >&2
  exit 1
fi

# Losslessly optimize the PNG in place. A photographic cover won't shrink
# dramatically, but oxipng strips bloat and picks the best filters/compression.
oxipng --opt max --strip safe --quiet "$OUTPUT"

DIMENSIONS=""
if command -v identify >/dev/null 2>&1; then
  DIMENSIONS=$(identify -format '%wx%h' "$OUTPUT" 2>/dev/null)
fi
SIZE=$(du -h "$OUTPUT" | cut -f1)
echo "Wrote $OUTPUT${DIMENSIONS:+ ($DIMENSIONS)}, $SIZE"

if [ "$OPEN_AFTER" = true ]; then
  if command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$OUTPUT" >/dev/null 2>&1 &
  else
    echo "Note: 'xdg-open' not found; cannot open $OUTPUT." >&2
  fi
fi
