# se create-draft

```
usage: create-draft [-h] [-r TRANSLATOR [TRANSLATOR ...]] [-p PG_ID]
                    [-e EMAIL] [-o] -a AUTHOR [AUTHOR ...] -t TITLE [-w] [-v]
                    [-f FP_ID]

Create a skeleton of a new Standard Ebook in the current directory.

options:
  -h, --help            show this help message and exit
  -r, --translator TRANSLATOR [TRANSLATOR ...]
                        a translator of the ebook
  -p, --pg-id PG_ID     the Project Gutenberg ID number of the ebook to
                        download
  -e, --email EMAIL     use this email address as the main committer for the
                        local Git repository
  -o, --offline         create draft without network access
  -a, --author AUTHOR [AUTHOR ...]
                        an author of the ebook
  -t, --title TITLE     the title of the ebook
  -w, --white-label     create a generic epub skeleton without S.E. branding
  -v, --verbose         increase output verbosity
  -f, --fp-id FP_ID     the Faded Page ID number of the ebook to download
```
