#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOCS_DIR="$REPO_ROOT/docs/se-manual"
VERSIONS_FILE="$DOCS_DIR/.versions"
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

# Dependencies: curl, gh, jq, pandoc, se
for cmd in curl gh jq pandoc se; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Error: $cmd is required but not found" >&2
    exit 1
  fi
done

echo "Building SE docs into $DOCS_DIR"
echo ""

# Clean and recreate
rm -rf "$DOCS_DIR"
mkdir -p "$DOCS_DIR/manual" "$DOCS_DIR/contribute/how-tos" "$DOCS_DIR/third-party" "$DOCS_DIR/cli"

# ─── 1. Manual (RST from standardebooks/manual at latest tag) ────────────────

echo "==> Fetching manual..."

MANUAL_TAG=$(gh api repos/standardebooks/manual/tags --jq '.[0].name')
echo "    Latest tag: $MANUAL_TAG"

# Download tarball and extract
gh api "repos/standardebooks/manual/tarball/$MANUAL_TAG" > "$TMP_DIR/manual.tar.gz"
tar xzf "$TMP_DIR/manual.tar.gz" -C "$TMP_DIR"
MANUAL_SRC=$(find "$TMP_DIR" -maxdepth 1 -type d -name 'standardebooks-manual-*' | head -1)

