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
se-ext tag-nationalities    # Interactively tag nationality terms
se-ext search-usage         # Search SE GitHub for semantic tag usage
```

Run `se-ext --help` or `se-ext <command> --help` for details.

## Updating the Standard Ebooks toolchain

`se` is built from `nix/uv/pyproject.toml` + `nix/uv/uv.lock`. To bump to a newer release:

```bash
# edit nix/uv/pyproject.toml to change standardebooks==X.Y.Z, then:
cd nix/uv && nix-shell -p uv --run "uv lock --python 3.13" && cd -
git add nix/uv/pyproject.toml nix/uv/uv.lock
nix flake check
```

## License

GPL-3.0 (see LICENSE)
