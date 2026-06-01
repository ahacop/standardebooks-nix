# se recompose-epub

```
USAGE

	recompose-epub [-h,--help] [-e,--extra-css-file <FILE>]
	[-i,--image-files] [-o,--output <FILE>] [-x,--xhtml] <DIRECTORY>

DESCRIPTION

	Recompose a Standard Ebooks source directory into a single (X?)HTML5
	file, and print to standard output.

POSITIONAL ARGUMENTS

	<DIRECTORY>

		A Standard Ebooks source directory.

OPTIONS

	-h,--help

		Show this help message and exit.


	-e,--extra-css-file <FILE>

		The path to an additional CSS file to include after any CSS
		files in the epub.


	-i,--image-files

		Leave image src attributes as relative URLs instead of
		inlining as data: URIs.


	-o,--output <FILE>

		A file to write output to instead of printing to standard
		output.


	-x,--xhtml

		Output XHTML instead of HTML5.
```
