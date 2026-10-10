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

## Starting a new ebook project

`se-ext new` creates a book in one command. You do not need a dev shell first:

```bash
nix run github:ahacop/standardebooks-nix -- new --author "…" --title "…" --pg-id 1234
cd <new-book-dir>
direnv allow
```

It runs `se create-draft` with the options you give it, changes into the new
book directory, and runs `se-ext init` there. Run `se create-draft --help` to
see the options. `--local`, `--remote` and `--force` go to `se-ext init`.

`se-ext init` adds these files to a book that already exists:

- `.envrc` — `use flake github:ahacop/standardebooks-nix` (pass `--local` to
  point at a sibling `../standardebooks-nix` checkout instead)
- `Justfile` — common `se` recipes (`just normalize`, `just rebuild-meta`, …)
- `CLAUDE.md` — agent guidance (same template as `se-ext claude-init`)

It also adds `CLAUDE.md`, `Justfile`, `notes/` and `*.patch` to
`.git/info/exclude`, so they cannot be committed. It does not change the
`.gitignore` that `se create-draft` writes, because that file is part of the
book you submit. The `.gitignore` already ignores `.envrc`, like every other
dotfile. Existing files are left alone unless you pass `--force`.

## Extended tools

`se-ext` provides additional helpers for ebook production:

```bash
se-ext new                  # Create a new book with se create-draft, then run init
se-ext init                 # Add .envrc, Justfile and CLAUDE.md to an existing book
se-ext claude-init          # Print or install a CLAUDE.md for this flake
se-ext docs                 # Browse and search SE documentation
se-ext find-archaic-words   # Find archaic spellings not yet in the word list
se-ext ia-ocr               # Search an Internet Archive scan's OCR for a phrase
se-ext modernize-spelling   # Apply archaic-to-modern spelling replacements
se-ext ngram                # Show a word's usage-frequency trajectory (Google Ngrams)
se-ext page-scans           # Open page scan URLs from ebook metadata
se-ext preview              # Build the ebook and open it in the default reader
se-ext cover                # Render the cover (art + title) to an optimized PNG
se-ext search-usage         # Search SE GitHub for real-world tag/pattern usage
```

Run `se-ext --help` or `se-ext <command> --help` for details.

## Claude Code / agent setup

If you use Claude Code or a similar agent in your ebook project, drop a
ready-made `CLAUDE.md` into the project root:

```bash
se-ext claude-init --write
```

The template documents the `se` and `se-ext` workflow, SE commit-message
style, the in-repo `se-ext docs` reference, and the precedent-search
conventions used across the SE corpus. Use `--append` to add it to an
existing `CLAUDE.md`, or run `se-ext claude-init` with no args to print it
to stdout.

## Updating the Standard Ebooks toolchain

`se` is built from `nix/uv/pyproject.toml` + `nix/uv/uv.lock`. To bump to a newer release:

```bash
# edit nix/uv/pyproject.toml to change standardebooks==X.Y.Z, then:
cd nix/uv && nix-shell -p uv --run "uv lock --python 3.13" && cd -
git add nix/uv/pyproject.toml nix/uv/uv.lock
nix flake check
```

## License

The code in this repository is licensed under the GNU General Public License
v3.0 (GPL-3.0). See [LICENSE](LICENSE) for the full text.

The bundled Standard Ebooks documentation under `docs/se-manual/` is sourced
from Standard Ebooks and released under the
[Creative Commons CC0 1.0 Universal Public Domain Dedication](https://creativecommons.org/publicdomain/zero/1.0/),
matching the upstream licensing of those works.
