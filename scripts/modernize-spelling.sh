#!/usr/bin/env bash

if [ -z "$1" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "Usage: se-ext modernize-spelling [--yes] [<ebook-directory>]"
  echo ""
  echo "Apply archaic-to-modern spelling replacements from the word list to an"
  echo "ebook project's XHTML text files."
  echo ""
  echo "Each replacement is shown interactively via 'se interactive-replace' so"
  echo "you can review context before accepting. Use --yes to apply all replacements"
  echo "without confirmation."
  echo ""
  echo "OPTIONS"
  echo "  --yes    Apply all replacements without interactive confirmation"
  echo ""
  echo "The word list is at: ${SE_EXT_DATA:-<SE_EXT_DATA>}/modernize-spelling.tsv"
  echo "Add new archaic/modern pairs there (tab-separated, one per line)."
  echo ""
  echo "Example: se-ext modernize-spelling /path/to/charles-brockden-brown_wieland"
  exit 0
fi

AUTO=0
if [ "$1" = "--yes" ]; then
  AUTO=1
  shift
fi

EBOOK_DIR="${1:-.}"
TEXT_DIR="$EBOOK_DIR/src/epub/text"

if [ ! -d "$TEXT_DIR" ]; then
  echo "Error: Directory not found: $TEXT_DIR" >&2
  exit 1
fi

WORD_LIST="${SE_EXT_DATA:?SE_EXT_DATA not set}/modernize-spelling.tsv"

if [ ! -f "$WORD_LIST" ]; then
  echo "Error: Word list not found: $WORD_LIST" >&2
  exit 1
fi

# Find all XHTML text files
TEXT_FILES=$(find "$TEXT_DIR" -name "*.xhtml" | sort)

if [ -z "$TEXT_FILES" ]; then
  echo "Error: No XHTML files found in $TEXT_DIR" >&2
  exit 1
fi

# Case-aware replacement: build a regex that captures the archaic word and
# a sed expression that transfers the original's case pattern to the modern word.
# We handle three cases: ALL CAPS, Title Case, and lowercase.

apply_pair() {
  local archaic="$1"
  local modern="$2"

  # Build case variants
  local arch_lower arch_title arch_upper
  local mod_lower mod_title mod_upper
  arch_lower="$archaic"
  arch_title="$(echo "${archaic:0:1}" | tr '[:lower:]' '[:upper:]')${archaic:1}"
  arch_upper="$(echo "$archaic" | tr '[:lower:]' '[:upper:]')"
  mod_lower="$modern"
  mod_title="$(echo "${modern:0:1}" | tr '[:lower:]' '[:upper:]')${modern:1}"
  mod_upper="$(echo "$modern" | tr '[:lower:]' '[:upper:]')"

  # Build regex alternation: Title|UPPER|lower (title before lower so it matches first)
  local regex="\\b($arch_title|$arch_upper|$arch_lower)\\b"

  # Conditional replacement using regex group
  # Python regex replacement can use a function, but se interactive-replace
  # takes a static replacement string. So we run up to 3 passes for each case.

  local -a pairs=()
  # Only add variants that differ from each other
  pairs+=("\\b$arch_title\\b" "$mod_title")
  if [ "$arch_upper" != "$arch_title" ]; then
    pairs+=("\\b$arch_upper\\b" "$mod_upper")
  fi
  if [ "$arch_lower" != "$arch_title" ]; then
    pairs+=("\\b$arch_lower\\b" "$mod_lower")
  fi

  local i=0
  while [ $i -lt ${#pairs[@]} ]; do
    local pat="${pairs[$i]}"
    local rep="${pairs[$((i + 1))]}"
    i=$((i + 2))

    # Check if any files contain matches before launching interactive-replace
    # shellcheck disable=SC2086
    if grep -Plq "$pat" $TEXT_FILES 2>/dev/null; then
      if [ "$AUTO" -eq 1 ]; then
        # Non-interactive: use sed for direct replacement
        # shellcheck disable=SC2086
        sed -i -E "s/$pat/$rep/g" $TEXT_FILES
        echo "Replaced: $pat -> $rep"
      else
        echo ""
        echo "--- $pat -> $rep ---"
        # shellcheck disable=SC2086
        se interactive-replace "$pat" "$rep" $TEXT_FILES
      fi
    fi
  done
}

count=0
while IFS=$'\t' read -r archaic modern || [ -n "$archaic" ]; do
  # Skip empty lines and comments
  [ -z "$archaic" ] && continue
  [[ "$archaic" == \#* ]] && continue

  apply_pair "$archaic" "$modern"
  count=$((count + 1))
done < "$WORD_LIST"

echo ""
echo "Processed $count word pairs from $WORD_LIST"
echo ""
echo "To find new archaic spelling candidates, run:"
echo "  se-ext find-archaic-words <ebook-directory>"
echo ""
echo "Then use /modernize-spellings to review and add them to the word list."
