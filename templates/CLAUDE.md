# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A Standard Ebooks production. It is not code — it is an EPUB source tree that gets built into distributable ebook files by the `se` toolset. All meaningful "source" lives under `src/epub/` and follows the [Standard Ebooks Manual of Style](https://standardebooks.org/manual).

- `src/epub/content.opf` — package metadata (title, subjects, contributors, manifest, spine). Edit here when adding/removing files or changing metadata.
- `src/epub/text/*.xhtml` — the book body. Front/back matter (`titlepage`, `halftitlepage`, `imprint`, `preface`, `epigraph`, `colophon`, `uncopyright`) plus per-chapter files. Each is polyglot XHTML5 with `epub:type` semantic attributes.
- `src/epub/toc.xhtml` — navigation document; must be regenerated after chapter changes (`se build-toc`).
- `src/epub/css/` — `core.css` and `se.css` are managed by `se` and should not be hand-edited; project-specific overrides go in `local.css`.
- `src/META-INF/`, `src/mimetype` — EPUB container boilerplate; rarely touched.
- `images/` — cover/titlepage source art (outside `src/`), used by `se build-images`.

## Development environment

The shell is provided by the [standardebooks-nix](https://github.com/ahacop/standardebooks-nix) flake (typically loaded via `.envrc` / direnv). It puts `se` and `se-ext` on `PATH` along with `epubcheck`, `calibre` (for `se build`'s Kindle/compatible outputs), `delta`, and `difftastic`, and sets local git config to use delta + histogram diff. There is no `package.json`, `Gemfile`, or similar — everything flows through `se` and `se-ext`.

`se-ext` adds project-aware helpers:

- `se-ext docs` — browse and search the SE Manual of Style and CLI reference locally (see below).
- `se-ext find-archaic-words` — list archaic/obsolete spellings in the book that aren't yet in the modernization word list, with one-line context.
- `se-ext modernize-spelling` — apply archaic-to-modern spelling replacements from the curated word list to `src/epub/text/*.xhtml`. Destructive; review the diff before committing.
- `se-ext page-scans` — extract page-scan URLs (Internet Archive, Google Books, HathiTrust) from `content.opf` and open or list them, optionally with a search term appended.
- `se-ext preview` — `se build` the project and open the resulting EPUB in the system reader. `--advanced` to open the advanced (non-compatible) build.
- `se-ext search-usage` — search the `standardebooks` GitHub org for real-world usage of a semantic tag or pattern, sorted by recency, to confirm prevailing convention before making a stylistic call.

If direnv is not active, enter the shell manually with `nix develop github:ahacop/standardebooks-nix`, or invoke ad-hoc tools via `nix-shell -p <pkg>`.

## Common commands

All `se` subcommands accept the project root (`.`) as their target. Run from the repo root unless noted.

```bash
se lint src                      # primary correctness check
se lint -v src                   # verbose, shows each file being checked
se build src                     # produce .epub / compatible.epub / .kepub.epub in ./dist
se build --check src             # run epubcheck on the built artifacts
se clean src                     # reformat XHTML/CSS/OPF canonically (whitespace, attribute order)
se typogrify src                 # apply typography (curly quotes, en/em dashes, etc.)
se semanticate src               # add common semantic markup (Latin phrases, etc.)
se modernize-spelling src        # rewrite archaic spellings (to-day → today, &c.)
se build-toc src                 # regenerate toc.xhtml from current chapter files/headings
se build-manifest src            # regenerate <manifest> in content.opf
se build-spine src               # regenerate <spine> in content.opf
se word-count src
se recompose-epub src            # single-file HTML, useful for grep/diff across the whole book
se xpath src '//something'       # XPath against the ebook for targeted searches
se find-mismatched-dashes src    # lint helpers for manual review
se find-mismatched-diacritics src
se find-unusual-characters src
```

There is no test suite. `se lint` is the closest thing to one — treat its output as the build gate. `se lint` warnings are categorized (`s-xxx` structural, `t-xxx` typography, `c-xxx` CSS, `m-xxx` metadata); many are intentional and can be ignored with judgement, but new warnings introduced by a change should be addressed.

**Do not run `se lint` reflexively during early production.** A book in production usually has metadata placeholders, unfinished semantic tagging, and other in-progress work that makes `se lint` emit hundreds of warnings unrelated to whatever change you just made. Running it after a small edit buries the signal. Only run `se lint` when the user asks for it, or at a natural checkpoint near the end of a production pass. For verifying the effect of a specific edit, prefer a targeted check (e.g., `se xpath`, `grep`, re-reading the file) over a full lint.

## Workflow conventions

- `se clean` rewrites files in place and is idempotent — run it after manual edits so diffs stay minimal and reviewable. Running `se typogrify` / `semanticate` / `modernize-spelling` on already-processed text is generally safe and should be followed by `se clean`. (Don't chain `se lint` onto the end — see the note above about not running lint reflexively during early production.)
- When you add, remove, split, or rename files under `src/epub/text/`, update *all three* of `content.opf` manifest, `content.opf` spine, and `toc.xhtml`. The `se build-*` commands do this automatically — prefer them to hand-editing.
- `se-ext modernize-spelling` and `se-ext find-archaic-words` share a word list under the flake's `SE_EXT_DATA`. New archaic/modern pairs added there flow through to both commands; treat the list as the source of truth, not the script.

## Commit message style

Match Standard Ebooks' house style: terse imperative subject (≤8 words), typically no body. Do not narrate the content of the change or name characters; the diff is the description. Use `[Editorial]` as a prefix for text/spelling changes (as opposed to structural, metadata, or CSS changes). Examples from real SE repos:

- `Fix typo`
- `Typogrify`
- `Move italics inside punctuation`
- `[Editorial] phrensied -> frenzied`
- `[Editorial] Move semicolon outside of quotation marks per 8.7.2.1`
- `Split merged paragraph`

For edits citing a source scan, put the archive.org `page/NNN/mode/1up` URL alone in the body. No prose rationale — the URL is the evidence.

Avoid: character names, quote-level jargon ("outer / inner / must nest as"), em-dashes in subjects, and any sentence that explains *why* the change is correct. The scan and the diff together are enough.

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

## Searching Standard Ebooks for precedent

Before proposing a manual editorial change — modernized spelling, place-name update, semantic markup choice, metadata convention — check whether the SE corpus already has a precedent. The `gh` CLI is the right tool: hundreds of finished SE productions live under the `standardebooks` GitHub org, and the `tools` repo itself encodes many automated rules.

Two searches almost always answer the question:

```bash
# Has this exact change been made in other productions, and how was it committed?
gh search commits --owner=standardebooks "<term>" --limit 20

# Is the term codified in the toolset, or still present (unmodernized) in some books?
gh search code --owner=standardebooks "<term>" --limit 20
```

Useful follow-ups:

- `gh api repos/standardebooks/<repo>/commits/<sha> --jq '.commit.message'` — read the full commit message (subject + body) to see whether SE producers cite scan URLs for this class of change or leave the body empty.
- `gh search code --owner=standardebooks "<term>" --extension=xhtml` — find books that *kept* the archaic form, then read their `content.opf` `<meta property="se:production-notes">` for the disambiguation rationale (e.g. `Leipsic` retained in *Twenty Years at Hull-House* because it's also a US Midwestern place name).
- `gh search code --owner=standardebooks --filename=spelling.py "<term>"` — check whether `se modernize-spelling` already handles it; if yes, the regex shows the exact scope (and may reveal spelling variants the regex misses, like `Leipsig` vs `Leipsic`).

For semantic-tag questions, prefer `se-ext search-usage` over a raw `gh search` — it handles the org filter, recency sort, and formatting for you.

Report findings before editing: number of prior productions that made the change, whether the toolset codifies it, the prevailing commit-message format, and any documented exceptions. This both validates the change and tells us whether to follow SE's prevailing commit style for that class of edit (often empty body) or our stricter scan-citation convention.
