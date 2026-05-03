_se_ext() {
  local cur prev commands
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  commands="docs find-archaic-words modernize-spelling page-scans preview search-usage"

  if [ "$COMP_CWORD" -eq 1 ]; then
    COMPREPLY=($(compgen -W "$commands --help --version" -- "$cur"))
    return
  fi

  case "${COMP_WORDS[1]}" in
    docs)
      if [ "$COMP_CWORD" -eq 2 ]; then
        COMPREPLY=($(compgen -W "index ls search open headings section lines --path --claude-md --help" -- "$cur"))
      elif [ "${COMP_WORDS[2]}" = "search" ]; then
        case "$prev" in
          --scope|--exclude)
            COMPREPLY=($(compgen -W "manual contribute cli third-party" -- "$cur")) ;;
          -C|--context)
            COMPREPLY=() ;;
          *)
            COMPREPLY=($(compgen -W "--context --scope --exclude --absolute" -- "$cur")) ;;
        esac
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
