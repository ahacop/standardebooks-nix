#compdef se-ext

_se_ext() {
  local -a commands
  commands=(
    'docs:Browse and search SE documentation'
    'find-archaic-words:Find archaic spellings not yet in the word list'
    'modernize-spelling:Apply archaic-to-modern spelling replacements'
    'page-scans:Open page scan URLs from ebook metadata'
    'preview:Build the ebook and open it in the default reader'
    'search-usage:Search SE GitHub for real-world semantic tag usage'
  )

  _arguments -C \
    '1:command:->command' \
    '*::arg:->args'

  case "$state" in
    command)
      _describe 'command' commands
      ;;
    args)
      case "$words[1]" in
        docs)
          _arguments \
            '1:subcommand:(index ls search open headings section lines --path --claude-md --help)' \
            '*::search-arg:->docs_search_args'
          case "$state" in
            docs_search_args)
              if [ "$words[2]" = "search" ]; then
                _arguments \
                  '--context[Lines of context around match]:n:' \
                  '-C[Lines of context around match]:n:' \
                  '--scope[Limit to scope dir]:dir:(manual contribute cli third-party)' \
                  '--exclude[Exclude scope dir]:dir:(manual contribute cli third-party)' \
                  '--absolute[Print absolute paths]'
              fi
              ;;
          esac
          ;;
        search-usage)
          _arguments \
            '1:search-term:' \
            '2:context-term:' \
            '--limit[Max repos to show]:number:' \
            '--full[Fetch file contents for richer context]'
          ;;
        find-archaic-words)
          _arguments '1:ebook-directory:_directories'
          ;;
        modernize-spelling)
          _arguments \
            '--yes[Apply all replacements without confirmation]' \
            '1:ebook-directory:_directories'
          ;;
        page-scans)
          _arguments \
            '--search[Search term to append to URL]:term:' \
            '--list[List URLs without opening]' \
            '1:ebook-directory:_directories'
          ;;
        preview)
          _arguments \
            '--output-dir[Build output directory]:dir:_directories' \
            '--advanced[Open the advanced .epub]' \
            '1:ebook-directory:_directories'
          ;;
      esac
      ;;
  esac
}

_se_ext "$@"
