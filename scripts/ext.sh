#!/usr/bin/env bash

VERSION="0.1.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
    echo "se-ext $VERSION"
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
