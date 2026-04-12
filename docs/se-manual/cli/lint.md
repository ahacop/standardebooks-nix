# se lint

```
usage: lint [-h] [-a ALLOWED_MESSAGES [ALLOWED_MESSAGES ...]] [-s] [-v]
            DIRECTORY [DIRECTORY ...]

Check for various Standard Ebooks style errors.

positional arguments:
  DIRECTORY             a Standard Ebooks source directory

options:
  -h, --help            show this help message and exit
  -a, --allow ALLOWED_MESSAGES [ALLOWED_MESSAGES ...]
                        if an se-lint-ignore.xml file is present, allow these
                        specific codes to be raised by lint
  -s, --skip-lint-ignore
                        ignore all rules in the se-lint-ignore.xml file
  -v, --verbose         increase output verbosity
```
