#!/usr/bin/env bash

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
