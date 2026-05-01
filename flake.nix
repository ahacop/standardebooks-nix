{
  description = "Development environment for Standard Ebooks production";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      pyproject-nix,
      uv2nix,
      pyproject-build-systems,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = nixpkgs.lib;

        runtimeDeps = [
          pkgs.jq
          pkgs.curl
          pkgs.gh
          pkgs.gawk
          pkgs.coreutils
          pkgs.findutils
          (pkgs.aspellWithDicts (
            dicts: with dicts; [
              en
              en-computers
            ]
          ))
        ];

        # ---------------------------------------------------------------------
        # standardebooks Python toolchain, built from uv.lock via uv2nix.
        # ---------------------------------------------------------------------
        python = pkgs.python313;

        workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./.; };

        # Prefer wheels (fast). Native wheels get autoPatchelfHook below.
        overlay = workspace.mkPyprojectOverlay {
          sourcePreference = "wheel";
        };

        # Native-wheel overrides — patch RPATH / add bundled-lib deps so the
        # interpreters can dlopen the wheels' embedded shared objects.
        pyprojectOverrides = _final: prev: {
          pyoxipng = prev.pyoxipng.overrideAttrs (old: {
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.autoPatchelfHook ];
            buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.stdenv.cc.cc.lib ];
          });

          pillow = prev.pillow.overrideAttrs (old: {
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.autoPatchelfHook ];
            buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.stdenv.cc.cc.lib pkgs.zlib ];
          });

          lxml = prev.lxml.overrideAttrs (old: {
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.autoPatchelfHook ];
            buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.stdenv.cc.cc.lib ];
          });

          cffi = prev.cffi.overrideAttrs (old: {
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.autoPatchelfHook ];
            buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.stdenv.cc.cc.lib pkgs.libffi ];
          });
        };

        pythonSet =
          (pkgs.callPackage pyproject-nix.build.packages {
            inherit python;
          }).overrideScope
            (
              lib.composeManyExtensions [
                pyproject-build-systems.overlays.default
                overlay
                pyprojectOverrides
              ]
            );

        seVenv = pythonSet.mkVirtualEnv "se-env" workspace.deps.default;

        # cairocffi resolves libcairo via ctypes.find_library at runtime.
        # Scope LD_LIBRARY_PATH to the `se` wrapper only — do NOT export it
        # shell-wide (that mismatches the system glib used by Foliate / GJS
        # and aborts unrelated GUI apps).
        seRuntimeLibs = pkgs.lib.makeLibraryPath [
          pkgs.cairo
          pkgs.gdk-pixbuf
          pkgs.glib
          pkgs.pango
        ];

        # firefox + geckodriver are needed by `se build` when a book contains
        # MathML, and by `se compare-versions`. Hardcoding firefox-unwrapped
        # avoids the user-namespace sandbox the wrapped firefox binary uses.
        seBrowserDeps = [
          pkgs.firefox-unwrapped
          pkgs.geckodriver
        ];

        se = pkgs.runCommand "standardebooks-3.0.3"
          {
            nativeBuildInputs = [ pkgs.makeWrapper ];
            passthru.unwrapped = seVenv;
          }
          ''
            mkdir -p $out/bin
            for bin in ${seVenv}/bin/se ${seVenv}/bin/se-*; do
              [ -e "$bin" ] || continue
              name=$(basename "$bin")
              makeWrapper "$bin" "$out/bin/$name" \
                --prefix PATH : ${pkgs.lib.makeBinPath seBrowserDeps} \
                --prefix LD_LIBRARY_PATH : ${seRuntimeLibs}
            done
          '';

        # ---------------------------------------------------------------------
        # se-ext: project-local helper scripts (preview, page-scans, etc.)
        # ---------------------------------------------------------------------
        seExtRuntimeDeps = runtimeDeps ++ [
          se
          pkgs.python3
        ];

        se-ext = pkgs.stdenv.mkDerivation {
          name = "se-ext";
          src = pkgs.lib.fileset.toSource {
            root = ./.;
            fileset = pkgs.lib.fileset.unions [
              ./scripts
              ./data
              ./docs/se-manual
            ];
          };

          nativeBuildInputs = [ pkgs.makeWrapper ];

          installPhase = ''
            mkdir -p $out/bin $out/share/se-docs $out/share/se-ext-data $out/share/bash-completion/completions $out/share/zsh/site-functions

            # Install documentation
            cp -r docs/se-manual/* $out/share/se-docs/

            # Install data files
            cp -r data/* $out/share/se-ext-data/

            # Install all scripts into bin/
            for f in scripts/*.sh; do
              install -m 755 "$f" "$out/bin/$(basename "$f")"
            done

            # Create the se-ext wrapper with runtime deps on PATH
            makeWrapper $out/bin/ext.sh $out/bin/se-ext \
              --prefix PATH : ${pkgs.lib.makeBinPath seExtRuntimeDeps} \
              --set SE_DOCS $out/share/se-docs \
              --set SE_EXT_DATA $out/share/se-ext-data

            # Install completions
            install -m 644 scripts/completions.bash $out/share/bash-completion/completions/se-ext
            install -m 644 scripts/completions.zsh $out/share/zsh/site-functions/_se_ext
          '';
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
        packages = {
          default = se-ext;
          inherit se se-ext;
        };

        apps.default = {
          type = "app";
          program = "${se-ext}/bin/se-ext";
        };

        devShells.default = pkgs.mkShell {
          packages = [
            se
            se-ext
            pkgs.calibre
            pkgs.git
            pkgs.epubcheck
            pkgs.delta
            pkgs.difftastic
          ];

          shellHook = ''
            # Configure git to use local config with delta and improved diff settings
            export GIT_CONFIG_COUNT=1
            export GIT_CONFIG_KEY_0="include.path"
            export GIT_CONFIG_VALUE_0="${gitConfigLocal}"

            # Configure difftastic as an alternative diff tool
            ${pkgs.git}/bin/git config --local diff.tool difftastic
            ${pkgs.git}/bin/git config --local difftool.prompt false
            ${pkgs.git}/bin/git config --local difftool.difftastic.cmd '${pkgs.difftastic}/bin/difft "$LOCAL" "$REMOTE"'

            # Make SE docs and data available
            export SE_DOCS="${se-ext}/share/se-docs"
            export SE_EXT_DATA="${se-ext}/share/se-ext-data"

            echo ""
            echo "Standard Ebooks development environment"
            echo "Tools available: se (Standard Ebooks), se-ext (extended tools)"
            echo "Run 'se-ext --help' for extended tool commands."
            echo ""
            echo "SE docs available: se-ext docs, se-ext docs search <term>"
            echo ""
            echo "Git diff improvements enabled:"
            echo "  • Delta pager for better long-line diffs"
            echo "  • Histogram diff algorithm"
            echo "  • Aliases: git dw, git dc, git sw, git scw"
            echo "  • Difftastic: git difftool or git dt"
            echo ""
          '';
        };
      }
    );
}
