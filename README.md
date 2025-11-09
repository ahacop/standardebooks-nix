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
- Calibre
- epubcheck
- Java runtime (for epubcheck)

## Version checking

The environment automatically checks for new releases of the Standard Ebooks tools when you load the shell.

You can also manually check with:

```bash
nix run github:ahacop/standardebooks-nix#check-version
```

## License

GPL-3.0 (see LICENSE)
