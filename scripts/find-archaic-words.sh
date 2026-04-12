#!/usr/bin/env bash

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "Usage: se-ext find-archaic-words [<ebook-directory>]"
  echo ""
  echo "Find archaic/obsolete spellings in an ebook that aren't yet in the"
  echo "modernize-spelling word list. Words are checked against both aspell"
  echo "en_US and en_GB dictionaries — only words missing from BOTH are flagged."
  echo ""
  echo "Outputs a TSV list of candidates with context lines to stdout."
  echo ""
  echo "OPTIONS"
  echo "  <ebook-directory>  Path to the ebook project root (default: .)"
  echo ""
  echo "Example: se-ext find-archaic-words /path/to/charles-brockden-brown_wieland"
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

# Collect all XHTML text files
TEXT_FILES=()
while IFS= read -r f; do
  TEXT_FILES+=("$f")
done < <(find "$TEXT_DIR" -maxdepth 1 -name "*.xhtml" | sort)

if [ ${#TEXT_FILES[@]} -eq 0 ]; then
  echo "Error: No XHTML files found in $TEXT_DIR" >&2
  exit 1
fi

# Extract all words from XHTML text (strip tags first), preserving case info
STRIPPED=$(sed -e 's/<[^>]*>//g' "${TEXT_FILES[@]}")

# Step 1: Build set of words that only appear capitalized (proper nouns)
CAPITALIZED=$(echo "$STRIPPED" | grep -oP "[a-zA-Z][a-zA-Z'-]*[a-zA-Z]" | grep -P '^[A-Z]' | tr '[:upper:]' '[:lower:]' | sort -u)
LOWERCASE_WORDS=$(echo "$STRIPPED" | grep -oP "[a-zA-Z][a-zA-Z'-]*[a-zA-Z]" | grep -P '^[a-z]' | sort -u)
PROPER_NOUNS=$(comm -23 <(echo "$CAPITALIZED") <(echo "$LOWERCASE_WORDS"))

# Step 2: Get all unique words lowercased for spell checking
ALL_LOWER=$(echo "$STRIPPED" | grep -oP "[a-zA-Z][a-zA-Z'-]*[a-zA-Z]" | tr '[:upper:]' '[:lower:]' | sort -u)

# Step 3: Build set of known archaic words from the word list
KNOWN_ARCHAIC=$(cut -f1 "$WORD_LIST" | grep -v '^#' | grep -v '^$' | sort -u)

# Step 4: Check against en_US and en_GB — keep only words unknown to BOTH
UNKNOWN_US=$(echo "$ALL_LOWER" | aspell list -l en_US 2>/dev/null | sort -u)
UNKNOWN_GB=$(echo "$ALL_LOWER" | aspell list -l en_GB 2>/dev/null | sort -u)
UNKNOWN_BOTH=$(comm -12 <(echo "$UNKNOWN_US") <(echo "$UNKNOWN_GB"))

# Step 5: Filter out proper nouns and known archaic words
CANDIDATES=$(comm -23 <(echo "$UNKNOWN_BOTH") <(echo "$PROPER_NOUNS"))
CANDIDATES=$(comm -23 <(echo "$CANDIDATES") <(echo "$KNOWN_ARCHAIC"))

# Filter out very short words (artifacts)
CANDIDATES=$(echo "$CANDIDATES" | awk 'length >= 3')

if [ -z "$CANDIDATES" ] || ! echo "$CANDIDATES" | grep -q .; then
  echo "No archaic word candidates found." >&2
  exit 0
fi

# Output TSV: word<TAB>context
while IFS= read -r word; do
  [ -z "$word" ] && continue
  CONTEXT=$(grep -rihP --include='*.xhtml' -m1 "\b${word}\b" "$TEXT_DIR" 2>/dev/null | sed -e 's/<[^>]*>//g' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | head -1)
  printf '%s\t%s\n' "$word" "$CONTEXT"
done <<< "$CANDIDATES"
