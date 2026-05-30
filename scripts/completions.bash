_se_ext() {
  local cur prev commands
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  commands="claude-init docs find-archaic-words ia-ocr init modernize-spelling ngram page-scans preview search-usage"

  if [ "$COMP_CWORD" -eq 1 ]; then
    COMPREPLY=($(compgen -W "$commands --help --version" -- "$cur"))
    return
  fi

  case "${COMP_WORDS[1]}" in
    claude-init)
      COMPREPLY=($(compgen -W "--write --append --force --path --help" -- "$cur"))
      ;;
    docs)
      if [ "$COMP_CWORD" -eq 2 ]; then
        COMPREPLY=($(compgen -W "index ls search open headings section lines web --path --claude-md --help" -- "$cur"))
      else
        case "${COMP_WORDS[2]}" in
          search)
            case "$prev" in
              --scope|--exclude)
                COMPREPLY=($(compgen -W "manual contribute cli third-party" -- "$cur")) ;;
              -C|--context)
                COMPREPLY=() ;;
              *)
                COMPREPLY=($(compgen -W "--context --scope --exclude --absolute" -- "$cur")) ;;
            esac
            ;;
          open|headings|section|lines)
            if [ "$COMP_CWORD" -eq 3 ]; then
              COMPREPLY=($(compgen -W "$(se-ext docs ls 2>/dev/null)" -- "$cur"))
            fi
            ;;
          web)
            COMPREPLY=($(compgen -W "--url $(se-ext docs ls 2>/dev/null)" -- "$cur"))
            ;;
        esac
      fi
      ;;
    find-archaic-words)
      if [ "$COMP_CWORD" -eq 2 ]; then
        COMPREPLY=($(compgen -W "--help" -- "$cur"))
      fi
      ;;
    ia-ocr)
      COMPREPLY=($(compgen -W "--url --json --all-matches --auto-retry --image --image-url --help" -- "$cur"))
      ;;
    init)
      COMPREPLY=($(compgen -W "--remote --local --force --help" -- "$cur"))
      ;;
    modernize-spelling)
      if [ "$COMP_CWORD" -eq 2 ]; then
        COMPREPLY=($(compgen -W "--yes --help" -- "$cur"))
      fi
      ;;
    ngram)
      case "$prev" in
        --corpus)
          COMPREPLY=($(compgen -W "en-US en-GB" -- "$cur")) ;;
        *)
          COMPREPLY=($(compgen -W "--corpus --json --help" -- "$cur")) ;;
      esac
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
