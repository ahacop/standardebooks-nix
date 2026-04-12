# se build

```
usage: build [-h] [-b] [-c] [-k] [-o DIRECTORY] [-p] [-v] [-y]
             DIRECTORY [DIRECTORY ...]

Build compatible .epub and advanced .epub ebooks from a Standard Ebook source
directory. Output is placed in the current directory, or the target directory
with --output-dir.

positional arguments:
  DIRECTORY             a Standard Ebooks source directory

options:
  -h, --help            show this help message and exit
  -b, --kobo            also build a .kepub.epub file for Kobo
  -c, --check           use epubcheck to validate the compatible .epub file,
                        and the Nu Validator (v.Nu) to validate XHTML5; if Ace
                        is installed, also validate using Ace; if --kindle is
                        also specified and epubcheck, v.Nu, or Ace fail, don’t
                        create a Kindle file
  -k, --kindle          also build an .azw3 file for Kindle
  -o, --output-dir DIRECTORY
                        a directory to place output files in; will be created
                        if it doesn’t exist
  -p, --proof           insert additional CSS rules that are helpful for
                        proofreading; output filenames will end in .proof
  -v, --verbose         increase output verbosity
  -y, --check-only      run tests used by --check but don’t output any ebook
                        files and exit after checking
```
