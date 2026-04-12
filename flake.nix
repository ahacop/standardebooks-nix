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

        checkVersion = pkgs.writeShellApplication {
          name = "se-check-version";
          runtimeInputs = [
            pkgs.pipx
            pkgs.jq
            pkgs.curl
          ];
          text = builtins.readFile ./scripts/se-check-version.sh;
        };

        tagNationalities = pkgs.writeShellApplication {
          name = "se-tag-nationalities";
          runtimeInputs = [ pkgs.findutils ];
          text = builtins.readFile ./scripts/se-tag-nationalities.sh;
        };

        searchUsage = pkgs.writeShellApplication {
          name = "se-search-usage";
          runtimeInputs = [
            pkgs.gh
            pkgs.jq
            pkgs.gawk
            pkgs.python3
            pkgs.coreutils
          ];
          text = builtins.readFile ./scripts/se-search-usage.sh;
        };

        listScripts = pkgs.writeShellApplication {
          name = "se-list-scripts";
          text = builtins.readFile ./scripts/se-list-scripts.sh;
        };

        # Git configuration for better diff viewing with long lines
        gitConfigLocal = pkgs.writeText "gitconfig-local" ''
          [core]
          	pager = ${pkgs.delta}/bin/delta

          [interactive]
          	diffFilter = ${pkgs.delta}/bin/delta --color-only --features=interactive

          [delta]
          	navigate = true
          	side-by-side = false
          	line-numbers = true
          	syntax-theme = ansi

          [delta "interactive"]
          	keep-plus-minus-markers = false

          [diff]
          	algorithm = histogram
          	colorMoved = default

          [merge]
          	conflictstyle = diff3

          [alias]
          	dw = diff --word-diff
          	dc = diff --color-words
          	sw = show --word-diff
          	scw = show --color-words
          	dt = difftool
        '';
      in
      {
        apps.check-version = {
          type = "app";
          program = "${checkVersion}/bin/se-check-version";
        };

        apps.tag-nationalities = {
          type = "app";
          program = "${tagNationalities}/bin/se-tag-nationalities";
        };

        apps.search-usage = {
          type = "app";
          program = "${searchUsage}/bin/se-search-usage";
        };

        apps.list-scripts = {
          type = "app";
          program = "${listScripts}/bin/se-list-scripts";
        };

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.pipx
            pkgs.python3
            checkVersion
            tagNationalities
            searchUsage
            listScripts
            pkgs.calibre
            pkgs.git
            pkgs.epubcheck
            pkgs.delta
            pkgs.difftastic
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
            export LD_LIBRARY_PATH="${
              pkgs.lib.makeLibraryPath [
                pkgs.cairo
                pkgs.gdk-pixbuf
                pkgs.glib
                pkgs.pango
              ]
            }:$LD_LIBRARY_PATH"

            # Configure git to use local config with delta and improved diff settings
            export GIT_CONFIG_COUNT=1
            export GIT_CONFIG_KEY_0="include.path"
            export GIT_CONFIG_VALUE_0="${gitConfigLocal}"

            # Configure difftastic as an alternative diff tool
            ${pkgs.git}/bin/git config --local diff.tool difftastic
            ${pkgs.git}/bin/git config --local difftool.prompt false
            ${pkgs.git}/bin/git config --local difftool.difftastic.cmd '${pkgs.difftastic}/bin/difft "$LOCAL" "$REMOTE"'

            # Install standardebooks if not already installed
            if ! ${pkgs.pipx}/bin/pipx list 2>/dev/null | grep -q standardebooks; then
              echo "📦 Installing Standard Ebooks tools via pipx..."
              ${pkgs.pipx}/bin/pipx install standardebooks
            fi

            # Check for updates
            se-check-version

            echo ""
            echo "Standard Ebooks development environment"
            echo "Tools available: se (all Standard Ebooks commands), se-list-scripts"
            echo ""
            echo "Git diff improvements enabled:"
            echo "  • Delta pager for better long-line diffs"
            echo "  • Histogram diff algorithm"
            echo "  • Aliases: git dw, git dc, git sw, git scw"
            echo "  • Difftastic: git difftool or git dt"
            echo ""
            echo "To upgrade: pipx upgrade standardebooks"
          '';
        };
      }
    );
}
