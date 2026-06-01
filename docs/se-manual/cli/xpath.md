# se xpath

```
USAGE

	xpath [-h,--help] [-f,--only-filenames] [-q,--quiet] <XPATH>
	<TARGET> [<TARGET> ...]

DESCRIPTION

	Print the results of an xpath expression evaluated against a set of
	XHTML files. The default namespace is removed.

POSITIONAL ARGUMENTS

	<XPATH>

		An xpath expression.


	<TARGET> [<TARGET> ...]

		An XHTML file, or a directory containing XHTML files.

OPTIONS

	-h,--help

		Show this help message and exit.


	-f,--only-filenames

		Only output filenames of files that contain matches, not the
		matches themselves.


	-q,--quiet

		Don’t output anything, only a return code if matches exist in
		any files.
```
