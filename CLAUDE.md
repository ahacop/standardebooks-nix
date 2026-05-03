# Project Instructions

## Standard Ebooks Documentation

The SE Manual of Style, contributor guides, and CLI reference are available
locally via the `se-ext docs` command. When answering questions about SE rules,
style, semantics, typography, metadata, or ebook production, use these local
docs instead of fetching from the internet.

- Index:             `se-ext docs` (or `se-ext docs index`)
- List all files:    `se-ext docs ls`
- Search (ERE):      `se-ext docs search '<regex>'`
                     `se-ext docs search --scope manual --context 5 '<regex>'`
- Outline a file:    `se-ext docs headings <file>`
- Extract a section: `se-ext docs section <file> '<heading>'`
- Read line range:   `se-ext docs lines <file> <N-M | N+K | N>`
- Read a whole file: `se-ext docs open <file>`

Search patterns are passed to `grep -E`, so use `|` for alternation:
`se-ext docs search 'proper noun|toponym|place name'`. Results default to
the order manual > contribute > cli > third-party. Use `--scope` /
`--exclude` to filter, `--context N` for wider surrounding lines, and
`--absolute` if you need full paths instead of relative ones. `<file>`
arguments accept either a path relative to the docs root (e.g.
`manual/8-typography.md`) or an absolute path.

Use `lines` to read arbitrary slices of a doc — you should not need a
generic file-read tool for anything under the SE docs root. Combine
`headings` (to find line numbers) with `lines <file> N-M` (to read the
slice) or `section <file> '<heading>'` (to read a full section).

## Maintainer Scripts

- `scripts/build-se-docs.sh` — rebuild the docs from upstream sources
- `scripts/check-se-docs.sh` — check if docs are outdated
