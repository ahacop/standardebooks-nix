#!/usr/bin/env bash

set -e

if [ -z "$SE_EXT_TEMPLATE_DIR" ]; then
  echo "Error: SE_EXT_TEMPLATE_DIR is not set. Are you in the SE dev shell?" >&2
  exit 1
fi

# Default remote flake reference for .envrc; --local overrides it.
REMOTE_REF="github:ahacop/standardebooks-nix"
LOCAL_REF="../standardebooks-nix"

show_help() {
  cat <<'EOF'
Usage: se-ext init [options]

Scaffold the project-local "glue" files for a Standard Ebooks production so a
fresh book directory just works: an .envrc (direnv), an SE-style .gitignore, a
Justfile of common se recipes, and a CLAUDE.md for agents.

Run it in a new or existing book directory. It is idempotent: existing files
are left untouched unless you pass --force. It only writes the glue files — use
`se create-draft` to generate the actual ebook skeleton (src/, content.opf, …).

Note: the generated .gitignore ignores dotfiles and CLAUDE.md, so most of what
this writes is intentionally untracked — don't expect it in `git status`.

OPTIONS
  --remote         .envrc points at the GitHub flake (default):
                     use flake github:ahacop/standardebooks-nix
  --local          .envrc points at a sibling checkout instead:
                     use flake ../standardebooks-nix
  --force          Overwrite files that already exist
  -h, --help       Show this help

EXAMPLES
  se-ext init                  # scaffold with a remote-flake .envrc
  se-ext init --local          # scaffold, .envrc -> ../standardebooks-nix
  se-ext init --force          # re-scaffold, overwriting existing glue files
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

install_content ".envrc"     "use flake $envrc_ref"
install_file    ".gitignore" "$SE_EXT_TEMPLATE_DIR/gitignore"
install_file    "Justfile"   "$SE_EXT_TEMPLATE_DIR/Justfile"
install_file    "CLAUDE.md"  "$SE_EXT_TEMPLATE_DIR/CLAUDE.md"

echo "" >&2
echo "Scaffolded $wrote file(s), skipped $skipped." >&2
if [ "$wrote" -gt 0 ]; then
  echo "Next: run 'direnv allow' to activate the environment." >&2
fi
