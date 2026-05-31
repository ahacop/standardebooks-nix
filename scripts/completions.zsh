#compdef se-ext

_se_ext() {
  local -a commands
  commands=(
    'claude-init:Print or install a CLAUDE.md for this flake'
    'docs:Browse and search SE documentation'
    'find-archaic-words:Find archaic spellings not yet in the word list'
    'ia-ocr:Search an Internet Archive scan'\''s OCR for a phrase'
    'init:Scaffold a new ebook project (.envrc, .gitignore, Justfile, CLAUDE.md)'
    'modernize-spelling:Apply archaic-to-modern spelling replacements'
    'ngram:Show a word'\''s usage-frequency trajectory (Google Ngrams)'
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
        claude-init)
          _arguments \
            '--write[Write template to ./CLAUDE.md]' \
            '--append[Append template to ./CLAUDE.md]' \
            '--force[Overwrite existing CLAUDE.md when used with --write]' \
            '--path[Print path to the template file]'
          ;;
        docs)
          local docs_root
          docs_root=$(se-ext docs --path 2>/dev/null)
          _arguments \
            '1:subcommand:(index ls search open headings section lines web --path --claude-md --help)' \
            '*::arg:->docs_args'
          case "$state" in
            docs_args)
              case "$words[2]" in
                search)
                  _arguments \
                    '--context[Lines of context around match]:n:' \
                    '-C[Lines of context around match]:n:' \
                    '--scope[Limit to scope dir]:dir:(manual contribute cli third-party)' \
                    '--exclude[Exclude scope dir]:dir:(manual contribute cli third-party)' \
                    '--absolute[Print absolute paths]'
                  ;;
                open|headings|section|lines)
                  if [ "$CURRENT" -eq 3 ] && [ -n "$docs_root" ]; then
                    _path_files -W "$docs_root" -g '*.md'
                  fi
                  ;;
                web)
                  if [ -n "$docs_root" ]; then
                    _arguments \
                      '--url[Print the URL instead of opening a browser]' \
                      "*:doc file:_path_files -W $docs_root -g '*.md'"
                  fi
                  ;;
              esac
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
        ia-ocr)
          _arguments \
            '--id[Use this Internet Archive item instead of content.opf]:id or url:' \
            '--url[Print only the canonical page-scan URL]' \
            '--json[Emit the result as JSON]' \
            '--all-matches[Report every match in the OCR, not just the first]' \
            '--auto-retry[Narrow to a matching sub-phrase if the exact phrase is not found]' \
            '--image-url[Print only the direct page-image (JPEG) URL]' \
            '--image[Download the matching leaf'\''s JPEG and print the saved path]' \
            '1:phrase:' \
            '2:ebook-directory:_directories'
          ;;
        init)
          _arguments \
            '--remote[.envrc points at the GitHub flake (default)]' \
            '--local[.envrc points at a sibling ../standardebooks-nix checkout]' \
            '--force[Overwrite files that already exist]'
          ;;
        modernize-spelling)
          _arguments \
            '--yes[Apply all replacements without confirmation]' \
            '1:ebook-directory:_directories'
          ;;
        ngram)
          _arguments \
            '--corpus[Query only one corpus]:corpus:(en-US en-GB)' \
            '--json[Emit computed signals as JSON]' \
            '1:term:' \
            '2:other-term:'
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
