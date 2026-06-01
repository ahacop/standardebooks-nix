# se lint

```
USAGE

	lint [-h,--help]
	[-a,--allow <ALLOWED_MESSAGES> [<ALLOWED_MESSAGES> ...]]
	[-s,--skip-lint-ignore] [-v,--verbose] <DIRECTORY> [<DIRECTORY> ...]

DESCRIPTION

	Check for various Standard Ebooks style errors.

POSITIONAL ARGUMENTS

	<DIRECTORY> [<DIRECTORY> ...]

		A Standard Ebooks source directory.

OPTIONS

	-h,--help

		Show this help message and exit.


	-a,--allow <ALLOWED_MESSAGES> [<ALLOWED_MESSAGES> ...]

		If an se-lint-ignore.xml file is present, allow these specific
		codes to be raised by lint.


	-s,--skip-lint-ignore

		Ignore all rules in the se-lint-ignore.xml file.


	-v,--verbose

		Increase output verbosity.
```
