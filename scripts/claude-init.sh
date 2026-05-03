#!/usr/bin/env bash

set -e

if [ -z "$SE_EXT_TEMPLATE_DIR" ]; then
  echo "Error: SE_EXT_TEMPLATE_DIR is not set. Are you in the SE dev shell?" >&2
  exit 1
fi

TEMPLATE="$SE_EXT_TEMPLATE_DIR/CLAUDE.md"

if [ ! -f "$TEMPLATE" ]; then
  echo "Error: template not found: $TEMPLATE" >&2
  exit 1
fi

show_help() {
  cat <<'EOF'
Usage: se-ext claude-init [options]

Print or install the standardebooks-nix CLAUDE.md template — guidance for
Claude Code (and similar agents) when working in a Standard Ebooks production
that uses this flake.

By default, the template is printed to stdout. Use --write to install it as
./CLAUDE.md, or --append to add it to an existing file.

OPTIONS
  --write          Write the template to ./CLAUDE.md (refuses to overwrite)
  --append         Append the template to ./CLAUDE.md (file must exist)
  --force          With --write, overwrite an existing CLAUDE.md
  --path           Print the path to the template file and exit
  -h, --help       Show this help

EXAMPLES
  se-ext claude-init                       # print to stdout
  se-ext claude-init --write               # install as ./CLAUDE.md
  se-ext claude-init --append              # tack onto existing CLAUDE.md
  se-ext claude-init > CLAUDE.md           # equivalent to --write (no overwrite check)
EOF
}

mode=print
force=0

while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      show_help; exit 0 ;;
    --path)
      echo "$TEMPLATE"; exit 0 ;;
    --write)
      mode=write; shift ;;
    --append)
      mode=append; shift ;;
    --force)
      force=1; shift ;;
    *)
      echo "se-ext claude-init: unknown option '$1'" >&2
      echo "Run 'se-ext claude-init --help' for usage." >&2
      exit 1 ;;
  esac
done

target="./CLAUDE.md"

case "$mode" in
  print)
    cat "$TEMPLATE"
    ;;
  write)
    if [ -e "$target" ] && [ "$force" -ne 1 ]; then
      echo "Error: $target already exists. Use --force to overwrite, or --append to add." >&2
      exit 1
    fi
    install -m 644 "$TEMPLATE" "$target"
    echo "Wrote $target" >&2
    ;;
  append)
    if [ ! -e "$target" ]; then
      echo "Error: $target does not exist. Use --write to create it." >&2
      exit 1
    fi
    {
      printf '\n'
      cat "$TEMPLATE"
    } >> "$target"
    echo "Appended template to $target" >&2
    ;;
esac
