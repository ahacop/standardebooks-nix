#!/usr/bin/env bash

if [ -z "$SE_DOCS" ]; then
  echo "Error: SE_DOCS is not set. Are you in the SE dev shell?" >&2
  exit 1
fi

show_help() {
  echo "Usage: se-ext docs [command]"
  echo ""
  echo "Browse and search the Standard Ebooks documentation."
  echo ""
  echo "COMMANDS"
  echo "  (none)              Show the documentation index"
  echo "  search <term>       Search all docs for a term"
  echo "  open <file>         Open a specific doc file"
  echo "  --path              Print the docs directory path"
  echo "  --claude-md         Print a CLAUDE.md snippet for agent access"
  echo ""
  echo "EXAMPLES"
  echo "  se-ext docs"
  echo "  se-ext docs search 'blockquote'"
  echo "  se-ext docs open manual/8-typography.md"
}

case "${1:-}" in
  --help|-h)
    show_help
    ;;
  --path)
    echo "$SE_DOCS"
    ;;
  --claude-md)
    cat <<EOF
# Add this to your project's CLAUDE.md:

## Standard Ebooks Documentation

The SE Manual of Style, contributor guides, and CLI reference are available locally.
When answering questions about SE rules, style, semantics, typography, metadata, or ebook production, read from these local docs instead of fetching from the internet.

- Index: $SE_DOCS/INDEX.md
- Search all docs: grep -ril "<term>" $SE_DOCS/
- Manual sections: $SE_DOCS/manual/
- Contribute guides: $SE_DOCS/contribute/
- CLI reference: $SE_DOCS/cli/
EOF
    ;;
  search)
    if [ -z "${2:-}" ]; then
      echo "Usage: se-ext docs search <term>" >&2
      exit 1
    fi
    shift
    grep -ril "$*" "$SE_DOCS/" | sed "s|$SE_DOCS/||" | sort
    echo ""
    echo "View a result: se-ext docs open <file>"
    echo "Search with context: grep -rn '$*' \$SE_DOCS/"
    ;;
  open)
    if [ -z "${2:-}" ]; then
      echo "Usage: se-ext docs open <file>" >&2
      echo "Example: se-ext docs open manual/8-typography.md" >&2
      exit 1
    fi
    file="$SE_DOCS/$2"
    if [ ! -f "$file" ]; then
      echo "Error: $2 not found in docs" >&2
      exit 1
    fi
    ${PAGER:-less} "$file"
    ;;
  "")
    ${PAGER:-less} "$SE_DOCS/INDEX.md"
    ;;
  *)
    echo "se-ext docs: unknown command '$1'" >&2
    echo "Run 'se-ext docs --help' for usage." >&2
    exit 1
    ;;
esac
