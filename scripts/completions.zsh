#compdef se-ext

_se_ext() {
  local -a commands
  commands=(
    'check-version:Check for Standard Ebooks tools updates'
    'docs:Browse and search SE documentation'
    'find-archaic-words:Find archaic spellings not yet in the word list'
    'modernize-spelling:Apply archaic-to-modern spelling replacements'
    'page-scans:Open page scan URLs from ebook metadata'
    'preview:Build the ebook and open it in the default reader'
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
        tag-nationalities)
          _arguments '1:ebook-directory:_directories'
          ;;
      esac
      ;;
  esac
}

_se_ext "$@"
