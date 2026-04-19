_se_ext() {
  local cur prev commands
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  commands="check-version docs find-archaic-words modernize-spelling page-scans preview tag-nationalities search-usage"

  if [ "$COMP_CWORD" -eq 1 ]; then
    COMPREPLY=($(compgen -W "$commands --help --version" -- "$cur"))
    return
  fi

  case "${COMP_WORDS[1]}" in
    docs)
      if [ "$COMP_CWORD" -eq 2 ]; then
        COMPREPLY=($(compgen -W "search open --path --claude-md --help" -- "$cur"))
      fi
      ;;
    find-archaic-words)
      if [ "$COMP_CWORD" -eq 2 ]; then
        COMPREPLY=($(compgen -W "--help" -- "$cur"))
      fi
      ;;
    modernize-spelling)
      if [ "$COMP_CWORD" -eq 2 ]; then
        COMPREPLY=($(compgen -W "--yes --help" -- "$cur"))
      fi
      ;;
    page-scans)
      COMPREPLY=($(compgen -W "--search --list --help" -- "$cur"))
      ;;
    preview)
      COMPREPLY=($(compgen -W "--output-dir --advanced --help" -- "$cur"))
      ;;
    search-usage)
      if [ "$COMP_CWORD" -eq 3 ]; then
        COMPREPLY=($(compgen -W "--limit --full" -- "$cur"))
      fi
      ;;
  esac
}

complete -F _se_ext se-ext
