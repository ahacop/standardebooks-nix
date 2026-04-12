# se css-select

```
usage: css-select [-h] [-f] [-q] SELECTOR TARGET [TARGET ...]

Print the results of a CSS selector evaluated against a set of XHTML files.

positional arguments:
  SELECTOR              a CSS selector
  TARGET                an XHTML file, or a directory containing XHTML files

options:
  -h, --help            show this help message and exit
  -f, --only-filenames  only output filenames of files that contain matches,
                        not the matches themselves
  -q, --quiet           don’t output anything, only a return code if matches
                        exist in any files
```
