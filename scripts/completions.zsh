#compdef se-ext

_se_ext() {
  local -a commands
  commands=(
    'check-version:Check for Standard Ebooks tools updates'
    'docs:Browse and search SE documentation'
    'tag-nationalities:Tag nationality terms with epub\:type attributes'
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
            '1:subcommand:(search open --path --claude-md --help)'
          ;;
        search-usage)
          _arguments \
            '1:search-term:' \
            '2:context-term:' \
            '--limit[Max repos to show]:number:' \
            '--full[Fetch file contents for richer context]'
          ;;
        tag-nationalities)
          _arguments '1:ebook-directory:_directories'
          ;;
      esac
      ;;
  esac
}

_se_ext "$@"
