# se word-count

```
usage: word-count [-h] [-c] [-p] [-x] TARGET [TARGET ...]

Count the number of words in an XHTML file and optionally categorize by
length. If multiple files are specified, show the total word count for all.

positional arguments:
  TARGET                an XHTML file, or a directory containing XHTML files

options:
  -h, --help            show this help message and exit
  -c, --categorize      include length categorization in output
  -p, --ignore-pg-boilerplate
                        attempt to ignore Project Gutenberg boilerplate
                        headers and footers before counting
  -x, --exclude-se-files
                        exclude some non-bodymatter files common to S.E.
                        ebooks, like the ToC and colophon
```
