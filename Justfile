# List available recipes
default:
    @just --list

# Compare the pinned standardebooks version against the latest on PyPI
check-version:
    #!/usr/bin/env bash
    set -euo pipefail
    pinned=$(grep -oP 'standardebooks==\K[^"]+' nix/uv/pyproject.toml)
    latest=$(curl -fsSL https://pypi.org/pypi/standardebooks/json | jq -r '.info.version')
    echo "pinned: $pinned"
    echo "latest: $latest"
    if [ "$pinned" = "$latest" ]; then
        echo "up to date"
    else
        echo "update available"
        exit 1
    fi

# Pin standardebooks to VERSION, regenerate the lock, and verify se -v
update VERSION:
    #!/usr/bin/env bash
    set -euo pipefail
    sed -i 's/standardebooks==[^"]*/standardebooks=={{VERSION}}/' nix/uv/pyproject.toml
    cd nix/uv && nix-shell -p uv python313 --run \
        'UV_PYTHON_DOWNLOADS=never uv lock --upgrade-package standardebooks --python "$(command -v python3.13)"'
    cd "$(git rev-parse --show-toplevel)"
    nix build .#se
    ./result/bin/se -v
