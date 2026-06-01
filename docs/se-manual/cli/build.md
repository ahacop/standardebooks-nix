# se build

```
USAGE

	build [-h,--help] [-b,--kobo] [-c,--check] [-k,--kindle]
	[-o,--output-dir <DIRECTORY>] [-p,--proof] [-v,--verbose]
	[-y,--check-only] <DIRECTORY> [<DIRECTORY> ...]

DESCRIPTION

	Build compatible .epub and advanced .epub ebooks from a Standard Ebook
	source directory. Output is placed in the current directory, or the
	target directory with --output-dir.

POSITIONAL ARGUMENTS

	<DIRECTORY> [<DIRECTORY> ...]

		A Standard Ebooks source directory.

OPTIONS

	-h,--help

		Show this help message and exit.


	-b,--kobo

		Also build a .kepub.epub file for Kobo.


	-c,--check

		Use epubcheck to validate the compatible .epub file, and the
		Nu Validator (v.Nu) to validate XHTML5; if Ace is installed,
		also validate using Ace; if --kindle is also specified and
		epubcheck, v.Nu, or Ace fail, don’t create a Kindle file.


	-k,--kindle

		Also build an .azw3 file for Kindle.


	-o,--output-dir <DIRECTORY>

		A directory to place output files in; will be created if it
		doesn’t exist.


	-p,--proof

		Insert additional CSS rules that are helpful for proofreading;
		output filenames will end in .proof.


	-v,--verbose

		Increase output verbosity.


	-y,--check-only

		Run tests used by --check, but don’t output any ebook files,
		and exit after checking.
```
