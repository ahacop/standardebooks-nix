# standardebooks-nix

A Nix flake for [Standard Ebooks](https://standardebooks.org/) tooling.

## Usage

Create a `.envrc` file in your ebook project directory:

```bash
use flake github:ahacop/standardebooks-nix
```

Then run `direnv allow` to activate the environment.

This will give you access to:
- Standard Ebooks tools (`se`)
- Extended tools (`se-ext`)
- Calibre
- epubcheck

## Extended tools

`se-ext` provides additional helpers for ebook production:

```bash
se-ext check-version        # Check for Standard Ebooks tools updates
se-ext tag-nationalities    # Interactively tag nationality terms
se-ext search-usage         # Search SE GitHub for semantic tag usage
```

Run `se-ext --help` or `se-ext <command> --help` for details.

## Version checking

The environment automatically checks for new releases of the Standard Ebooks tools when you load the shell.

You can also manually check with:

```bash
nix run github:ahacop/standardebooks-nix -- check-version
```

## License

GPL-3.0 (see LICENSE)
