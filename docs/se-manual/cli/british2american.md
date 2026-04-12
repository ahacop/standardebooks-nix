# se british2american

```
usage: british2american [-h] [-f] [-v] TARGET [TARGET ...]

Try to convert British quote style to American quote style. Quotes must
already be typogrified using the `typogrify` tool. This script isn’t perfect;
proofreading is required, especially near closing quotes near to em-dashes.

positional arguments:
  TARGET         an XHTML file, or a directory containing XHTML files

options:
  -h, --help     show this help message and exit
  -f, --force    force conversion of quote style
  -v, --verbose  increase output verbosity
```
