#!/usr/bin/env bash

INSTALLED_VERSION=$(pipx list --json 2>/dev/null | jq -r '.venvs.standardebooks.metadata.main_package.package_version // "not installed"')
LATEST_VERSION=$(curl -s https://pypi.org/pypi/standardebooks/json | jq -r '.info.version')

if [ "$INSTALLED_VERSION" = "not installed" ]; then
  echo "⚠️  Standard Ebooks tools not installed"
  echo "   Run: pipx install standardebooks"
elif [ "$LATEST_VERSION" != "$INSTALLED_VERSION" ]; then
  echo "📦 Standard Ebooks update available: $INSTALLED_VERSION → $LATEST_VERSION"
  echo "   Run: pipx upgrade standardebooks"
else
  echo "✓ Standard Ebooks tools are up to date ($INSTALLED_VERSION)"
fi
