# se hyphenate

```
USAGE

	hyphenate [-h,--help] [-i,--ignore-h-tags] [-l,--language <LANGUAGE>]
	[-v,--verbose] <TARGET> [<TARGET> ...]

DESCRIPTION

	Insert soft hyphens at syllable breaks in XHTML files.

POSITIONAL ARGUMENTS

	<TARGET> [<TARGET> ...]

		An XHTML file, or a directory containing XHTML files.

OPTIONS

	-h,--help

		Show this help message and exit.


	-i,--ignore-h-tags

		Don’t add soft hyphens to text in <h1-6> tags.


	-l,--language <LANGUAGE>

		Specify the language for the XHTML files; if unspecified,
		defaults to the xml:lang or lang attribute of the root <html>
		element.


	-v,--verbose

		Increase output verbosity.
```
