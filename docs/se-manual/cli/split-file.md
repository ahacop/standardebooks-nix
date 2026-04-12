# se split-file

```
usage: split-file [-h] [-f STRING] [-s INTEGER] [-t FILE] FILE

Split an XHTML file into many files at all instances of <!--se:split-->, and
include a header template for each file.

positional arguments:
  FILE                  an HTML/XHTML file

options:
  -h, --help            show this help message and exit
  -f, --filename-format STRING
                        a format string for the output files; `%n` is replaced
                        with the current chapter number; defaults to
                        `chapter-%n.xhtml`
  -s, --start-at INTEGER
                        start numbering chapters at this number, instead of at
                        1
  -t, --template-file FILE
                        a file containing an XHTML template to use for each
                        chapter; the string `LANG` is replaced by the guessed
                        language, the string `NUMBER` is replaced by the
                        chapter number, the string `NUMERAL` is replaced by
                        the chapter Roman numeral, and the string `TEXT` is
                        replaced by the chapter body
```
