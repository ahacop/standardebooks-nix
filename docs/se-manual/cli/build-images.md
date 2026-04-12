# se build-images

```
usage: build-images [-h] [-v] [-g] DIRECTORY [DIRECTORY ...]

Generate ebook cover and titlepages for Standard Ebooks ebooks, and then build
ebook covers and titlepages, placing the output in
`DIRECTORY/src/epub/images/`.

positional arguments:
  DIRECTORY          a Standard Ebooks source directory

options:
  -h, --help         show this help message and exit
  -v, --verbose      increase output verbosity
  -g, --no-generate  don’t generate new source cover/titlepage SVGs, only
                     build existing ones
```
