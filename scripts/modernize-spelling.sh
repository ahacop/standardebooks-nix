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

# Verify we're inside a git repo
if ! git -C "$EBOOK_DIR" rev-parse --git-dir >/dev/null 2>&1; then
  echo "Error: $EBOOK_DIR is not inside a git repository" >&2
  exit 1
fi

# Read word pairs and sort longest-first to avoid substring conflicts
# (e.g., "faultering" must be processed before "faulter")
pairs=()
while IFS=$'\t' read -r archaic modern || [ -n "$archaic" ]; do
  [ -z "$archaic" ] && continue
  [[ "$archaic" == \#* ]] && continue
  pairs+=("$archaic	$modern")
done < "$WORD_LIST"

mapfile -t sorted < <(for p in "${pairs[@]}"; do echo "$p"; done | awk -F'\t' '{print length($1), $0}' | sort -rnk1 | cut -d' ' -f2-)

# For each word pair, replace all case variants and commit if changes were made.

apply_and_commit() {
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

  local -a variants=()
  variants+=("\\b$arch_title\\b" "$mod_title")
  if [ "$arch_upper" != "$arch_title" ]; then
    variants+=("\\b$arch_upper\\b" "$mod_upper")
  fi
  if [ "$arch_lower" != "$arch_title" ]; then
    variants+=("\\b$arch_lower\\b" "$mod_lower")
  fi

  local found=false
  local i=0
  while [ $i -lt ${#variants[@]} ]; do
    local pat="${variants[$i]}"
    local rep="${variants[$((i + 1))]}"
    i=$((i + 2))

    # shellcheck disable=SC2086
    if grep -Plq "$pat" $TEXT_FILES 2>/dev/null; then
      # shellcheck disable=SC2086
      sed -i -E "s/$pat/$rep/g" $TEXT_FILES
      found=true
    fi
  done

  if [ "$found" = true ]; then
    git -C "$EBOOK_DIR" add src/epub/text/
    git -C "$EBOOK_DIR" commit -m "[Editorial] $archaic -> $modern" --quiet
    echo "Committed: [Editorial] $archaic -> $modern"
    return 0
  fi

  return 1
}

count=0
committed=0
for entry in "${sorted[@]}"; do
  archaic="${entry%%	*}"
  modern="${entry#*	}"

  apply_and_commit "$archaic" "$modern" && committed=$((committed + 1))
  count=$((count + 1))
done

echo ""
echo "Processed $count word pairs, committed $committed changes."
