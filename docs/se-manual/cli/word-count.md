# se word-count

```
USAGE

	word-count [-h,--help] [-c,--categorize] [-p,--ignore-pg-boilerplate]
	[-x,--exclude-se-files] <TARGET> [<TARGET> ...]

DESCRIPTION

	Count the number of words in an XHTML file and optionally categorize
	by length. If multiple files are specified, show the total word count
	for all.

POSITIONAL ARGUMENTS

	<TARGET> [<TARGET> ...]

		An XHTML file, or a directory containing XHTML files.

OPTIONS

	-h,--help

		Show this help message and exit.


	-c,--categorize

		Include length categorization in output.


	-p,--ignore-pg-boilerplate

		Attempt to ignore Project Gutenberg boilerplate headers and
		footers before counting.


	-x,--exclude-se-files

		Exclude some non-bodymatter files common to S.E. ebooks, like
		the ToC and colophon.
```
