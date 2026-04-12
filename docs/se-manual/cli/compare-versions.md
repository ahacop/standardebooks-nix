# se compare-versions

```
usage: compare-versions [-h] [-i] [-n] [-v] TARGET [TARGET ...]

Use Firefox to render and compare XHTML files in an ebook repository. Run on a
dirty repository to visually compare the repository’s dirty state with its
clean state. If a file renders differently, place screenshots of the new,
original, and diff (if available) renderings in the current working directory.
A file called diff.html is created to allow for side-by-side comparisons of
original and new files.

positional arguments:
  TARGET                a directory containing XHTML files

options:
  -h, --help            show this help message and exit
  -i, --include-se-files
                        include commonly-excluded S.E. files like imprint,
                        titlepage, and colophon
  -n, --no-images       don’t create images of diffs
  -v, --verbose         increase output verbosity
```
