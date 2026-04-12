#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOCS_DIR="$REPO_ROOT/docs/se-manual"
VERSIONS_FILE="$DOCS_DIR/.versions"
DIFF_MODE=false

if [ "${1:-}" = "--diff" ]; then
  DIFF_MODE=true
fi

for cmd in gh jq se; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Error: $cmd is required but not found" >&2
    exit 1
  fi
done

if [ ! -f "$VERSIONS_FILE" ]; then
  echo "No .versions file found at $VERSIONS_FILE"
  echo "Run scripts/build-se-docs.sh first."
  exit 1
fi

# Read current pinned versions
source "$VERSIONS_FILE"

echo "Checking for SE documentation updates..."
echo ""

STALE=false

# 1. Manual tag
LATEST_MANUAL_TAG=$(gh api repos/standardebooks/manual/tags --jq '.[0].name')
if [ "$LATEST_MANUAL_TAG" != "$manual_tag" ]; then
  echo "OUTDATED  Manual: $manual_tag -> $LATEST_MANUAL_TAG"
  STALE=true
else
  echo "OK        Manual: $manual_tag"
fi

# 2. Web repo contribute SHA
LATEST_WEB_SHA=$(gh api 'repos/standardebooks/web/commits?path=www/contribute&per_page=1' --jq '.[0].sha' | cut -c1-12)
if [ "$LATEST_WEB_SHA" != "$web_sha" ]; then
  echo "OUTDATED  Contribute pages: $web_sha -> $LATEST_WEB_SHA"
  # Show what changed
  gh api "repos/standardebooks/web/compare/${web_sha}...${LATEST_WEB_SHA}" \
    --jq '.commits[] | "           " + .sha[0:8] + " " + (.commit.message | split("\n")[0])' 2>/dev/null || true
  STALE=true
else
  echo "OK        Contribute pages: $web_sha"
fi

# 3. b-t-k SHA
LATEST_BTK_SHA=$(gh api 'repos/b-t-k/b-t-k.github.io/commits?per_page=1' --jq '.[0].sha' | cut -c1-12)
if [ "$LATEST_BTK_SHA" != "$btk_sha" ]; then
  echo "OUTDATED  b-t-k hints: $btk_sha -> $LATEST_BTK_SHA"
  STALE=true
else
  echo "OK        b-t-k hints: $btk_sha"
fi

# 4. se CLI version
LATEST_SE_VERSION=$(se --version 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
if [ "$LATEST_SE_VERSION" != "$se_version" ]; then
  echo "OUTDATED  se CLI: $se_version -> $LATEST_SE_VERSION"
  STALE=true
else
  echo "OK        se CLI: $se_version"
fi

echo ""
echo "Fetched: $fetched"

if [ "$STALE" = true ]; then
  echo ""
  echo "Some docs are outdated. Run scripts/build-se-docs.sh to update."
  echo "Then use 'git diff docs/se-manual/' to review changes before committing."

  if [ "$DIFF_MODE" = true ]; then
    echo ""
    echo "==> --diff: rebuilding to temp dir and diffing..."
    TMP_DIR=$(mktemp -d)
    trap 'rm -rf "$TMP_DIR"' EXIT

    # Copy current docs, rebuild, diff
    cp -r "$DOCS_DIR" "$TMP_DIR/current"

    # Run the build script (it overwrites DOCS_DIR)
    bash "$REPO_ROOT/scripts/build-se-docs.sh"

    echo ""
    echo "==> Diff (committed vs fresh):"
    diff -rq "$TMP_DIR/current" "$DOCS_DIR" || true
    echo ""
    echo "For full diff: diff -ru $TMP_DIR/current $DOCS_DIR | less"
    echo ""
    echo "NOTE: build-se-docs.sh has already updated docs/ in place."
    echo "Use 'git diff docs/se-manual/' to review, then commit or 'git checkout docs/' to revert."
  fi
else
  echo ""
  echo "All docs are up to date."
fi
