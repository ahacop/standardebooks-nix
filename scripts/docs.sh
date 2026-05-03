#!/usr/bin/env bash

if [ -z "$SE_DOCS" ]; then
  echo "Error: SE_DOCS is not set. Are you in the SE dev shell?" >&2
  exit 1
fi

# Default scope order. Used as both the search-traversal order and the
# default ranking when no --scope filter is given.
DEFAULT_SCOPES=(manual contribute cli third-party)

show_help() {
  cat <<'EOF'
Usage: se-ext docs [command] [args]

Browse and search the Standard Ebooks documentation.

COMMANDS
  (none)                        Alias for `index`
  index                         Show the documentation index (INDEX.md)
  ls                            List all .md files (paths relative to docs root)
  search [opts] <regex>         Grep all docs (pattern is ERE; see SEARCH OPTIONS)
  open <file>                   Print a doc file
  headings <file>               List the headings in a file with line numbers
  section <file> <heading>      Print a single section of a file
  lines <file> <range>          Print a line range with line numbers prefixed
  --path                        Print the docs directory path
  --claude-md                   Print a CLAUDE.md snippet for agent access
  --help, -h                    Show this help

SEARCH OPTIONS
  -C, --context N               Lines of context around each match (default: 2)
  --scope DIR                   Only search within DIR (manual, contribute, cli,
                                third-party). Repeatable.
  --exclude DIR                 Exclude DIR. Repeatable.
  --absolute                    Print absolute paths instead of relative

The search pattern is passed through to `grep -E`, so it accepts ERE regex.
Use alternation with `|` for multi-term queries, e.g.
    se-ext docs search 'proper noun|toponym|place name'

By default, results are ordered: manual > contribute > cli > third-party, and
paths are printed relative to the docs root. `<file>` accepts either a
relative path (e.g. `manual/8-typography.md`) or an absolute path.

`section`'s heading is a case-insensitive substring; on miss, the closest
matching headings are suggested.

`lines`'s range can be `N` (single line), `N-M` (inclusive), or `N+K`
(K lines starting at N). Output lines are prefixed `<lineno>:` so the
format matches `search` and `headings`.

When stdout is a terminal, `index` and `open` page through $PAGER (default
`less`); when piped or redirected, they dump raw so agents can consume them.

EXAMPLES
  se-ext docs
  se-ext docs ls
  se-ext docs search 'blockquote'
  se-ext docs search --scope manual --context 5 'proper noun|toponym'
  se-ext docs headings manual/4-semantics.md
  se-ext docs section manual/4-semantics.md 'Block-level elements'
  se-ext docs lines manual/8-typography.md 413-460
  se-ext docs lines manual/8-typography.md 413+50
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
- List all files:    `se-ext docs ls`
- Search (ERE):      `se-ext docs search '<regex>'`
                     `se-ext docs search --scope manual --context 5 '<regex>'`
- Outline a file:    `se-ext docs headings <file>`
- Extract a section: `se-ext docs section <file> '<heading>'`
- Read line range:   `se-ext docs lines <file> <N-M | N+K | N>`
- Read a whole file: `se-ext docs open <file>`

Search patterns are passed to `grep -E`, so use `|` for alternation:
`se-ext docs search 'proper noun|toponym|place name'`. By default, results
are ordered manual > contribute > cli > third-party. Use `--scope` or
`--exclude` to filter, and `--context N` to widen surrounding lines.

Paths emitted by `search` are relative to the docs root; pass them straight
to `se-ext docs open` / `headings` / `section` / `lines`. The `lines` command
lets you read any slice of a doc without leaving the CLI, so you should not
need a generic file-read tool for anything under SE_DOCS. Use `--absolute`
on `search` if you do need full paths. `<file>` accepts either form.
EOF
}

# Print all .md files relative to $SE_DOCS, sorted.
list_docs() {
  (cd "$SE_DOCS" && find . -type f -name '*.md' | sed 's|^\./||' | LC_ALL=C sort)
}

# Suggest up to 3 headings whose words overlap with $target.
# Used when `section` finds no substring match.
suggest_headings() {
  local file="$1" target="$2"
  awk -v target="$target" '
    function is_stopword(w) {
      return (w == "and" || w == "the" || w == "for" || w == "are" || \
              w == "with" || w == "but" || w == "not" || w == "from" || \
              w == "this" || w == "that" || w == "into" || w == "when")
    }
    BEGIN {
      n = split(tolower(target), words, /[^a-z0-9]+/)
    }
    /^#+ / {
      match($0, /^#+/)
      level = RLENGTH
      htext = substr($0, level + 2)
      htext_lower = tolower(htext)
      score = 0
      for (i = 1; i <= n; i++) {
        w = words[i]
        if (length(w) >= 3 && !is_stopword(w) && index(htext_lower, w) > 0) {
          score++
        }
      }
      if (score > 0) printf "%d\t%d\t%s\n", score, NR, htext
    }
  ' "$file" | LC_ALL=C sort -rn -k1,1 | head -3 | awk -F'\t' '{ printf "  line %s: %s\n", $2, $3 }'
}