# Convert each RST section to markdown
for rst_file in "$MANUAL_SRC"/*.rst; do
  basename=$(basename "$rst_file" .rst)
  # Skip the index file — we build our own
  if [ "$basename" = "index" ]; then
    continue
  fi
  echo "    Converting $basename.rst"
  pandoc -f rst -t gfm --wrap=none "$rst_file" -o "$DOCS_DIR/manual/$basename.md"
done

# ─── 2. Contribute pages (rendered HTML from standardebooks.org) ─────────────

echo "==> Fetching contribute pages..."

WEB_SHA=$(gh api 'repos/standardebooks/web/commits?path=www/contribute&per_page=1' --jq '.[0].sha' | cut -c1-12)
echo "    Web repo contribute SHA: $WEB_SHA"

# Top-level contribute pages
CONTRIBUTE_PAGES=(
  "producers"
  "producing-an-ebook-step-by-step"
  "a-basic-standard-ebooks-source-folder"
  "tips-for-editors-and-proofreaders"
)

for page in "${CONTRIBUTE_PAGES[@]}"; do
  echo "    Fetching $page"
  curl -sS "https://standardebooks.org/contribute/$page" \
    | pandoc -f html -t gfm --wrap=none \
    | sed '/^<div/d; /^<\/div>/d' \
    > "$DOCS_DIR/contribute/$page.md"
done

# How-to pages
HOWTO_PAGES=(
  "common-issues-when-working-on-public-domain-ebooks"
  "how-to-choose-and-create-a-cover-image"
  "how-to-conquer-complex-drama-formatting"
  "how-to-create-figures-for-music-scores"
  "how-to-create-svgs-from-maps-with-several-colors"
  "how-to-review-an-ebook-production-for-publication"
  "how-to-structure-and-style-large-poetic-productions"
  "things-to-look-out-for-when-proofreading"
)

for page in "${HOWTO_PAGES[@]}"; do
  echo "    Fetching how-tos/$page"
  curl -sS "https://standardebooks.org/contribute/how-tos/$page" \
    | pandoc -f html -t gfm --wrap=none \
    | sed '/^<div/d; /^<\/div>/d' \
    > "$DOCS_DIR/contribute/how-tos/$page.md"
done

# ─── 3. b-t-k Hints and Tricks (markdown from GitHub) ────────────────────────

echo "==> Fetching b-t-k hints and tricks..."

BTK_SHA=$(gh api 'repos/b-t-k/b-t-k.github.io/commits?per_page=1' --jq '.[0].sha' | cut -c1-12)
echo "    b-t-k SHA: $BTK_SHA"

# Fetch the guide parts and ebook reference files
for file in a-guide/part-1.md a-guide/part-2.md a-guide/part-3.md \
            ebook/base-css.md ebook/checklist.md ebook/how-tos.md ebook/templates.md; do
  dir=$(dirname "$file")
  base=$(basename "$file")
  mkdir -p "$DOCS_DIR/third-party/b-t-k/$dir"
  echo "    Fetching $file"
  curl -sS "https://raw.githubusercontent.com/b-t-k/b-t-k.github.io/main/$file" \
    -o "$DOCS_DIR/third-party/b-t-k/$dir/$base"
done

# ─── 4. CLI help (se subcommand dumps) ───────────────────────────────────────

echo "==> Dumping CLI help..."

SE_VERSION=$(se --version 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
echo "    se version: $SE_VERSION"

# Top-level help
{
  echo "# se — Standard Ebooks Toolset ($SE_VERSION)"
  echo ""
  se --help 2>&1
} > "$DOCS_DIR/cli/README.md"

# Each subcommand — help text wraps across lines with hyphen continuation
SUBCOMMANDS=$(se --help 2>&1 \
  | sed -n '/one of:/,/^  [A-Z]/p' \
  | head -n -1 \
  | sed 's/.*one of: //' \
  | perl -p0e 's/-\n\s+/-/g' \
  | tr -s ' \n' '\n' \
  | grep -v '^$' \
  | sort -u)

for cmd in $SUBCOMMANDS; do
  if [ -z "$cmd" ]; then continue; fi
  echo "    se $cmd"
  {
    echo "# se $cmd"
    echo ""
    echo '```'
    se "$cmd" --help 2>&1 || true
    echo '```'
  } > "$DOCS_DIR/cli/$cmd.md"
done

# ─── 5. Generate INDEX.md ────────────────────────────────────────────────────

echo "==> Generating INDEX.md..."

# Extract a clean title from a markdown file's first heading
md_title() {
  grep -m1 '^#' "$1" | sed 's/^#* //; s/<[^>]*>//g; s/\[↺\]([^)]*)//g' | tr -s ' ' || basename "$1" .md
}

{
  echo "# Standard Ebooks Documentation Index"
  echo ""
  echo "Local mirror of Standard Ebooks documentation for agent/tool consumption."
  echo "Built by \`scripts/build-se-docs.sh\`. Check for updates with \`scripts/check-se-docs.sh\`."
  echo ""

  echo "## Manual of Style (v$MANUAL_TAG)"
  echo ""
  for f in "$DOCS_DIR"/manual/*.md; do
    name=$(basename "$f" .md)
    echo "- [$(md_title "$f")](manual/$name.md)"
  done
  echo ""

  echo "## Contribute Guides"
  echo ""
  for f in "$DOCS_DIR"/contribute/*.md; do
    name=$(basename "$f" .md)
    echo "- [$(md_title "$f")](contribute/$name.md)"
  done
  echo ""

  echo "### How-Tos"
  echo ""
  for f in "$DOCS_DIR"/contribute/how-tos/*.md; do
    name=$(basename "$f" .md)
    echo "- [$(md_title "$f")](contribute/how-tos/$name.md)"
  done
  echo ""

  echo "## b-t-k Hints and Tricks"
  echo ""
  for f in "$DOCS_DIR"/third-party/b-t-k/a-guide/*.md; do
    name=$(basename "$f" .md)
    echo "- [$(md_title "$f")](third-party/b-t-k/a-guide/$name.md)"
  done
  for f in "$DOCS_DIR"/third-party/b-t-k/ebook/*.md; do
    name=$(basename "$f" .md)
    echo "- [$(md_title "$f")](third-party/b-t-k/ebook/$name.md)"
  done
  echo ""

  echo "## CLI Reference (se $SE_VERSION)"
  echo ""
  echo "- [Overview](cli/README.md)"
  for f in "$DOCS_DIR"/cli/*.md; do
    name=$(basename "$f" .md)
    if [ "$name" = "README" ]; then continue; fi
    echo "- [se $name](cli/$name.md)"
  done
} > "$DOCS_DIR/INDEX.md"

# ─── 6. Write .versions ─────────────────────────────────────────────────────

cat > "$VERSIONS_FILE" <<EOF
manual_tag=$MANUAL_TAG
web_sha=$WEB_SHA
btk_sha=$BTK_SHA
se_version=$SE_VERSION
fetched=$(date +%Y-%m-%d)
EOF

echo ""
echo "Done. Versions pinned:"
cat "$VERSIONS_FILE"
echo ""
echo "Docs written to $DOCS_DIR"
find "$DOCS_DIR" -type f | wc -l | xargs -I{} echo "{} files total"
