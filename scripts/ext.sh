#!/usr/bin/env bash

VERSION="0.1.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_help() {
  echo "se-ext $VERSION — Standard Ebooks extended tools"
  echo ""
  echo "Usage: se-ext <command> [args...]"
  echo ""
  echo "COMMANDS"
  echo "  check-version          Check for Standard Ebooks tools updates"
  echo "  docs                   Browse and search SE documentation"
  echo "  find-archaic-words     Find archaic spellings not yet in the word list"
  echo "  modernize-spelling     Apply archaic-to-modern spelling replacements"
  echo "  tag-nationalities      Tag nationality terms with epub:type attributes"
  echo "  search-usage           Search SE GitHub for real-world semantic tag usage"
  echo ""
  echo "Run 'se-ext <command> --help' for more info on a command."
}

# List subcommands (used by completion)
list_commands() {
  echo "check-version"
  echo "docs"
  echo "find-archaic-words"
  echo "modernize-spelling"
  echo "tag-nationalities"
  echo "search-usage"
}

case "${1:-}" in
  check-version)
    shift
    source "$SCRIPT_DIR/check-version.sh"
    ;;
  docs)
    shift
    source "$SCRIPT_DIR/docs.sh"
    ;;
  find-archaic-words)
    shift
    source "$SCRIPT_DIR/find-archaic-words.sh"
    ;;
  modernize-spelling)
    shift
    source "$SCRIPT_DIR/modernize-spelling.sh"
    ;;
  tag-nationalities)
    shift
    source "$SCRIPT_DIR/tag-nationalities.sh"
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
