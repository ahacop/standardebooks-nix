_se_ext() {
  local cur prev commands
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  commands="check-version tag-nationalities search-usage"

  if [ "$COMP_CWORD" -eq 1 ]; then
    COMPREPLY=($(compgen -W "$commands --help --version" -- "$cur"))
    return
  fi

  case "$prev" in
    search-usage)
      if [ "$COMP_CWORD" -eq 3 ]; then
        COMPREPLY=($(compgen -W "--limit --full" -- "$cur"))
      fi
      ;;
  esac
}

complete -F _se_ext se-ext
