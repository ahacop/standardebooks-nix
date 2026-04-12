#!/usr/bin/env bash

if [ -z "$1" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "Usage: se-ext modernize-spelling <ebook-directory>"
  echo ""
  echo "Apply archaic-to-modern spelling replacements from the word list to an"
  echo "ebook project's XHTML text files."
  echo ""
  echo "All replacements are applied automatically. The word list is curated"
  echo "via the /modernize-spellings skill before running this command."
  echo ""
  echo "The word list is at: ${SE_EXT_DATA:-<SE_EXT_DATA>}/modernize-spelling.tsv"
  echo "Add new archaic/modern pairs there (tab-separated, one per line)."
  echo ""
  echo "Example: se-ext modernize-spelling /path/to/charles-brockden-brown_wieland"
  exit 0
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

# Case-aware replacement: for each archaic→modern pair, replace lowercase,
# Title Case, and UPPER CASE variants using sed with word boundaries.

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

  local -a pairs=()
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

    # Check if any files contain matches before running sed
    # shellcheck disable=SC2086
    if grep -Plq "$pat" $TEXT_FILES 2>/dev/null; then
      # shellcheck disable=SC2086
      sed -i -E "s/$pat/$rep/g" $TEXT_FILES
      echo "Replaced: $pat -> $rep"
    fi
  done
}

count=0
replaced=0
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
