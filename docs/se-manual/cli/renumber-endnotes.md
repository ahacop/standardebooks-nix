# se renumber-endnotes

```
usage: renumber-endnotes [-h] [-b] [-v] DIRECTORY [DIRECTORY ...]

Renumber all endnotes and noterefs sequentially from the beginning, taking
care to match noterefs and endnotes if possible.

positional arguments:
  DIRECTORY          a Standard Ebooks source directory

options:
  -h, --help         show this help message and exit
  -b, --brute-force  renumber without checking that noterefs and endnotes
                     match; may result in endnotes with empty backlinks or
                     noterefs without matching endnotes
  -v, --verbose      increase output verbosity
```
