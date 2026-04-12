# se recompose-epub

```
usage: recompose-epub [-h] [-o FILE] [-x] [-e FILE] [-i] DIRECTORY

Recompose a Standard Ebooks source directory into a single (X?)HTML5 file, and
print to standard output.

positional arguments:
  DIRECTORY             a Standard Ebooks source directory

options:
  -h, --help            show this help message and exit
  -o, --output FILE     a file to write output to instead of printing to
                        standard output
  -x, --xhtml           output XHTML instead of HTML5
  -e, --extra-css-file FILE
                        the path to an additional CSS file to include after
                        any CSS files in the epub
  -i, --image-files     leave image src attributes as relative URLs instead of
                        inlining as data: URIs
```
