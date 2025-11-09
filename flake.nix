{
  description = "Development environment for Standard Ebooks production";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Script to check for updates
        checkVersion = pkgs.writeShellScriptBin "se-check-version" ''
          INSTALLED_VERSION=$(${pkgs.pipx}/bin/pipx list --json 2>/dev/null | ${pkgs.jq}/bin/jq -r '.venvs.standardebooks.metadata.main_package.package_version // "not installed"')
          LATEST_VERSION=$(${pkgs.curl}/bin/curl -s https://pypi.org/pypi/standardebooks/json | ${pkgs.jq}/bin/jq -r '.info.version')

          if [ "$INSTALLED_VERSION" = "not installed" ]; then
            echo "⚠️  Standard Ebooks tools not installed"
            echo "   Run: pipx install standardebooks"
          elif [ "$LATEST_VERSION" != "$INSTALLED_VERSION" ]; then
            echo "📦 Standard Ebooks update available: $INSTALLED_VERSION → $LATEST_VERSION"
            echo "   Run: pipx upgrade standardebooks"
          else
            echo "✓ Standard Ebooks tools are up to date ($INSTALLED_VERSION)"
          fi
        '';
      in
      {
        apps.check-version = {
          type = "app";
          program = "${checkVersion}/bin/se-check-version";
        };

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.pipx
            pkgs.python3
            checkVersion
            pkgs.calibre
            pkgs.jre
            pkgs.git
            pkgs.epubcheck
          ];

          # System libraries needed by Python dependencies
          buildInputs = [
            pkgs.cairo
            pkgs.gdk-pixbuf
            pkgs.glib
            pkgs.pango
          ];

          shellHook = ''
            # Ensure pipx is set up
            export PIPX_HOME="$PWD/.pipx"
            export PIPX_BIN_DIR="$PWD/.pipx/bin"
            export PATH="$PIPX_BIN_DIR:$PATH"

            # Make system libraries available to Python packages
            export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
              pkgs.cairo
              pkgs.gdk-pixbuf
              pkgs.glib
              pkgs.pango
            ]}:$LD_LIBRARY_PATH"

            # Install standardebooks if not already installed
            if ! ${pkgs.pipx}/bin/pipx list 2>/dev/null | grep -q standardebooks; then
              echo "📦 Installing Standard Ebooks tools via pipx..."
              ${pkgs.pipx}/bin/pipx install standardebooks
            fi

            # Check for updates
            se-check-version

            echo ""
            echo "Standard Ebooks development environment"
            echo "Tools available: se (all Standard Ebooks commands)"
            echo ""
            echo "To upgrade: pipx upgrade standardebooks"
          '';
        };
      }
    );
}
