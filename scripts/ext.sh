#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# The flake revision this build came from, set by the Nix wrapper. Running the
# script straight out of a checkout has no wrapper, so fall back to the working
# tree's revision.
VERSION="${SE_EXT_VERSION:-$(git -C "$SCRIPT_DIR" rev-parse --short HEAD 2>/dev/null || echo unknown)}"

show_help() {
  echo "se-ext $VERSION — Standard Ebooks extended tools"
  echo ""
  echo "Usage: se-ext <command> [args...]"
  echo ""
  echo "COMMANDS"
  echo "  claude-init            Print or install a CLAUDE.md for this flake"
  echo "  cover                  Render the cover (art + title) to an optimized PNG"
  echo "  docs                   Browse and search SE documentation"
  echo "  find-archaic-words     Find archaic spellings not yet in the word list"
  echo "  ia-ocr                 Search an Internet Archive scan's OCR for a phrase"
  echo "  init                   Scaffold a new ebook project (.envrc, .gitignore, Justfile, CLAUDE.md)"
  echo "  modernize-spelling     Apply archaic-to-modern spelling replacements"
  echo "  ngram                  Show a word's usage-frequency trajectory (Google Ngrams)"
  echo "  page-scans             Open page scan URLs from ebook metadata"
  echo "  preview                Build the ebook and open it in the default reader"
  echo "  search-usage           Search SE GitHub for real-world semantic tag usage"
  echo ""
  echo "Run 'se-ext <command> --help' for more info on a command."
}

# Report the build revision, then what the bundled documentation was built
# from. The doc versions are the useful half: they say which manual and which
# se release `se-ext docs` will answer questions from.
show_version() {
  echo "se-ext $VERSION"

  if [ -f "${SE_DOCS:-}/.versions" ]; then
    # .versions is written by build-se-docs.sh as shell-sourceable key=value
    # pairs. Source it in a subshell to keep the names out of this one.
    # shellcheck disable=SC1091,SC2154 # names come from the sourced file
    (
      . "$SE_DOCS/.versions"
      echo "  docs built $fetched from manual $manual_tag, se $se_version"
      echo "  contribute pages $web_sha, b-t-k hints $btk_sha"
    )
  fi
}

# List subcommands (used by completion)
list_commands() {
  echo "claude-init"
  echo "cover"
  echo "docs"
  echo "find-archaic-words"
  echo "ia-ocr"
  echo "init"
  echo "modernize-spelling"
  echo "ngram"
  echo "page-scans"
  echo "preview"
  echo "search-usage"
}

case "${1:-}" in
  claude-init)
    shift
    source "$SCRIPT_DIR/claude-init.sh"
    ;;
  cover)
    shift
    source "$SCRIPT_DIR/cover.sh"
    ;;
  docs)
    shift
    source "$SCRIPT_DIR/docs.sh"
    ;;
  find-archaic-words)
    shift
    source "$SCRIPT_DIR/find-archaic-words.sh"
    ;;
  ia-ocr)
    shift
    source "$SCRIPT_DIR/ia-ocr.sh"
    ;;
  init)
    shift
    source "$SCRIPT_DIR/init.sh"
    ;;
  modernize-spelling)
    shift
    source "$SCRIPT_DIR/modernize-spelling.sh"
    ;;
  ngram)
    shift
    source "$SCRIPT_DIR/ngram.sh"
    ;;
  page-scans)
    shift
    source "$SCRIPT_DIR/page-scans.sh"
    ;;
  preview)
    shift
    source "$SCRIPT_DIR/preview.sh"
    ;;
  search-usage)
    shift
    source "$SCRIPT_DIR/search-usage.sh"
    ;;
  --version|-v)
    show_version
    ;;
  --help|-h|"")
    show_help
    ;;
  --list-commands)
    list_commands
    ;;
  *)
    echo "se-ext: unknown command '$1'" >&2
    echo "Run 'se-ext --help' for usage." >&2
    exit 1
    ;;
esac
