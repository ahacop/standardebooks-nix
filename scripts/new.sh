#!/usr/bin/env bash

set -e

show_help() {
  cat <<'EOF'
Usage: se-ext new [--local] [--remote] [--force] <se create-draft options>

Start a new Standard Ebooks production in one step. It runs `se create-draft`
in the current directory, changes into the book directory that it makes, and
then runs `se-ext init` there to add .envrc, Justfile and CLAUDE.md.

The options --local, --remote and --force go to `se-ext init`. All other
options go to `se create-draft`; run `se create-draft --help` to see them.

Outside the dev shell, run it straight from the flake:
  nix run github:ahacop/standardebooks-nix -- new --author "…" --title "…"

EXAMPLES
  se-ext new --author "Jules Verne" --title "Robur the Conqueror" --pg-id 3808
  se-ext new --offline --author "W. Somerset Maugham" --title "The Magician"
  se-ext new --local --author "…" --title "…"
EOF
}

init_args=()
draft_args=()

while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      show_help; exit 0 ;;
    --local|--remote|--force)
      init_args+=("$1"); shift ;;
    *)
      draft_args+=("$1"); shift ;;
  esac
done

if [ ${#draft_args[@]} -eq 0 ]; then
  show_help >&2
  exit 1
fi

# `se create-draft` does not print the directory it makes, so compare the
# directory listing before and after to find it.
before=$(find . -mindepth 1 -maxdepth 1 -type d | sort)
se create-draft "${draft_args[@]}"
after=$(find . -mindepth 1 -maxdepth 1 -type d | sort)
book_dir=$(comm -13 <(printf '%s\n' "$before") <(printf '%s\n' "$after"))

if [ -z "$book_dir" ] || [ "$(printf '%s\n' "$book_dir" | wc -l)" -ne 1 ]; then
  echo "se-ext new: cannot find the directory that se create-draft made." >&2
  echo "Change into it and run 'se-ext init'." >&2
  exit 1
fi

book_dir=${book_dir#./}
echo "" >&2
echo "Created $book_dir" >&2
cd "$book_dir"

set -- "${init_args[@]}"
source "$SCRIPT_DIR/init.sh"
echo "Run: cd $book_dir && direnv allow" >&2
