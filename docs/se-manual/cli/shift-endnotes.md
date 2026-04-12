# se shift-endnotes

```
usage: shift-endnotes [-h] (-d | -i) [-a NUMBER] ENDNOTE-NUMBER DIRECTORY

Increment or decrement the specified endnote and all following endnotes by 1
or a specified amount.

positional arguments:
  ENDNOTE-NUMBER       the endnote number to start shifting at
  DIRECTORY            a Standard Ebooks source directory

options:
  -h, --help           show this help message and exit
  -d, --decrement      decrement the target endnote number and all following
                       endnotes
  -i, --increment      increment the target endnote number and all following
                       endnotes
  -a, --amount NUMBER  the amount to increment or decrement by; defaults to 1
```
