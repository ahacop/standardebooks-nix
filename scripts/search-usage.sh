#!/usr/bin/env bash

if [ -z "$1" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "Usage: se-search-usage <search-term> [context-term] [--limit N]"
  echo ""
  echo "Search the Standard Ebooks GitHub org for real-world usage of semantic"
  echo "tags and patterns across published ebooks. Results are sorted by repo"
  echo "update date (newest first) so you can see current conventions."
  echo ""
  echo "EXAMPLES"
  echo "  se-search-usage 'z3998:nationality'              All nationality tag usage"
  echo "  se-search-usage 'z3998:nationality' 'Turkish'    Nationality tags near 'Turkish'"
  echo "  se-search-usage 'z3998:place'                    All place tag usage"
  echo "  se-search-usage 'se:name.vessel'                 Ship/vessel name tags"
  echo "  se-search-usage 'epub:type' 'z3998:' --limit 5   Any epub:type with z3998"
  echo ""
  echo "OPTIONS"
  echo "  --limit N   Show at most N repos (default: 10)"
  echo "  --full      Fetch file contents for richer context around each match"
  exit 0
fi

SEARCH_TERM="$1"
CONTEXT_TERM=""
LIMIT=10
FULL_MODE=false

shift
while [ $# -gt 0 ]; do
  case "$1" in
    --limit) LIMIT="$2"; shift 2 ;;
    --full) FULL_MODE=true; shift ;;
    --help|-h) exec se-search-usage ;;
    *) CONTEXT_TERM="$1"; shift ;;
  esac
done

# Build the search query
QUERY="\"$SEARCH_TERM\" org:standardebooks"
if [ -n "$CONTEXT_TERM" ]; then
  QUERY="\"$SEARCH_TERM\" \"$CONTEXT_TERM\" org:standardebooks"
fi

echo "Searching SE org for: $SEARCH_TERM${CONTEXT_TERM:+ (near \"$CONTEXT_TERM\")}"
echo ""

# URL-encode the query
ENCODED_QUERY=$(python3 -c "import sys,urllib.parse;print(urllib.parse.quote(sys.stdin.read().strip()))" <<< "$QUERY")

# Search and get results with repo info
RESULTS=$(gh api "search/code?q=${ENCODED_QUERY}&per_page=100" 2>&1)

TOTAL=$(echo "$RESULTS" | jq -r '.total_count // 0')
echo "Found $TOTAL matches"
echo ""

if [ "$TOTAL" = "0" ]; then
  exit 0
fi

# Extract unique repos and their files
REPO_FILES=$(echo "$RESULTS" | jq -r '.items[] | "\(.repository.full_name)\t\(.path)\t\(.name)"')

# Get unique repos
REPOS=$(echo "$REPO_FILES" | cut -f1 | sort -u)

# For each repo, get its updated date and sort by it
REPO_DATES=""
for REPO in $REPOS; do
  UPDATED=$(gh api "repos/$REPO" --jq '.pushed_at // .updated_at' 2>/dev/null)
  REPO_DATES="${REPO_DATES}${UPDATED}\t${REPO}\n"
done

# Sort repos newest first, limit output
SORTED_REPOS=$(printf '%b' "$REPO_DATES" | sort -r | head -n "$LIMIT")

printf '%b' "$SORTED_REPOS" | while IFS="$(printf '\t')" read -r DATE REPO; do
  [ -z "$REPO" ] && continue
  SHORT_DATE=$(echo "$DATE" | cut -c1-10)
  SHORT_NAME=${REPO#standardebooks/}

  echo "── $SHORT_NAME (updated $SHORT_DATE) ──"

  # List matching files in this repo
  echo "$REPO_FILES" | awk -F'\t' -v repo="$REPO" '$1 == repo { print "  " $2 }'

  if [ "$FULL_MODE" = "true" ]; then
    # Fetch content of first matching file for context
    FIRST_FILE=$(echo "$REPO_FILES" | awk -F'\t' -v repo="$REPO" '$1 == repo { print $2; exit }')
    if [ -n "$FIRST_FILE" ]; then
      CONTENT=$(gh api "repos/$REPO/contents/$FIRST_FILE" --jq '.content' 2>/dev/null | base64 -d 2>/dev/null)
      if [ -n "$CONTENT" ]; then
        echo "$CONTENT" | grep -i "$SEARCH_TERM" | head -n 5 | while read -r LINE; do
          # Trim whitespace and show a snippet
          TRIMMED=$(echo "$LINE" | sed 's/^[[:space:]]*//' | cut -c1-120)
          echo "    $TRIMMED"
        done
      fi
    fi
  fi

  echo ""
done
