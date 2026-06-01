# se interactive-replace

```
USAGE

	interactive-replace [-h,--help] [-d,--dot-all] [-i,--ignore-case]
	[-m,--multiline] [-v,--vim] <REGEX> <REPLACE> <TARGET> [<TARGET> ...]

DESCRIPTION

	Perform an interactive search and replace on a list of files using
	Python-flavored regex. The view is scrolled using the arrow keys, with
	alt to scroll by page in any direction. Basic Emacs (default) or Vim
	style navigation is available. The following actions are possible: (y)
	Accept replacement. (n) Reject replacement. (a) Accept all remaining
	replacements in this file. (r) Reject all remaining replacements in
	this file. (c) Center on match. (q) Save this file and quit.

POSITIONAL ARGUMENTS

	<REGEX>

		A regex of the type accepted by Python’s regex library.


	<REPLACE>

		A replacement regex of the type accepted by Python’s regex
		library.


	<TARGET> [<TARGET> ...]

		A file or directory on which to perform the search and
		replace.

OPTIONS

	-h,--help

		Show this help message and exit.


	-d,--dot-all

		Make . match newlines; equivalent to regex.DOTALL.


	-i,--ignore-case

		Ignore case when matching; equivalent to regex.IGNORECASE.


	-m,--multiline

		Make ^ and $ consider each line; equivalent to
		regex.MULTILINE.


	-v,--vim

		Use basic Vim-like navigation shortcuts.
```
