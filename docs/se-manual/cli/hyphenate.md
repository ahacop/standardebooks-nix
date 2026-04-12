# se hyphenate

```
usage: hyphenate [-h] [-i] [-l LANGUAGE] [-v] TARGET [TARGET ...]

Insert soft hyphens at syllable breaks in XHTML files.

positional arguments:
  TARGET                an XHTML file, or a directory containing XHTML files

options:
  -h, --help            show this help message and exit
  -i, --ignore-h-tags   don’t add soft hyphens to text in <h1-6> tags
  -l, --language LANGUAGE
                        specify the language for the XHTML files; if
                        unspecified, defaults to the `xml:lang` or `lang`
                        attribute of the root <html> element
  -v, --verbose         increase output verbosity
```
