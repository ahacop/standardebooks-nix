# se compare-versions

```
USAGE

	compare-versions [-h,--help] [-i,--include-se-files] [-n,--no-images]
	[-v,--verbose] <TARGET> [<TARGET> ...]

DESCRIPTION

	Use Firefox to render and compare XHTML files in an ebook repository.
	Run on a dirty repository to visually compare the repository’s dirty
	state with its clean state. If a file renders differently, place
	screenshots of the new, original, and diff (if available) renderings
	in the current working directory. A file called diff.html is created
	to allow for side-by-side comparisons of original and new files.

POSITIONAL ARGUMENTS

	<TARGET> [<TARGET> ...]

		A directory containing XHTML files.

OPTIONS

	-h,--help

		Show this help message and exit.


	-i,--include-se-files

		Include commonly-excluded S.E. files like imprint, titlepage,
		and colophon.


	-n,--no-images

		Don’t create images of diffs.


	-v,--verbose

		Increase output verbosity.
```
