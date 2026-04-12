# se shift-illustrations

```
usage: shift-illustrations [-h] (-d | -i) [-a NUMBER]
                           ILLUSTRATION-NUMBER DIRECTORY

Increment or decrement the specified illustration and all following
illustrations by 1 or a specified amount.

positional arguments:
  ILLUSTRATION-NUMBER  the illustration number to start shifting at
  DIRECTORY            a Standard Ebooks source directory

options:
  -h, --help           show this help message and exit
  -d, --decrement      decrement the target illustration number and all
                       following illustrations
  -i, --increment      increment the target illustration number and all
                       following illustrations
  -a, --amount NUMBER  the amount to increment or decrement by; defaults to 1
```