# Run a search across the configured scope dirs.
# Globals consumed: pattern, context, scopes (array), absolute.
run_search() {
  local search_args=()
  if [ "$context" -gt 0 ]; then
    search_args+=(-C "$context")
  fi

  if [ "$absolute" = 1 ]; then
    local paths=()
    for s in "${scopes[@]}"; do
      paths+=("$SE_DOCS/$s")
    done
    grep -rniE "${search_args[@]}" -- "$pattern" "${paths[@]}"
  else
    (cd "$SE_DOCS" && grep -rniE "${search_args[@]}" -- "$pattern" "${scopes[@]}")
  fi
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
  ls)
    list_docs
    ;;
  search)
    shift
    pattern=""
    context=2
    absolute=0
    scopes=()
    excludes=()
    while [ $# -gt 0 ]; do
      case "$1" in
        -C|--context)
          context="$2"; shift 2 ;;
        --context=*)
          context="${1#--context=}"; shift ;;
        --scope)
          scopes+=("$2"); shift 2 ;;
        --scope=*)
          scopes+=("${1#--scope=}"); shift ;;
        --exclude)
          excludes+=("$2"); shift 2 ;;
        --exclude=*)
          excludes+=("${1#--exclude=}"); shift ;;
        --absolute)
          absolute=1; shift ;;
        --)
          shift
          pattern="$*"
          break ;;
        -*)
          echo "se-ext docs search: unknown option '$1'" >&2
          exit 1 ;;
        *)
          if [ -z "$pattern" ]; then
            pattern="$1"
          else
            echo "se-ext docs search: unexpected argument '$1' (pattern already set to '$pattern')" >&2
            exit 1
          fi
          shift ;;
      esac
    done

    if [ -z "$pattern" ]; then
      echo "Usage: se-ext docs search [opts] <regex>" >&2
      echo "Run 'se-ext docs --help' for options." >&2
      exit 1
    fi

    if ! [[ "$context" =~ ^[0-9]+$ ]]; then
      echo "se-ext docs search: --context expects a non-negative integer (got '$context')" >&2
      exit 1
    fi

    # Build effective scope list.
    if [ ${#scopes[@]} -eq 0 ]; then
      scopes=("${DEFAULT_SCOPES[@]}")
    fi
    if [ ${#excludes[@]} -gt 0 ]; then
      filtered=()
      for s in "${scopes[@]}"; do
        skip=0
        for e in "${excludes[@]}"; do
          if [ "$s" = "$e" ]; then skip=1; break; fi
        done
        [ "$skip" = 0 ] && filtered+=("$s")
      done
      scopes=("${filtered[@]}")
    fi
    if [ ${#scopes[@]} -eq 0 ]; then
      echo "se-ext docs search: no scopes left after filtering" >&2
      exit 1
    fi

    # Validate that scopes exist.
    for s in "${scopes[@]}"; do
      if [ ! -d "$SE_DOCS/$s" ]; then
        echo "se-ext docs search: scope '$s' does not exist under $SE_DOCS" >&2
        exit 1
      fi
    done

    run_search
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
      suggestions=$(suggest_headings "$file" "$3")
      if [ -n "$suggestions" ]; then
        echo "Did you mean:" >&2
        printf '%s\n' "$suggestions" >&2
      fi
      exit 1
    fi
    printf '%s\n' "$output"
    ;;
  lines)
    if [ -z "${2:-}" ] || [ -z "${3:-}" ]; then
      echo "Usage: se-ext docs lines <file> <range>" >&2
      echo "Range: N | N-M | N+K (e.g. 42, 100-150, 100+50)" >&2
      exit 1
    fi
    if ! file=$(resolve_doc "$2"); then
      echo "Error: $2 not found in docs" >&2
      exit 1
    fi
    range="$3"
    if [[ "$range" =~ ^([0-9]+)$ ]]; then
      start="${BASH_REMATCH[1]}"; end="$start"
    elif [[ "$range" =~ ^([0-9]+)-([0-9]+)$ ]]; then
      start="${BASH_REMATCH[1]}"; end="${BASH_REMATCH[2]}"
    elif [[ "$range" =~ ^([0-9]+)\+([0-9]+)$ ]]; then
      start="${BASH_REMATCH[1]}"
      count="${BASH_REMATCH[2]}"
      if [ "$count" -lt 1 ]; then
        echo "se-ext docs lines: count must be >= 1" >&2
        exit 1
      fi
      end=$(( start + count - 1 ))
    else
      echo "se-ext docs lines: invalid range '$range' (expected N, N-M, or N+K)" >&2
      exit 1
    fi
    if [ "$start" -lt 1 ]; then
      echo "se-ext docs lines: start must be >= 1" >&2
      exit 1
    fi
    if [ "$end" -lt "$start" ]; then
      echo "se-ext docs lines: end ($end) must be >= start ($start)" >&2
      exit 1
    fi
    awk -v s="$start" -v e="$end" '
      NR > e { exit }
      NR >= s { printf "%d:%s\n", NR, $0 }
    ' "$file"
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
