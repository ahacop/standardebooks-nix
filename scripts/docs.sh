#!/usr/bin/env bash

if [ -z "$SE_DOCS" ]; then
  echo "Error: SE_DOCS is not set. Are you in the SE dev shell?" >&2
  exit 1
fi

show_help() {
  cat <<'EOF'
Usage: se-ext docs [command] [args]

Browse and search the Standard Ebooks documentation.

COMMANDS
  (none)                        Alias for `index`
  index                         Show the documentation index
  search <term>                 Grep all docs (with line numbers and context)
  open <file>                   Print a doc file
  headings <file>               List the headings in a file with line numbers
  section <file> <heading>      Print a single section of a file
  --path                        Print the docs directory path
  --claude-md                   Print a CLAUDE.md snippet for agent access
  --help, -h                    Show this help

<file> may be a path relative to the docs root (e.g. `manual/8-typography.md`)
or an absolute path as emitted by `search`.

<heading> for `section` is a case-insensitive substring of the heading text;
the first match is printed through to the next same-or-higher-level heading.

When stdout is a terminal, `index` and `open` page through $PAGER (default
`less`); when piped or redirected, they dump raw so agents can consume them.

EXAMPLES
  se-ext docs
  se-ext docs search 'blockquote'
  se-ext docs headings manual/4-semantics.md
  se-ext docs section manual/4-semantics.md 'Block-level elements'
  se-ext docs open cli/build.md
EOF
}

# Resolve a file argument to an absolute path inside $SE_DOCS.
# Accepts either a path relative to $SE_DOCS or an already-absolute path.
resolve_doc() {
  local arg="$1"
  if [ -f "$arg" ]; then
    printf '%s\n' "$arg"
  elif [ -f "$SE_DOCS/$arg" ]; then
    printf '%s\n' "$SE_DOCS/$arg"
  else
    return 1
  fi
}

emit_file() {
  local file="$1"
  if [ -t 1 ]; then
    ${PAGER:-less} "$file"
  else
    cat "$file"
  fi
}

claude_md_body() {
  cat <<'EOF'
## Standard Ebooks Documentation

The SE Manual of Style, contributor guides, and CLI reference are available
locally via the `se-ext docs` command. When answering questions about SE rules,
style, semantics, typography, metadata, or ebook production, use these local
docs instead of fetching from the internet.

- Index:             `se-ext docs` (or `se-ext docs index`)
- Search:            `se-ext docs search "<term>"`
- Outline a file:    `se-ext docs headings <file>`
- Extract a section: `se-ext docs section <file> "<heading>"`
- Read a whole file: `se-ext docs open <file>`

Paths emitted by `search` are absolute and can be read directly. `<file>` is
accepted as either a path relative to the docs root (e.g. `manual/8-typography.md`)
or an absolute path.
EOF
}

case "${1:-}" in
  --help|-h)
    show_help
    ;;
  --path)
    echo "$SE_DOCS"
    ;;
  --claude-md)
    echo "# Add this to your project's CLAUDE.md:"
    echo
    claude_md_body
    ;;
  search)
    if [ -z "${2:-}" ]; then
      echo "Usage: se-ext docs search <term>" >&2
      exit 1
    fi
    shift
    grep -rni -C 1 -- "$*" "$SE_DOCS"
    ;;
  open)
    if [ -z "${2:-}" ]; then
      echo "Usage: se-ext docs open <file>" >&2
      echo "Example: se-ext docs open manual/8-typography.md" >&2
      exit 1
    fi
    if ! file=$(resolve_doc "$2"); then
      echo "Error: $2 not found in docs" >&2
      exit 1
    fi
    emit_file "$file"
    ;;
  headings)
    if [ -z "${2:-}" ]; then
      echo "Usage: se-ext docs headings <file>" >&2
      exit 1
    fi
    if ! file=$(resolve_doc "$2"); then
      echo "Error: $2 not found in docs" >&2
      exit 1
    fi
    grep -nE '^#+ ' "$file"
    ;;
  section)
    if [ -z "${2:-}" ] || [ -z "${3:-}" ]; then
      echo "Usage: se-ext docs section <file> <heading>" >&2
      exit 1
    fi
    if ! file=$(resolve_doc "$2"); then
      echo "Error: $2 not found in docs" >&2
      exit 1
    fi
    output=$(awk -v target="$3" '
      /^#+ / {
        match($0, /^#+/)
        level = RLENGTH
        htext = substr($0, level + 2)
        if (found && level <= depth) { exit }
        if (!found && index(tolower(htext), tolower(target)) > 0) {
          found = 1
          depth = level
        }
      }
      found { print }
    ' "$file")
    if [ -z "$output" ]; then
      echo "Error: no heading matching '$3' found in $2" >&2
      exit 1
    fi
    printf '%s\n' "$output"
    ;;
  index|"")
    emit_file "$SE_DOCS/INDEX.md"
    ;;
  *)
    echo "se-ext docs: unknown command '$1'" >&2
    echo "Run 'se-ext docs --help' for usage." >&2
    exit 1
    ;;
esac
