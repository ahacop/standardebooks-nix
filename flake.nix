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

        tagNationalities = pkgs.writeShellScriptBin "se-tag-nationalities" ''
          if [ -z "$1" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
            echo "Usage: se-tag-nationalities <ebook-directory>"
            echo ""
            echo "Interactively tag nationality/demonym terms with z3998:nationality semantic"
            echo "markup in chapter files. Uses 'se interactive-replace' so each match can be"
            echo "reviewed before accepting."
            echo ""
            echo "WHEN TO TAG"
            echo "  Standard Ebooks tags demonyms broadly — not just when referring to people."
            echo "  Based on actual SE production usage, tag nationality terms in ALL of these cases:"
            echo ""
            echo "  People/groups:     'the Apaches had not yet caught up'"
            echo "  Describing people: 'the English gentlemen'"
            echo "  Describing things: 'English park scenery', 'British literature'"
            echo "  Languages:         'spoke in Apache'"
            echo ""
            echo "WHEN NOT TO TAG"
            echo "  Place names use z3998:place instead (e.g. 'England', 'France', 'London')."
            echo "  If the word IS the place rather than the people/culture of that place, skip it."
            echo ""
            echo "WATCH FOR FALSE POSITIVES"
            echo "  Some terms have non-nationality meanings. Review carefully:"
            echo "    'Indian corn', 'Turkish bath', 'Roman numeral', 'French door'"
            echo "  These idiomatic/generic uses may or may not warrant tagging — use judgment"
            echo "  and check how recent SE productions handle similar cases."
            echo ""
            echo "Example: se-tag-nationalities /path/to/charles-brockden-brown_wieland"
            exit 0
          fi

          EBOOK_DIR="$1"
          TEXT_DIR="$EBOOK_DIR/src/epub/text"

          if [ ! -d "$TEXT_DIR" ]; then
            echo "Error: Directory not found: $TEXT_DIR"
            exit 1
          fi

          # Find all chapter files
          CHAPTER_FILES=$(find "$TEXT_DIR" -name "chapter-*.xhtml" | sort)

          if [ -z "$CHAPTER_FILES" ]; then
            echo "Error: No chapter files found in $TEXT_DIR"
            exit 1
          fi

          # Build a regex alternation of all nationality terms
          # Multi-word terms first so they match before their components
          REGEX='\b(Bissau-Guinean|Cabo Verdean|Central African|Costa Rican|I-Kiribati|Ni-Vanuatu|North Korean|Northern Marianan|Puerto Rican|Saint Lucian|Saint Vincentian|Saudi Arabian|Sierra Leonean|South African|South Africans|South Korean|South Koreans|South Sudanese|Sri Lankan|Sri Lankans|São Toméan|Afghan|Afghans|Albanian|Albanians|Algerian|Algerians|American|Americans|Andorran|Andorrans|Angolan|Angolans|Antiguan|Antiguans|Arabian|Arabians|Argentine|Argentines|Armenian|Armenians|Assyrian|Assyrians|Athenian|Athenians|Australian|Australians|Austrian|Austrians|Azerbaijani|Azeri|Azeris|Babylonian|Babylonians|Bahamian|Bahamians|Bahraini|Bahrainis|Barbadian|Barbadians|Barbudan|Barbudans|Basotho|Belarusian|Belarusians|Belgian|Belgians|Belizean|Belizeans|Bengali|Bengalis|Beninese|Beninois|Bhutanese|Bohemian|Bohemians|Bolivian|Bolivians|Bosnian|Bosnians|Botswanan|Botswanans|Brazilian|Brazilians|British|Briton|Britons|Bruneian|Bruneians|Bulgarian|Bulgarians|Burkinabé|Burmese|Burundian|Burundians|Byzantine|Byzantines|Cambodian|Cambodians|Cameroonian|Cameroonians|Canadian|Canadians|Carthaginian|Carthaginians|Celtic|Celts|Chadian|Chadians|Chilean|Chileans|Chinese|Colombian|Colombians|Comoran|Comorans|Comorian|Comorians|Congolese|Croatian|Croatians|Cuban|Cubans|Cypriot|Cypriots|Czech|Czechs|Danish|Danes|Djiboutian|Djiboutians|Dominican|Dominicans|Dutch|Ecuadorian|Ecuadorians|Egyptian|Egyptians|Emirati|Emiratis|Emirian|Emiri|English|Equatoguinean|Eritrean|Eritreans|Estonian|Estonians|Ethiopian|Ethiopians|European|Europeans|Fijian|Fijians|Filipino|Filipinos|Finnish|Finns|Florentine|Florentines|Frankish|Franks|French|Gabonese|Gallic|Gauls|Gambian|Gambians|Gaul|Genoese|Georgian|Georgians|German|Germans|Ghanaian|Ghanaians|Gothic|Goths|Greek|Greeks|Grenadian|Grenadians|Guatemalan|Guatemalans|Guinean|Guineans|Guyanese|Haitian|Haitians|Hellenic|Hellenes|Herzegovinian|Herzegovinians|Honduran|Hondurans|Hungarian|Hungarians|Icelandic|Icelanders|Indian|Indians|Indonesian|Indonesians|Iranian|Iranians|Iraqi|Iraqis|Irish|Israeli|Israelis|Italian|Italians|Ivorian|Ivorians|Japanese|Jordanian|Jordanians|Kazakh|Kazakhs|Kazakhstani|Kazakhstanis|Kenyan|Kenyans|Kirgiz|Kirghiz|Kittitian|Kittitians|Korean|Koreans|Kuwaiti|Kuwaitis|Kyrgyz|Kyrgyzstani|Kyrgyzstanis|Lao|Laotian|Laotians|Latvian|Latvians|Lebanese|Lettish|Liberian|Liberians|Libyan|Libyans|Liechtensteiner|Liechtensteiners|Lithuanian|Lithuanians|Lombard|Lombards|Luxembourgish|Luxembourgers|Macedonian|Macedonians|Magyar|Magyars|Malagasy|Malawian|Malawians|Malaysian|Malaysians|Maldivian|Maldivians|Malian|Malians|Malinese|Maltese|Marshallese|Martinican|Martinicans|Martiniquais|Mauritanian|Mauritanians|Mauritian|Mauritians|Mexican|Mexicans|Micronesian|Micronesians|Moldovan|Moldovans|Monacan|Monacans|Monégasque|Monégasques|Mongolian|Mongolians|Montenegrin|Montenegrins|Moorish|Moors|Moroccan|Moroccans|Motswana|Mozambican|Mozambicans|Namibian|Namibians|Nauruan|Nauruans|Nepali|Nepalis|Nepalese|Netherlandic|Nevisian|Nevisians|Nicaraguan|Nicaraguans|Nigerian|Nigerians|Nigerien|Nigeriens|Norman|Normans|Norwegian|Norwegians|Omani|Omanis|Ostrogoth|Ostrogoths|Ottoman|Ottomans|Pakistani|Pakistanis|Palauan|Palauans|Palestinian|Palestinians|Panamanian|Panamanians|Papuan|Papuans|Paraguayan|Paraguayans|Persian|Persians|Peruvian|Peruvians|Philippine|Pict|Picts|Polish|Poles|Portuguese|Prussian|Prussians|Qatari|Qataris|Roman|Romans|Romanian|Romanians|Romish|Russian|Russians|Rwandan|Rwandans|Salvadoran|Salvadorans|Sammarinese|Samoan|Samoans|Saracen|Saracens|Saudi|Saudis|Saxon|Saxons|Saxony|Scottish|Scots|Senegalese|Serbian|Serbs|Seychellois|Singaporean|Singaporeans|Slovak|Slovaks|Slovene|Slovenes|Slovenian|Slovenians|Somali|Somalis|Spanish|Spaniard|Spaniards|Spartan|Spartans|Sudanese|Surinamese|Swazi|Swazis|Swedish|Swedes|Swiss|Syrian|Syrians|Tajikistani|Tajikistanis|Tanzanian|Tanzanians|Thai|Thais|Timorese|Tobagonian|Tobagonians|Togolese|Tokelauan|Tokelauans|Tongan|Tongans|Trinidadian|Trinidadians|Tunisian|Tunisians|Turkish|Turks|Turkmen|Tuvaluan|Tuvaluans|Ugandan|Ugandans|Ukrainian|Ukrainians|Uruguayan|Uruguayans|Uzbek|Uzbeks|Uzbekistani|Uzbekistanis|Vandal|Vandals|Vanuatuan|Vanuatuans|Vatican|Venetian|Venetians|Venezuelan|Venezuelans|Vietnamese|Vincentian|Vincentians|Visigoth|Visigoths|Welsh|Yemeni|Yemenis|Zambian|Zambians|Zelanian|Zimbabwean|Zimbabweans)\b'

          # Skip words already inside a z3998:nationality span
          # Uses a negative lookbehind for the opening tag
          REGEX="(?<!z3998:nationality\">)$REGEX"

          REPLACE='<span epub:type="z3998:nationality">\1</span>'

          # shellcheck disable=SC2086
          se interactive-replace "$REGEX" "$REPLACE" $CHAPTER_FILES
        '';

        searchUsage = pkgs.writeShellScriptBin "se-search-usage" ''
          if [ -z "$1" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
            echo "Usage: se-search-usage <search-term> [context-term] [--limit N]"
            echo ""
            echo "Search the Standard Ebooks GitHub org for real-world usage of semantic"
            echo "tags and patterns across published ebooks. Results are sorted by repo"
            echo "update date (newest first) so you can see current conventions."
            echo ""
            echo "EXAMPLES"
            echo "  se-search-usage 'z3998:nationality'              All nationality tag usage"
            echo "  se-search-usage 'z3998:nationality' 'Turkish'    Nationality tags near 'Turkish'"
            echo "  se-search-usage 'z3998:place'                    All place tag usage"
            echo "  se-search-usage 'se:name.vessel'                 Ship/vessel name tags"
            echo "  se-search-usage 'epub:type' 'z3998:' --limit 5   Any epub:type with z3998"
            echo ""
            echo "OPTIONS"
            echo "  --limit N   Show at most N repos (default: 10)"
            echo "  --full      Fetch file contents for richer context around each match"
            exit 0
          fi

          SEARCH_TERM="$1"
          CONTEXT_TERM=""
          LIMIT=10
          FULL_MODE=false

          shift
          while [ $# -gt 0 ]; do
            case "$1" in
              --limit) LIMIT="$2"; shift 2 ;;
              --full) FULL_MODE=true; shift ;;
              --help|-h) exec se-search-usage; ;;
              *) CONTEXT_TERM="$1"; shift ;;
            esac
          done

          # Build the search query
          QUERY="\"$SEARCH_TERM\" org:standardebooks"
          if [ -n "$CONTEXT_TERM" ]; then
            QUERY="\"$SEARCH_TERM\" \"$CONTEXT_TERM\" org:standardebooks"
          fi

          echo "Searching SE org for: $SEARCH_TERM''${CONTEXT_TERM:+ (near '$CONTEXT_TERM')}"
          echo ""

          # Search and get results with repo info
          RESULTS=$(${pkgs.gh}/bin/gh api "search/code?q=$(printf '%s' "$QUERY" | ${pkgs.coreutils}/bin/env -i ${pkgs.python3}/bin/python3 -c 'import sys,urllib.parse;print(urllib.parse.quote(sys.stdin.read().strip()))')&per_page=100" 2>&1)

          TOTAL=$(echo "$RESULTS" | ${pkgs.jq}/bin/jq -r '.total_count // 0')
          echo "Found $TOTAL matches"
          echo ""

          if [ "$TOTAL" = "0" ]; then
            exit 0
          fi

          # Extract unique repos and their files
          REPO_FILES=$(echo "$RESULTS" | ${pkgs.jq}/bin/jq -r '.items[] | "\(.repository.full_name)\t\(.path)\t\(.name)"')

          # Get unique repos
          REPOS=$(echo "$REPO_FILES" | cut -f1 | sort -u)

          # For each repo, get its updated date and sort by it
          REPO_DATES=""
          for REPO in $REPOS; do
            UPDATED=$(${pkgs.gh}/bin/gh api "repos/$REPO" --jq '.pushed_at // .updated_at' 2>/dev/null)
            REPO_DATES="$REPO_DATES$UPDATED\t$REPO\n"
          done

          # Sort repos newest first, limit output
          SORTED_REPOS=$(printf '%b' "$REPO_DATES" | sort -r | head -n "$LIMIT")

          SHOWN=0
          printf '%b' "$SORTED_REPOS" | while IFS="$(printf '\t')" read -r DATE REPO; do
            [ -z "$REPO" ] && continue
            SHOWN=$((SHOWN + 1))
            SHORT_DATE=$(echo "$DATE" | cut -c1-10)
            SHORT_NAME=$(echo "$REPO" | sed 's|standardebooks/||')

            echo "── $SHORT_NAME (updated $SHORT_DATE) ──"

            # List matching files in this repo
            echo "$REPO_FILES" | ${pkgs.gawk}/bin/awk -F'\t' -v repo="$REPO" '$1 == repo { print "  " $2 }'

            if [ "$FULL_MODE" = "true" ]; then
              # Fetch content of first matching file for context
              FIRST_FILE=$(echo "$REPO_FILES" | ${pkgs.gawk}/bin/awk -F'\t' -v repo="$REPO" '$1 == repo { print $2; exit }')
              if [ -n "$FIRST_FILE" ]; then
                CONTENT=$(${pkgs.gh}/bin/gh api "repos/$REPO/contents/$FIRST_FILE" --jq '.content' 2>/dev/null | base64 -d 2>/dev/null)
                if [ -n "$CONTENT" ]; then
                  echo "$CONTENT" | grep -i "$SEARCH_TERM" | head -n 5 | while read -r LINE; do
                    # Trim whitespace and show a snippet
                    TRIMMED=$(echo "$LINE" | sed 's/^[[:space:]]*//' | cut -c1-120)
                    echo "    $TRIMMED"
                  done
                fi
              fi
            fi

            echo ""
          done
        '';

        listScripts = pkgs.writeShellScriptBin "se-list-scripts" ''
          echo "Available scripts:"
          echo ""
          echo "  se-check-version       Check for Standard Ebooks tools updates"
          echo "  se-tag-nationalities   Tag nationality terms with epub:type attributes"
          echo "  se-search-usage        Search SE GitHub for real-world semantic tag usage"
          echo "  se-list-scripts        List available scripts"
          echo ""
          echo "Run any command with --help for more info."
        '';

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
