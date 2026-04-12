# se interactive-replace

```
usage: interactive-replace [-h] [-i] [-m] [-d] [-v]
                           REGEX REPLACE TARGET [TARGET ...]

Perform an interactive search and replace on a list of files using Python-
flavored regex. The view is scrolled using the arrow keys, with alt to scroll
by page in any direction. Basic Emacs (default) or Vim style navigation is
available. The following actions are possible: (y) Accept replacement. (n)
Reject replacement. (a) Accept all remaining replacements in this file. (r)
Reject all remaining replacements in this file. (c) Center on match. (q) Save
this file and quit.

positional arguments:
  REGEX              a regex of the type accepted by Python’s `regex` library.
  REPLACE            a replacement regex of the type accepted by Python’s
                     `regex` library.
  TARGET             a file or directory on which to perform the search and
                     replace

options:
  -h, --help         show this help message and exit
  -i, --ignore-case  ignore case when matching; equivalent to regex.IGNORECASE
  -m, --multiline    make `^` and `$` consider each line; equivalent to
                     regex.MULTILINE
  -d, --dot-all      make `.` match newlines; equivalent to regex.DOTALL
  -v, --vim          use basic Vim-like navigation shortcuts
```
