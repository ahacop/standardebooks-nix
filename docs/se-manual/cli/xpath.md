# se xpath

```
usage: xpath [-h] [-f] [-q] XPATH TARGET [TARGET ...]

Print the results of an xpath expression evaluated against a set of XHTML
files. The default namespace is removed.

positional arguments:
  XPATH                 an xpath expression
  TARGET                an XHTML file, or a directory containing XHTML files

options:
  -h, --help            show this help message and exit
  -f, --only-filenames  only output filenames of files that contain matches,
                        not the matches themselves
  -q, --quiet           don’t output anything, only a return code if matches
                        exist in any files
```
