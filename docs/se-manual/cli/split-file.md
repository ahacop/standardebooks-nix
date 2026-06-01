# se split-file

```
USAGE

	split-file [-h,--help] [-f,--filename-format <STRING>]
	[-s,--start-at <INTEGER>] [-t,--template-file <FILE>] <FILE>

DESCRIPTION

	Split an XHTML file into many files at all instances of
	<!--se:split-->, and include a header template for each file.

POSITIONAL ARGUMENTS

	<FILE>

		An HTML/XHTML file.

OPTIONS

	-h,--help

		Show this help message and exit.


	-f,--filename-format <STRING>

		A format string for the output files; %%n is replaced with the
		current chapter number; defaults to chapter-%%n.xhtml.


	-s,--start-at <INTEGER>

		Start numbering chapters at this number, instead of at 1.


	-t,--template-file <FILE>

		A file containing an XHTML template to use for each chapter;
		the string LANG is replaced by the guessed language, the
		string NUMBER is replaced by the chapter number, the string
		NUMERAL is replaced by the chapter Roman numeral, and the
		string TEXT is replaced by the chapter body.
```
