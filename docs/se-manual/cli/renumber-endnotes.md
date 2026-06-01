# se renumber-endnotes

```
USAGE

	renumber-endnotes [-h,--help] [-b,--brute-force] [-v,--verbose]
	<DIRECTORY> [<DIRECTORY> ...]

DESCRIPTION

	Renumber all endnotes and noterefs sequentially from the beginning,
	taking care to match noterefs and endnotes if possible.

POSITIONAL ARGUMENTS

	<DIRECTORY> [<DIRECTORY> ...]

		A Standard Ebooks source directory.

OPTIONS

	-h,--help

		Show this help message and exit.


	-b,--brute-force

		Renumber without checking that noterefs and endnotes match;
		may result in endnotes with empty backlinks or noterefs
		without matching endnotes.


	-v,--verbose

		Increase output verbosity.
```
