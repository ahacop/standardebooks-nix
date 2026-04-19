# Project Instructions

## Standard Ebooks Documentation

The SE Manual of Style, contributor guides, and CLI reference are available
locally via the `se-ext docs` command. When answering questions about SE rules,
style, semantics, typography, metadata, or ebook production, use these local
docs instead of fetching from the internet.

- Index:             `se-ext docs` (or `se-ext docs index`)
- Search:            `se-ext docs search "<term>"`
- Outline a file:    `se-ext docs headings <file>`
- Extract a section: `se-ext docs section <file> "<heading>"`
- Read a whole file: `se-ext docs open <file>`

Paths emitted by `search` are absolute and can be read directly. `<file>` is
accepted as either a path relative to the docs root (e.g. `manual/8-typography.md`)
or an absolute path.

## Maintainer Scripts

- `scripts/build-se-docs.sh` — rebuild the docs from upstream sources
- `scripts/check-se-docs.sh` — check if docs are outdated
