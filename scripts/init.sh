#!/usr/bin/env bash

set -e

if [ -z "$SE_EXT_TEMPLATE_DIR" ]; then
  echo "Error: SE_EXT_TEMPLATE_DIR is not set. Are you in the SE dev shell?" >&2
  exit 1
fi

# Default remote flake reference for .envrc; --local overrides it.
REMOTE_REF="github:ahacop/standardebooks-nix"
LOCAL_REF="../standardebooks-nix"

# Local files that must never reach a commit. They go in .git/info/exclude,
# not .gitignore: the .gitignore is the one `se create-draft` writes, and it is
# part of the book that gets submitted to Standard Ebooks. .envrc needs no
# entry, because that .gitignore already ignores every dotfile.
EXCLUDES=(
  "CLAUDE.md"
  "Justfile"
  "notes/"
  "*.patch"
)

show_help() {
  cat <<'EOF'
Usage: se-ext init [options]

Add the local helper files to an existing Standard Ebooks repository: an
.envrc (direnv), a Justfile of common se recipes, and a CLAUDE.md for agents.
To start a new book, use `se-ext new` instead; it runs `se create-draft` and
then this command.

Run it in the root of the book's git repository. It adds CLAUDE.md, Justfile,
notes/ and *.patch to .git/info/exclude, so none of these files can be
committed, and the book's own .gitignore is not changed. It leaves existing
files alone unless you pass --force.

OPTIONS
  --remote         .envrc points at the GitHub flake (default):
                     use flake github:ahacop/standardebooks-nix
  --local          .envrc points at a sibling checkout instead:
                     use flake ../standardebooks-nix
  --force          Overwrite files that already exist
  -h, --help       Show this help

EXAMPLES
  se-ext init                  # add the files, .envrc -> GitHub flake
  se-ext init --local          # add the files, .envrc -> ../standardebooks-nix
  se-ext init --force          # write the files again over existing ones
EOF
}

envrc_ref="$REMOTE_REF"
force=0

while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      show_help; exit 0 ;;
    --remote)
      envrc_ref="$REMOTE_REF"; shift ;;
    --local)
      envrc_ref="$LOCAL_REF"; shift ;;
    --force)
      force=1; shift ;;
    *)
      echo "se-ext init: unknown option '$1'" >&2
      echo "Run 'se-ext init --help' for usage." >&2
      exit 1 ;;
  esac
done

if [ ! -f src/epub/content.opf ]; then
  echo "se-ext init: no src/epub/content.opf here. Run it in the root of a book." >&2
  echo "To start a new book, run 'se-ext new'." >&2
  exit 1
fi

if ! exclude_file=$(git rev-parse --git-path info/exclude 2>/dev/null); then
  echo "se-ext init: this directory is not a git repository." >&2
  exit 1
fi

wrote=0
skipped=0

# install_file <target> <source-template>
install_file() {
  local target="$1" source="$2"
  if [ ! -f "$source" ]; then
    echo "Error: template not found: $source" >&2
    exit 1
  fi
  if [ -e "$target" ] && [ "$force" -ne 1 ]; then
    echo "  skip   $target (exists; --force to overwrite)" >&2
    skipped=$((skipped + 1))
    return
  fi
  install -m 644 "$source" "$target"
  echo "  write  $target" >&2
  wrote=$((wrote + 1))
}

# install_content <target> <content>
install_content() {
  local target="$1" content="$2"
  if [ -e "$target" ] && [ "$force" -ne 1 ]; then
    echo "  skip   $target (exists; --force to overwrite)" >&2
    skipped=$((skipped + 1))
    return
  fi
  printf '%s\n' "$content" > "$target"
  echo "  write  $target" >&2
  wrote=$((wrote + 1))
}

install_content ".envrc"    "use flake $envrc_ref"
install_file    "Justfile"  "$SE_EXT_TEMPLATE_DIR/Justfile"
install_file    "CLAUDE.md" "$SE_EXT_TEMPLATE_DIR/CLAUDE.md"

# Append each pattern that is not already a line of the exclude file, so that
# a second run adds nothing.
mkdir -p "$(dirname "$exclude_file")"
touch "$exclude_file"
added=0
for pattern in "${EXCLUDES[@]}"; do
  if ! grep -qxF -- "$pattern" "$exclude_file"; then
    printf '%s\n' "$pattern" >> "$exclude_file"
    added=$((added + 1))
  fi
done
echo "  exclude $added new pattern(s) in $exclude_file" >&2

echo "" >&2
echo "Wrote $wrote file(s), skipped $skipped." >&2
if [ "$wrote" -gt 0 ]; then
  echo "Next: run 'direnv allow' to activate the environment." >&2
fi
