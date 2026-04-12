# Project Instructions

## Standard Ebooks Documentation

The SE Manual of Style, contributor guides, and CLI reference are available locally via `$SE_DOCS`.
When answering questions about SE rules, style, semantics, typography, metadata, or ebook production, read from these local docs instead of fetching from the internet.

- Index: `$SE_DOCS/INDEX.md`
- Search all docs: `grep -ril "<term>" $SE_DOCS/`
- Manual sections: `$SE_DOCS/manual/`
- Contribute guides: `$SE_DOCS/contribute/`
- CLI reference: `$SE_DOCS/cli/`

## Maintainer Scripts

- `scripts/build-se-docs.sh` — rebuild the docs from upstream sources
- `scripts/check-se-docs.sh` — check if docs are outdated
