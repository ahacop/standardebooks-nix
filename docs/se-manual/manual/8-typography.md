# Typography

## Section titles and ordinals

1.  Section ordinals in the body text are set in Roman numerals.

2.  Section titles are titlecased according to the output of `se titlecase`. Section titles are *not* all-caps or small-caps.

3.  Section titles do not have trailing periods.

4.  Chapter titles omit the word `Chapter`, unless the word used is a stylistic choice for prose style purposes. Chapters with unique identifiers (i.e. not `Chapter`, but something unique to the style of the book, like `Book` or `Stave`) *do* include that unique identifier in the title, wrapped in `<span epub:type="label">`.

    <div class="wrong">

    ``` html
    <h2>Chapter <span epub:type="ordinal z3998:roman">II</span></h2>
    ```

    </div>

    <div class="corrected">

    ``` html
    <h2 epub:type="ordinal z3998:roman">II</h2>
    ```

    ``` html
    <h2>
        <span epub:type="label">Stave</span>
        <span epub:type="ordinal z3998:roman">III</span>
    </h2>
    ```

    </div>

    In special cases it may be desirable to retain `Chapter` for clarity. For example, `Frankenstein </ebooks/mary-shelley/frankenstein>` has “Chapter” in titles to differentiate them from the “Letter” sections.

## Italics

1.  Using both italics *and* quotes (outside of the context of quoted dialog) is usually not necessary. Either one or the other is used, with rare exceptions.

2.  Words and phrases that require emphasis are italicized with the `<em>` element.

    ``` html
    <p>“Perhaps <em>he</em> was there,” Raoul said, at last.</p>
    ```

3.  Strong emphasis, like shouting, may be set in small caps with the `<strong>` element.

    ``` html
    <p>“<strong>Can’t</strong> I?” screamed the unhappy creature to himself.</p>
    ```

4.  When a short phrase within a longer clause is italicized, trailing punctuation that may belong to the containing clause is not italicized.

    <div class="wrong">

    ``` html
    <p>“Look at <em>that!</em>” she shouted.</p>
    ```

    </div>

    <div class="corrected">

    ``` html
    <p>“Look at <em>that</em>!” she shouted.</p>
    ```

    </div>

5.  When an entire clause is italicized, trailing punctuation *is* italicized, *unless* that trailing punctuation is a comma at the end of dialog.

    ``` html
    <p>“<em>Charge!</em>” she shouted.</p>
    ```

    ``` html
    <p>“<em>But I want to</em>,” she said.</p>
    ```

6.  Words written to be read as sounds are italicized with `<i>`.

    ``` html
    <p>He could hear the dog barking: <i>Ruff, ruff, ruff!</i></p>
    ```

7.  A person's internal thoughts, if they are italicized in the source, are formatted with `<q>`, styled with italics. If the thoughts are quoted, they are left as quoted.

    ``` css
    q{
        font-style: italic;
    }
    ```

    ``` html
    <p>The thought flashed to me: <q>it’s a city you’re firing at, not a plane</q>, and I flinched.</p>
    ```

### Italicizing individual letters

1.  Individual letters that are used in context as a [phoneme](https://www.merriam-webster.com/dictionary/phoneme) are italicized with an `<i epub:type="z3998:phoneme">` element. They are sentence-cased and not followed by periods.

    ``` html
    <p>“<i xml:lang="ru-Latn">Mamochka</i>, let’s play <i xml:lang="ru-Latn">priatki</i>,” (hide and seek), cried Lelechka, pronouncing the <i epub:type="z3998:phoneme">r</i> like the <i epub:type="z3998:phoneme">l</i>, so that the word sounded “pliatki.”</p>
    ```

    1.  Plural phonemes are formed with `’s`, to aid in clarity.

        <div class="wrong">

        ``` html
        <p>Her <i epub:type="z3998:phoneme">a</i>s were nasally.</p>
        ```

        </div>

        <div class="corrected">

        ``` html
        <p>Her <i epub:type="z3998:phoneme">a</i>’s were nasally.</p>
        ```

        </div>

2.  [Graphemes](https://www.merriam-webster.com/dictionary/grapheme) are italicized with an `<i epub:type="z3998:grapheme">` element.

    ``` html
    <p>“It’s such a pity,” she would say pensively, “that July hasn’t got an <i epub:type="z3998:grapheme">r</i> in it.</p>
    ```

    1.  When a word is being spelled out, the individual letters of the word are set as graphemes.

        ``` html
        <p>I rattled off, “<i epub:type="z3998:grapheme">t</i>-<i epub:type="z3998:grapheme">h</i>-<i epub:type="z3998:grapheme">i</i>-<i epub:type="z3998:grapheme">r</i>-<i epub:type="z3998:grapheme">d</i>, third.”</p>
        ```

    2.  These exceptions are not set with italics:

        - `minding one’s p’s and q’s`

3.  Individual letters that are *not* graphemes or phonemes (for example letters that might be referring to names, the shapes of the letters themselves, musical notes or keys, or concepts) are *not* italicized.

    ``` html
    <p>...due to the loss of what is known in New England as the “L”: that long deep roofed adjunct usually built at right angles to the main house...</p>
    ```

    ``` html
    <p>She was learning her A.B.C.s.</p>
    ```

    ``` html
    <p>His trident had the shape of an E.</p>
    ```

    ``` html
    <p>The piece was in the key of C major.</p>
    ```

4.  The ordinal `nth` is set with an italicized `n`, without a hyphen.

    ``` html
    <p>The <i>n</i>th degree.</p>
    ```

### Italicizing non-English words and phrases

1.  Non-English words and phrases that are not in [Merriam-Webster](https://www.merriam-webster.com) are italicized, unless they are in a non-Roman script like Chinese or Japanese.

    ``` html
    <p>I have so much to tell you, <i xml:lang="fr">mon petit chou</i> darling.</p>
    ```

2.  Non-English words that are proper names, or are in proper names, are not italicized, unless the name itself would be italicized according to the rules for italicizing or quoting names and titles. If words in the name might be mispronounced in English pronunciation, they are wrapped in a `<span xml:lang="LANGUAGE">` element to assist screen readers with pronunciation. Most proper names of people or places do not require this, but occasionally there may be some that do.

    <div class="wrong">

    ``` html
    <p>“<i xml:lang="fr">Où est le métro?</i>” he asked, and she pointed to <i xml:lang="fr">Place de Clichy</i>, next to the <i xml:lang="fr">Le Bon Petit Déjeuner</i> restaurant.</p>
    ```

    </div>

    <div class="corrected">

    ``` html
    <p>“<i xml:lang="fr">Où est le métro?</i>” he asked, and she pointed to <span xml:lang="fr">Place de Clichy</span>, next to the <span xml:lang="fr">Le Bon Petit Déjeuner</span> restaurant.</p>
    ```

    </div>

3.  If certain non-English words are used so frequently in the text that italicizing them at each instance would be distracting to the reader, then only the first instance is italicized. Subsequent instances are wrapped in a `<span xml:lang="LANGUAGE">` element.

4.  Words and phrases that are originally non-English in origin, but that can now be found in [Merriam-Webster’s](https://www.merriam-webster.com) basic online search results, are not italicized. “Basic online search results” means that results from other dictionaries that may appear alongside basic search results, including results from the unabridged or legal dictionaries, do not fall under this rule and may still be obscure enough to be italicized.

    ``` html
    <p>Sir Percy’s bon mot had gone the round of the brilliant reception-rooms.</p>
    ```

5.  Inline-level italics are set using the `<i>` element with an `xml:lang` attribute corresponding to the correct [IETF language tag](https://en.wikipedia.org/wiki/IETF_language_tag).

6.  Block-level italics are set using an `xml:lang` attribute on the closest encompassing block element, with the style of `font-style: italic`.

    In this example, note the additional namespace declaration, and that we target only `<blockquote>` elements that have the language tag. This is because there can be other elements, e.g. `<span>`, that have a language tag but should not be italicized.

    ``` css
    @namespace xml "http://www.w3.org/XML/1998/namespace";

    blockquote[xml|lang]{
        font-style: italic;
    }
    ```

    ``` html
    <blockquote epub:type="z3998:verse" xml:lang="la">
        <p>
            <span>—gelidas leto scrutata medullas,</span>
            <br/>
            <span>Pulmonis rigidi stantes sine vulnere fibras</span>
            <br/>
            <span>Invenit, et vocem defuncto in corpore quaerit.</span>
        </p>
    </blockquote>
    ```

7.  Words that are in a non-English “alien” language (i.e. one that is made up, like in a science fiction or fantasy work) are italicized and given an IETF language tag in a custom namespace. Custom namespaces consist of `x-TAG`, where `TAG` is a custom descriptor of 8 characters or less.

    ``` html
    <p>“<i xml:lang="x-arcturan">Dolm</i>,” said Haunte.</p>
    ```

8.  Words that are in an unknown language have their `xml:lang` attribute set to `und`.

9.  Some phrases that are not English in origin but that are common in English prose, and which begin in a word that could be confused with an English word, are always italicized (with their appropriate `xml:lang` attribute) to prevent confusion. An incomplete list follows:

    - `sic`
    - `a posteriori`
    - `a priori`
    - `a fortiori`
    - `ad absurdum`
    - `ad hominem`
    - `ad infinitum`
    - `ad interim`
    - `ad nauseam`
    - `in absentia`
    - `in camera`
    - `in loco parentis`
    - `in situ`
    - `in statu quo`
    - `in toto`
    - `in vitro`
    - `inter alia`
    - `more suo`

### Italicizing or quoting newly-used English words

1.  When introducing new terms, non-English or technical terms are italicized, but terms composed of common English are set in quotation marks.

    ``` html
    <p>English whalers have given this the name “ice blink.”</p>
    <p>The soil consisted of that igneous gravel called <i>tuff</i>.</p>
    ```

2.  English neologisms in works where a special vocabulary is a regular part of the narrative are not italicized. For example science fiction works may necessarily contain made-up English technology words, and those are not italicized.

3.  Words used as words are quoted.

    ``` html
    <p>She said “diseased” for “deceased,” quite seriously, and she called Krokowski the “Asst.”</p>
    ```

### Italics in names and titles

1.  Place names, like pubs, bars, or buildings, are not italicized or quoted.
2.  The names of publications, music, and art that can stand alone are italicized; additionally, the names of transport vessels are italicized. These include, but are not limited to:
    - Periodicals like magazines, newspapers, and journals.
    - Publications like books, novels, plays, and pamphlets, *except* “holy texts,” like the Bible or books within the Bible.
    - Long poems and ballads, like the `Iliad </ebooks/homer/the-iliad/william-cullen-bryant>`, that are book-length.
    - Long musical compositions or audio, like operas, music albums, or radio shows.
    - Long cinematic art, like full-length films or a TV show series.
    - Visual art, like paintings or sculptures.
    - Transport vessels, like ships.
3.  The names of short publications, music, or art, that cannot stand alone and are typically part of a larger collection or work, are quoted. These include, but are not limited to:
    - Short musical compositions or audio, like pop songs, arias, or an episode in a radio series.
    - Short prose like novellas, short stories, or short (i.e. not epic) poems.
    - Chapter titles in a prose work.
    - Essays or individual articles in a newspaper or journal.
    - Short cinematic art, like short films or episodes in a TV series.

#### Examples

<div class="wrong">

``` html
<p>He read “Candide” while having a pint at the “King’s Head.”</p>
```

</div>

<div class="corrected">

``` html
<p>He read <i epub:type="se:name.publication.book">Candide</i> while having a pint at the King’s Head.</p>
```

</div>

<div class="wrong">

``` html
<p>If Edgar Allen Poe had put her into <i epub:type="se:name.publication.short-story">The Fall of the House of Usher</i>, she would have fitted it like the paper on the wall.</p>
```

</div>

<div class="corrected">

``` html
<p>If Edgar Allen Poe had put her into “<span epub:type="se:name.publication.short-story">The Fall of the House of Usher</span>,” she would have fitted it like the paper on the wall.</p>
```

</div>

### Taxonomy

1.  Binomial names (generic, specific, and subspecific) are italicized with a `<i>` element having the `z3998:taxonomy` semantic inflection.

    ``` html
    <p>A bonobo monkey is <i epub:type="z3998:taxonomy">Pan paniscus</i>.</p>
    ```

2.  Genus, tribe, subfamily, family, order, class, phylum or division, and kingdom names are capitalized but not italicized.

    ``` html
    <p>A bonobo monkey is in the phylum Chordata, class Mammalia, order Primates.</p>
    ```

3.  If a taxonomic name is the same as the common name, it is not italicized.

4.  The second part of the binomial name follows the capitalization style of the source text. Modern usage requires lowercase, but older texts may set it in uppercase.

### Exceptions

1.  Epigraphs, bridgeheads, and some other types of heading matter are set in italics by default. Text that in a Roman-set context would be italicized (like non-English words or phrases, or titles of books) are thus set in Roman in that heading matter, to contrast against the default italics. However, if due to this rule the *entire block* would be set in Roman instead of italics, thus lending the block an unexpected appearance, then the contrasting Roman is discarded and the default italics are preserved.

    > [!TIP]
    > This can usually be achieved by removing `<i>` elements (which have no semantic meaning and merely indicate the desire for italics) and moving their `epub:type` or `xml:lang` attributes to their parent element.

    <div class="wrong">

    ``` css
    [epub|type~="epigraph"]{
        font-style: italic;
        /* ... */
    }

    [epub|type~="epigraph"] i{
        font-style: normal;
    }

    [epub|type~="epigraph"] cite{
        font-style: normal;
        font-variant: small-caps;
        margin-top: 1em;
    }

    [epub|type~="epigraph"] cite i{
        font-style: italic;
    }
    ```

    ``` html
    <blockquote epub:type="epigraph">
        <p>“<i xml:lang="fr">En administration, toutes les sottises sont mères.</i>”</p>
        <cite><i epub:type="se:name.publication.book" xml:lang="fr">Maximes</i>, <i xml:lang="la">fr</i> <abbr epub:type="z3998:given-name">M. G.</abbr> De Levis.</cite>
    </blockquote>
    ```

    </div>

    <div class="corrected">

    ``` css
    [epub|type~="epigraph"]{
        font-style: italic;
        /* ... */
    }

    [epub|type~="epigraph"] i{
        font-style: normal;
    }

    [epub|type~="epigraph"] cite{
        font-style: normal;
        font-variant: small-caps;
        margin-top: 1em;
    }

    [epub|type~="epigraph"] cite i{
        font-style: italic;
    }
    ```

    ``` html
    <blockquote epub:type="epigraph">
        <p xml:lang="fr">“En administration, toutes les sottises sont mères.”</p>
        <cite><i epub:type="se:name.publication.book" xml:lang="fr">Maximes</i>, <i xml:lang="la">fr</i> <abbr epub:type="z3998:given-name">M. G.</abbr> De Levis.</cite>
    </blockquote>
    ```

    </div>

## Capitalization

1.  In general, capitalization follows modern English style. Some very old works frequently capitalize nouns that today are no longer capitalized. These archaic capitalizations are removed, unless doing so would change the meaning of the work.

2.  Titlecasing, or the capitalization of titles, follows the formula used in the `se titlecase` tool.

3.  Text in all caps is almost never correct typography. Instead, such text is changed to the correct case and surrounded with a semantically-meaningful element like `<em>` (for emphasis), `<strong>` (for strong emphasis, like shouting) or `<b>` (for unsemantic formatting required by the text). `<strong>` and `<b>` are styled in small-caps by default in Standard Ebooks.

    <div class="wrong">

    ``` html
    <p>The sign read BOB’S RESTAURANT.</p>
    ```

    ``` html
    <p>“CHARGE!” he cried.</p>
    ```

    </div>

    <div class="corrected">

    ``` html
    <p>The sign read <b>Bob’s Restaurant</b>.</p>
    ```

    ``` html
    <p>“<strong>Charge!</strong>” he cried.</p>
    ```

    </div>

4.  When something is addressed as an [apostrophe](https://www.merriam-webster.com/dictionary/apostrophe#dictionary-entry-2), `O` is capitalized.

    ``` html
    <p>I carried the bodies into the sea, O walker in the sea!</p>
    ```

5.  Names followed by a generational suffix, like `Junior` or `Senior`, have the suffix uppercased if the suffix is part of the person's name.

    Occasionally, `junior` or `senior` may be used to refer to a younger or elder person having the same last name, but not necessarily the same first name. In these cases, the suffix is lowercased as it is not part of their name, but rather describing their generational relation.

    ``` html
    <p>He talked to Bob Smith Junior.</p>
    <p>He talked to John Doe <abbr class="eoc">Jr.</abbr></p>
    <p>Madame Bovary junior was afraid of accidents for her husband.</p>
    ```

## Indentation

1.  Paragraphs that directly follow another paragraph are indented by <span class="title-ref">1em</span>.
2.  The first line of body text in a section, or any text following a visible break in text flow (like a header, a scene break, a figure etc.), is not indented, with the exception of block quotations.
    1.  Body text following a block quotation is indented only if the text begins a new semantic paragraph. Otherwise, if the body text following a block quotation is semantically part of the paragraph preceding the block quotation, it is not indented. Such non-indented paragraphs have `class="continued"`, which removes the default indentation.

        ``` html
        <p>He sat down before a writing-table and, taking pen and ink, wrote on a slip of paper as follows:⁠—</p>
        <blockquote epub:type="z3998:letter">
            <p>The Bishop of Barchester is dead.</p>
        </blockquote>
        <p>“There,” said he. “Just take that to the telegraph office at the railway station and give it in as it is.”</p>
        ```

        ``` html
        <p>He opened the cover in which the message was enclosed and, having read it, he took his pen and wrote on the back of it⁠—</p>
        <blockquote epub:type="z3998:letter">
            <p epub:type="z3998:salutation">For the Earl of ⸻,</p>
            <footer role="presentation">
                <p epub:type="z3998:valediction">With the Earl of ⸻’s compliments</p>
            </footer>
        </blockquote>
        <p class="continued">and sent it off again on its journey.</p>
        ```

## Headers

1.  Titles or subtitles that are *entirely* non-English-language are not italicized. However, they do have an `xml:lang` attribute to assist screen readers in pronunciation. Titles or subtitles that are in English but contain non-English *components* have those components italicized according to the general rules for italics.

    ``` html
    <h2 epub:type="title" xml:lang="la">Ex Oblivione</h2>

    <hgroup>
        <h2 epub:type="ordinal z3998:roman">XI</h2>
        <p epub:type="title">The <i epub:type="se:name.vessel.ship">Nautilus</i></p>
    </hgroup>

    <hgroup>
        <h2 epub:type="ordinal z3998:roman">XXXV</h2>
        <p epub:type="title">Miss Thorne’s <i xml:lang="fr">Fête Champêtre</i></p>
    </hgroup>

    <hgroup>
        <h2 epub:type="ordinal z3998:roman">XI</h2>
        <p epub:type="title" xml:lang="la">Christus Nos Liberavit</p>
    </hgroup>
    ```

### Chapter headers

1.  Epigraphs in chapters have the quote source set in small caps, without a leading em dash and without a trailing period.

    <div class="wrong">

    ``` html
    <header>
        <h2 epub:type="ordinal z3998:roman">II</h2>
        <blockquote epub:type="epigraph">
            <p>“Desire no more than to thy lot may fall. …”</p>
            <cite>—Chaucer.</cite>
        </blockquote>
    </header>
    ```

    </div>

    <div class="corrected">

    ``` css
    header [epub|type~="epigraph"] cite{
        font-variant: small-caps;
    }
    ```

    ``` html
    <header>
        <h2 epub:type="ordinal z3998:roman">II</h2>
        <blockquote epub:type="epigraph">
            <p>“Desire no more than to thy lot may fall. …”</p>
            <cite>Chaucer</cite>
        </blockquote>
    </header>
    ```

    </div>

## Ligatures

Ligatures are two or more letters that are combined into a single letter, usually for stylistic purposes. In general they are not used in modern English spelling, and are replaced with their expanded characters. Latin ligatures are for presentation only, so they are replaced as well, including in Latin publication names.

Words in non-English languages like French may use ligatures to differentiate words or pronunciations. In these cases, ligatures are retained.

<div class="wrong">

``` html
<p>Œdipus Rex</p>
<p>Archæology</p>
```

</div>

<div class="corrected">

``` html
<p>Oedipus Rex</p>
<p>Archaeology</p>
```

</div>

## Punctuation and spacing

1.  Sentences are single-spaced.

2.  Periods and commas are placed within quotation marks; i.e. American-style punctuation is used, not logical (AKA “British” or “new”) style.

    <div class="wrong">

    ``` html
    <p>Bosinney ventured: “It’s the first spring day”.</p>
    ```

    </div>

    <div class="corrected">

    ``` html
    <p>Bosinney ventured: “It’s the first spring day.”</p>
    ```

    </div>

    1.  If dialog ends in a semicolon, the semicolon is placed within the closing quotation mark. Otherwise, semicolons always go outside of quotation marks.

        ``` html
        <p>“I’ve ask Him, and ask Him, but der help don’t come. I can do no more;” and a tempest of despairing sobs shook her gaunt frame.</p>
        ```

        ``` html
        <p>A premonition told him that this misfortune had befallen the little “Family”; he quickly drew on a coat and ran over to the “Ark.”</p>
        ```

3.  Ampersands are preceded by a no-break space (U+00A0).

    ``` html
    <p>The firm of Hawkins:ws:`nbsp`&amp; Harker.</p>
    ```

4.  Some older works include spaces in common contractions; these spaces are removed.

    <div class="wrong">

    ``` html
    <p>Would n’t it be nice to go out? It ’s such a nice day.</p>
    ```

    </div>

    <div class="corrected">

    ``` html
    <p>Wouldn’t it be nice to go out? It’s such a nice day.</p>
    ```

    </div>

### Quotation marks

1.  “Curly” or typographer’s quotes, both single and double, are always used instead of straight quotes. This is known as “American-style” quotation, which is different from British-style quotation which is also commonly found in both older and modern books.

    ``` html
    <p>“Don’t do it!” she shouted.</p>
    ```

2.  Quotation marks that are directly side-by-side are separated by a hair space (` ` or U+200A) character.

    ``` html
    <p>“:ws:`hairsp`‘Green?’ Is that what you said?” asked Dave.</p>
    ```

3.  Words with missing letters represent the missing letters with a right single quotation mark (`’` or U+2019) character to indicate elision.

    ``` html
    <p>He had pork ’n’ beans for dinner</p>
    ```

    1.  Elision is not to be confused with a glottal stop, which may sometimes occur in non-English languages like Hawaiian. Glottal stops that are not elided letters are represented with a turned comma (`ʻ` or U+02BB), *not* the similar-looking left single quotation mark (`‘` or U+2018).

        ``` html
        <p><i xml:lang="haw">ʻŌlelo Hawaiʻi</i></p>
        ```

    2.  Rarely, in older texts some common last names are rendered using a left single quotation mark (`‘` or U+2018) instead of a superscript `c`. This is a matter of typography, and is not the actual spelling of such names. These names are changed to their equivalent modern spelling.

        <div class="wrong">

        ``` html
        <p>His friends were James M‘Donald and Sam M‘Daniel.</p>
        ```

        </div>

        <div class="corrected">

        ``` html
        <p>His friends were James McDonald and Sam McDaniel.</p>
        ```

        </div>

4.  Ditto marks are set with the right double quotation mark glyph (`”` or U+201D), This is not to be confused with the ditto mark glyph (`〃` or U+3003), which is for non-Latin scripts only, or the quotation mark glyph (`"` or U+0022).

    > ``` html
    > <table>
    >     <tbody>
    >         <tr>
    >             <td>3</td>
    >             <td><abbr>lbs.</abbr></td>
    >         </tr>
    >         <tr>
    >             <td>12</td>
    >             <td>”</td>
    >         </tr>
    >     </tbody>
    > </table>
    > ```

5.  Some idiomatic phrases are not set with scare quotes:

    - `... to a T.`

### Ellipses

1.  The ellipsis glyph (`…` or U+2026) is used for ellipses, instead of consecutive or spaced periods.

2.  When ellipses are used as suspension points (for example, to indicate dialog that pauses or trails off), the ellipses are not preceded by a comma.

    Ellipses used to indicate missing words in a quotation require keeping surrounding punctuation, including commas, as that punctuation is in the original quotation.

3.  A word joiner (U+2060), followed by a hair space (` ` or U+200A) glyph, followed by another word joiner (U+2060), are located *before* all ellipses that do not begin a paragraph, and that are not directly preceded by `“`.

4.  A regular space is located *after* all ellipses that do not end a paragraph and that are not followed by punctuation.

5.  A hair space (` ` or U+200A) glyph is located between an ellipsis and any punctuation that follows directly after the ellipsis, *unless* that punctuation is a quotation mark, in which case there is no space at all between the ellipsis and the quotation mark.

    ``` html
    <p>“I’m so hungry:ws:`wj`:ws:`hairsp`:ws:`wj`…:ws:`hairsp`! Let’s eat:ws:`wj`:ws:`hairsp`:ws:`wj`…”
    ```

### Dashes

There are many kinds of dashes, and the run-of-the-mill hyphen is often not the correct dash to use. In particular, hyphens are not used for things like date ranges, phone numbers, or negative numbers.

1.  Dashes of all types do not have white space around them.

2.  Figure dashes (`‒` or U+2012) are used to indicate a dash in numbers that aren’t a range, like phone numbers.

    ``` html
    <p>His number is 555‒1234.</p>
    ```

3.  Hyphens (`-` or U+002D) are used to join words, including double-barrel names, or to separate syllables in a word. The Unicode hyphen (U+2010) is not used.

    ``` html
    <p>Pre- and post-natal.</p>
    ```

    ``` html
    <p>The Smoot-Hawley act.</p>
    ```

4.  Minus sign glyphs (`−` or U+2212) are used to indicate negative numbers, and are used in mathematical equations instead of hyphens to represent the “subtraction” operator.

    ``` html
    <p>It was −5° out yesterday!</p>
    ```

    ``` html
    <p>5 − 2 = 3</p>
    ```

5.  En dashes (`–` or U+2013) are used to indicate a numeric or date range; to indicate a relationship where two concepts are connected by the word “to,” for example a distance between locations or a range between numbers; or to indicate a connection in location between two places. En dashes are preceded and followed by the invisible word joiner glyph (U+2060).

    ``` html
    <p>We talked 2:ws:`wj`–:ws:`wj`3 days ago.</p>
    ```

    ``` html
    <p>We took the Berlin:ws:`wj`–:ws:`wj`Munich train yesterday.</p>
    ```

    ``` html
    <p>I saw the torpedo-boat in the Ems⁠:ws:`wj`–:ws:`wj`⁠Jade Canal.</p>
    ```

6.  Non-breaking hyphens (`‑` or U+2011) are used when a single word is stretched out by a speaker for prosodic effect.

    ``` html
    <p>When you wa‑ake, you shall ha‑ave, all the pretty little hawsiz—</p>
    ```

7.  Horizontal bars (`―` or U+2015), also known as quotation dashes, are used in prose whose style uses dashes instead of quotation marks for dialogue (for example, [Ulysses](https://standardebooks.org/ebooks/james-joyce/ulysses)).

#### Em dashes

Em dashes (`—` or U+2014) are typically used to offset parenthetical phrases.

1.  Em dashes are preceded by the invisible word joiner glyph (U+2060).

2.  Interruption in dialog is set by a single em dash, not two em dashes or a two-em dash.

    <div class="wrong">

    ``` html
    <p>“I wouldn’t go as far as that, not myself, but:ws:`wj`——”</p>
    ```

    </div>

    <div class="corrected">

    ``` html
    <p>“I wouldn’t go as far as that, not myself, but:ws:`wj`—”</p>
    ```

    </div>

#### Partially-obscured words

A partially-obscured word is a word that the author chooses to not divulge by consistently obscuring some or all of it. This is not the same as an interruption in dialog, which may interrupt a word, but not obscure it in the same stylistic sense.

1.  Em dashes are used for *partially-obscured* years and *totally-obscured* days of the month.

    ``` html
    <p>It was the year 19:ws:`wj`— in the town of Metropolis.</p>

    <p>She arrived on May —, 1922.</p>
    ```

2.  A figure dash is used in *partially-obscured* years where only the last number is obscured, and in *partially-obscured* days of the month.

    ``` html
    <p>It was the year 192‒ in the town of Metropolis.</p>

    <p>His birthday was August 1‒, 1911.</p>
    ```

3.  A non-breaking hyphen (`‑` or U+2011) is used when a single letter is obscured in a word.

    ``` html
    <p>He performed Mozart’s famous canon, “Leck mich im A‑sche.”</p>
    ```

4.  A two-em dash (`⸺` or U+2E3A) preceded by a word joiner glyph (U+2060) is used in *partially* obscured words.

    ``` html
    <p>Sally J:ws:`wj`⸺ walked through town.</p>
    ```

    1.  If both the start and end of a partially-obscured word are visible, a word joiner is placed on both sides of the two-em dash.

        ``` html
        <p>A bl:ws:`wj`⸺:ws:`wj`y murder!</p>
        ```

5.  A three-em dash (`⸻` or U+2E3B) is used for *completely* obscured words.

    ``` html
    <p>It was night in the town of ⸻.</p>
    ```

## Numbers, measurements, and math

1.  Coordinates are set with the prime (`′` or U+2032) or double prime (`″` or U+2033) glyphs, *not* single or double quotes.

    <div class="wrong">

    ``` html
    <p><abbr>Lat.</abbr> 27° 0' <abbr epub:type="se:compass">N.</abbr>, <abbr>long.</abbr> 20° 1' <abbr class="eoc" epub:type="se:compass">W.</abbr></p>
    <p><abbr>Lat.</abbr> 27° 0’ <abbr epub:type="se:compass">N.</abbr>, <abbr>long.</abbr> 20° 1’ <abbr class="eoc" epub:type="se:compass">W.</abbr></p>
    ```

    </div>

    <div class="corrected">

    ``` html
    <p><abbr>Lat.</abbr> 27° 0′ <abbr epub:type="se:compass">N.</abbr>, <abbr>long.</abbr> 20° 1′ <abbr class="eoc" epub:type="se:compass">W.</abbr></p>
    ```

    </div>

2.  Ordinals for Arabic numbers are as follows: `st`, `nd`, `rd`, `th`.

    <div class="wrong">

    ``` html
    <p>The 1st, 2d, 3d, 4th.</p>
    ```

    </div>

    <div class="corrected">

    ``` html
    <p>The 1st, 2nd, 3rd, 4th.</p>
    ```

    </div>

3.  Numbers in a non-mathematical context are spelled out in the following cases:

    - If they are from 0–100.
    - If they are whole numbers from 0–100 and are made greater by being paired with words like `hundred`, `thousand`, `million`, and so on.
    - If they begin a sentence.
    - If they are simple fractions.

    <div class="corrected">

    ``` html
    <p>“They had a gun on the West Front⁠—a seventy-five,” said O’Keefe.</p>
    <p>Allowing her twelve thousand miles of straight-line travel through Uranus’ frigid soupy atmosphere.</p>
    <p>He died in the year 619.</p>
    <p>The vote needed two-thirds majority.</p>
    <p>The army consisted of 113,000 soldiers.</p>
    <p>He reached out of the unlived depths of nineteen hundred years.</p>
    ```

    </div>

    1.  If a series of numbers is close together in a sentence, and one would be spelled out but another wouldn’t, spell out all numbers within that context to maintain visual consistency.

        <div class="wrong">

        ``` html
        <p>There the Gulf Stream is 75 miles wide and two hundred ten meters deep.</p>
        ```

        </div>

        <div class="corrected">

        ``` html
        <p>There the Gulf Stream is seventy-five miles wide and two hundred ten meters deep.</p>
        ```

        </div>

    2.  The *plural* form of spelled-out numbers is formed without an apostrophe. However the *possessive* or *contracted* form does include an apostrophe.

        <div class="wrong">

        ``` html
        <p>There were, the other answered, half a dozen two four two’s.</p>
        ```

        </div>

        <div class="corrected">

        ``` html
        <p>There were, the other answered, half a dozen two four twos.</p>

        <p>Twice two’s four, and a stone’s a stone.</p>

        <p>He was allowed a day or two’s shooting in September.</p>
        ```

        </div>

4.  Numbers of four or more digits should include commas at every 3rd decimal place.

    > <div class="wrong">
    >
    > ``` html
    > <p>“You will agree to do me service for the sum of 4000 guilders?”</p>
    > ```
    >
    > </div>
    >
    > <div class="corrected">
    >
    > ``` html
    > <p>“You will agree to do me service for the sum of 4,000 guilders?”</p>
    > ```
    >
    > </div>

### Roman numerals

1.  Roman numerals are set using uppercase ASCII, not the Unicode Roman numeral glyphs.

2.  Roman numerals have the semantic inflection of `z3998:roman`.

3.  Roman numerals are not followed by trailing periods, except for grammatical reasons.

4.  Roman numerals are not followed by ordinal indicators.

    <div class="wrong">

    ``` html
    <p>Henry <span epub:type="z3998:roman">VIII</span>th had six wives.</p>
    ```

    </div>

    <div class="corrected">

    ``` html
    <p>Henry <span epub:type="z3998:roman">VIII</span> had six wives.</p>
    ```

    </div>

### Fractions

1.  Fractions are set in their appropriate Unicode glyph, if a glyph available; for example, `½`, `¼`, `¾` and U+00BC–U+00BE and U+2150–U+2189.

    <div class="wrong">

    ``` html
    <p>I need 1/4 cup of sugar.</p>
    ```

    </div>

    <div class="corrected">

    ``` html
    <p>I need ¼ cup of sugar.</p>
    ```

    </div>

2.  If a fraction doesn’t have a corresponding Unicode glyph, it is composed using the fraction slash Unicode glyph (`⁄` or U+2044) and superscript/subscript Unicode numbers. See [this Wikipedia entry for more details](https://en.wikipedia.org/wiki/Unicode_subscripts_and_superscripts).

    <div class="wrong">

    ``` html
    <p>Roughly 6/10 of a mile.</p>
    ```

    </div>

    <div class="corrected">

    ``` html
    <p>Roughly ⁶⁄₁₀ of a mile.</p>
    ```

    </div>

3.  There is no space between a whole number and its fraction.

    <div class="corrected">

    ``` html
    <p>There are 365¼ days in a year.</p>
    ```

    </div>

### Measurements

1.  Dimension measurements are set using the Unicode multiplication glyph (`×` or U+00D7), *not* the ASCII letter `x` or `X`.

    <div class="wrong">

    ``` html
    <p>The board was 4 x 3 x 7 feet.</p>
    ```

    </div>

    <div class="corrected">

    ``` html
    <p>The board was 4 × 3 × 7 feet.</p>
    ```

    </div>

2.  Feet and inches in shorthand are set using the prime (`′` or U+2032) or double prime (`″` or U+2033) glyphs (*not* single or double quotes), with a no-break space (U+00A0) separating consecutive feet and inch measurements.

    <div class="wrong">

    ``` html
    <p>He was 6':ws:`nbsp`1" in height.</p>
    <p>He was 6’:ws:`nbsp`1” in height.</p>
    ```

    </div>

    <div class="corrected">

    ``` html
    <p>He was 6′:ws:`nbsp`1″ in height.</p>
    ```

    </div>

3.  When forming a compound of a number and unit of measurement in which the measurement is abbreviated, the number and unit of measurement are separated with a no-break space (U+00A0), *not* a dash. For exceptions in money, see [8.8.8](#8.8.8).

    <div class="wrong">

    ``` html
    <p>A 12-<abbr>mm</abbr> pistol.</p>
    ```

    </div>

    <div class="corrected">

    ``` html
    <p>A 12:ws:`nbsp`<abbr>mm</abbr> pistol.</p>
    ```

    </div>

#### Punctuation in abbreviated measurements

[See here for general abbreviation rules that also apply to measurements](/manual/VERSION/8-typography#8.10).

1.  Abbreviated [SI units](https://en.wikipedia.org/wiki/International_System_of_Units) are set in lowercase without periods. They are not initialisms.

    ``` html
    <p>A 12:ws:`nbsp`<abbr>mm</abbr> pistol.</p>
    ```

2.  Abbreviated [English](https://en.wikipedia.org/wiki/English_units), [Imperial](https://en.wikipedia.org/wiki/Imperial_units), or [U.S. customary](https://en.wikipedia.org/wiki/United_States_customary_units) units that are one word are set in lowercase with a trailing period. They are not initialisms.

    ``` html
    <p>We had two 9:ws:`nbsp`<abbr>ft.</abbr> sledges, of 41:ws:`nbsp`<abbr>lbs.</abbr> each.</p>
    ```

    The one exception is `G` (i.e. `G-force`), which is an initialism that is set without a period.

    ``` html
    <p>There’s a force of over a hundred thousand <abbr epub:type="z3998:initialism">G</abbr>’s.</p>
    ```

3.  Abbreviated English, Imperial, or U.S. customary units that are more than one word (like `hp` for `horse power` or `mph` for `miles per hour`) are set in lowercase without periods. They are not initialisms.

    ``` html
    <p>He drove his 40:ws:`nbsp`<abbr>hp</abbr> car at 20:ws:`nbsp`<abbr>mph</abbr>.</p>
    ```

### Math

1.  In works that are not math-oriented or that don’t have a significant amount of mathematical equations, equations are set using regular HTML and Unicode.

    1.  Operators and operands in mathematical equations are separated by a space.

        <div class="wrong">

        ``` html
        <p>6−2+2=6</p>
        ```

        </div>

        <div class="corrected">

        ``` html
        <p>6 − 2 + 2 = 6</p>
        ```

        </div>

    2.  Operators like subtraction (`−` or U+2212), multiplication (`×` or U+00D7), and equivalence (`≡` or U+2261) are set using their corresponding Unicode glyphs, *not* a hyphen or `x`. Almost all mathematical operators have a corresponding special Unicode glyph.

        <div class="wrong">

        ``` html
        <p>6 - 2 x 2 == 2</p>
        ```

        </div>

        <div class="corrected">

        ``` html
        <p>6 − 2 × 2 ≡ 2</p>
        ```

        </div>

    3.  Simple in-line variables are set individually with the `<var>` tag.

        ``` html
        <p>If the value of the labour = <var>x</var> and the force of demand = <var>y</var>, the exchangeable value of the commodity is <var>x</var><var>y</var></p>
        ```

2.  In works that are math-oriented or that have a significant amount of math, *all* variables, equations, and other mathematical objects are set using MathML.

    1.  When MathML is used in a file, the `m` namespace is declared at the top of the file and used for all subsequent MathML code, as follows:

        ``` html
        xmlns:m="http://www.w3.org/1998/Math/MathML"
        ```

        This namespace is declared and used even if there is just a single MathML equation in a file.

        <div class="wrong">

        ``` html
        <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" epub:prefix="z3998: http://www.daisy.org/z3998/2012/vocab/structure/, se: https://standardebooks.org/vocab/1.0" xml:lang="en-GB">
        ...
        <p>
            <math xmlns="http://www.w3.org/1998/Math/MathML" alttext="x">
                <ci>x</ci>
            </math>
        </p>
        ```

        </div>

        <div class="corrected">

        ``` html
        <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" xmlns:m="http://www.w3.org/1998/Math/MathML" epub:prefix="z3998: http://www.daisy.org/z3998/2012/vocab/structure/, se: https://standardebooks.org/vocab/1.0" xml:lang="en-GB">
        ...
        <p>
            <m:math alttext="x">
                <m:ci>x</m:ci>
            </m:math>
        </p>
        ```

        </div>

    2.  When possible, Content MathML is provided in an additional `<m:annotation-xml>` element. (This may not always be possible depending on the complexity of the work.)

        <div class="corrected">

        ``` html
        <p>
            <m:math alttext="x + 1 = y">
                <m:semantics>
                    <m:mrow>
                        <m:mi>x</m:mi>
                        <m:mo>+</m:mo>
                        <m:mn>1</m:mn>
                        <m:mo>=</m:mo>
                        <m:mi>y</m:mi>
                    </m:mrow>
                    <m:annotation-xml encoding="MathML-Content">
                        <m:apply>
                            <m:eq/>
                            <m:apply>
                                <m:plus/>
                                <m:ci>x</m:ci>
                                <m:cn>1</m:cn>
                            </m:apply>
                            <m:ci>y</m:ci>
                        </m:apply>
                    </m:annotation-xml>
                </m:semantics>
            </m:math>
        </p>
        ```

        </div>

    3.  Each `<m:math>` element has an `alttext` attribute.

        1.  The `alttext` attribute describes the contents in the element in plain-text Unicode according to the rules in [this specification](https://www.unicode.org/notes/tn28/UTN28-PlainTextMath.pdf).

        2.  Operators in the `alttext` attribute are surrounded by a single space.

            <div class="wrong">

            ``` html
            <p>
                <m:math alttext="x+1=y">
                    <m:apply>
                        <m:eq/>
                        <m:apply>
                            <m:plus/>
                            <m:ci>x</m:ci>
                            <m:cn>1</m:cn>
                        </m:apply>
                        <m:ci>y</m:ci>
                    </m:apply>
                </m:math>
            </p>
            ```

            </div>

            <div class="corrected">

            ``` html
            <p>
                <m:math alttext="x + 1 = y">
                    <m:apply>
                        <m:eq/>
                        <m:apply>
                            <m:plus/>
                            <m:ci>x</m:ci>
                            <m:cn>1</m:cn>
                        </m:apply>
                        <m:ci>y</m:ci>
                    </m:apply>
                </m:math>
            </p>
            ```

            </div>

    4.  When using Presentation MathML, `<m:mrow>` is used to group subexpressions, but only when necessary. Many elements in MathML, like `<m:math>` and `<m:mtd>`, *imply* `<m:mrow>`, and redundant elements are not desirable. See [this section of the MathML spec](https://www.w3.org/TR/MathML3/chapter3.html#presm.reqarg) for more details.

        <div class="wrong">

        ``` html
        <p>
            <m:math alttext="x">
                <m:mrow>
                    <m:mi>x</m:mi>
                </m:mrow>
            </m:math>
        </p>
        ```

        </div>

        <div class="corrected">

        ``` html
        <p>
            <m:math alttext="x">
                <m:mi>x</m:mi>
            </m:math>
        </p>
        ```

        </div>

    5.  If a Presentation MathML expression contains a function, the invisible Unicode function application glyph (U+2061) is used as an operator between the function name and its operand. This element looks exactly like the following, including the comment for readability: `<m:mo>⁡<!--hidden U+2061 function application--></m:mo>`. (Note that the preceding element contains an *invisible* Unicode character! It can be revealed with the `se unicode-names` tool.)

        <div class="wrong">

        ``` html
        <p>
            <m:math alttext="f(x)">
                <m:mi>f</m:mi>
                <m:mrow>
                    <m:mo fence="true">(</m:mo>
                    <m:mi>x</m:mi>
                    <m:mo fence="true">)</m:mo>
                </m:mrow>
            </m:math>
        </p>
        ```

        </div>

        <div class="corrected">

        ``` html
        <p>
            <m:math alttext="f(x)">
                <m:mi>f</m:mi>
                <m:mo>⁡:utf:`U+2061`<!--hidden U+2061 function application--></m:mo>
                <m:mrow>
                    <m:mo fence="true">(</m:mo>
                    <m:mi>x</m:mi>
                    <m:mo fence="true">)</m:mo>
                </m:mrow>
            </m:math>
        </p>
        ```

        </div>

    6.  Expressions grouped by parenthesis or brackets are wrapped in an `<m:mrow>` element, and fence characters are set using the `<m:mo fence="true">` element. Separators are set using the `<m:mo separator="true">` element. `<m:mfenced>`, which used to imply both fences and separators, is deprecated in the MathML spec and thus is not used.

        <div class="wrong">

        ``` html
        <p>
            <m:math alttext="f(x,y)">
                <m:mi>f</m:mi>
                <m:mo>⁡:utf:`U+2061`<!--hidden U+2061 function application--></m:mo>
                <m:mfenced>
                    <m:mi>x</m:mi>
                    <m:mi>y</m:mi>
                </m:mfenced>
            </m:math>
        </p>
        ```

        </div>

        <div class="corrected">

        ``` html
        <p>
            <m:math alttext="f(x,y)">
                <m:mi>f</m:mi>
                <m:mo>⁡:utf:`U+2061`<!--hidden U+2061 function application--></m:mo>
                <m:mrow>
                    <m:mo fence="true">(</m:mo>
                    <m:mi>x</m:mi>
                    <m:mo separator="true">,</m:mo>
                    <m:mi>x</m:mi>
                    <m:mo fence="true">)</m:mo>
                </m:mrow>
            </m:math>
        </p>
        ```

        </div>

    7.  If a MathML variable includes an overline, it is set by combining the variable’s normal Unicode glyph and the Unicode overline glyph, `‾` (U+203E), in a `<m:mover>` element. However in the `alttext` attribute, the Unicode combining overline, `◌̅` (U+0305), is used to represent the overline in Unicode.

        <div class="corrected">

        ``` html
        <p>
            <m:math alttext="x̅">
                <m:mover>
                    <m:mi>x</m:mi>
                    <m:mo>‾</m:mo>
                </m:mover>
            </m:math>
        </p>
        ```

        </div>

3.  Ratios are expressed with the Unicode ratio character (`∶` or U+2236) surrounded by spaces, not a colon. The ratio character is also used for logical comparisons in non-mathematical contexts, like analogies in running prose.

    ``` html
    <p>And so we get four names⁠—two for intellect, and two for opinion⁠—reason or mind, understanding, faith, perception of shadows⁠—which make a proportion⁠—being ∶ becoming ∶∶ intellect ∶ opinion⁠— and science ∶ belief ∶∶ understanding ∶ perception of shadows.
    ```

### Money

1.  Typographically-correct symbols are used for currency symbols.

    <div class="wrong">

    ``` html
    <p>The exchange rate was L2 for $1.</p>
    ```

    </div>

    <div class="corrected">

    ``` html
    <p>The exchange rate was £2 for $1.</p>
    ```

    </div>

2.  Currency symbols are not abbreviations.

#### £sd shorthand

[£sd shorthand](https://en.wikipedia.org/wiki/%C2%A3sd) is a way of denoting pre-decimal currencies (pounds, shillings, and pence) common in England and other parts of the world until the 1970s.

1.  There is no white space between a number and an £sd currency symbol.

    <div class="wrong">

    ``` html
    <p>£ 14 8 s. 2 d. is known as a “tuppence.”</p>
    ```

    </div>

    <div class="corrected">

    ``` html
    <p>£14 8<abbr>s.</abbr> 2<abbr>d.</abbr> is known as a “tuppence.”</p>
    ```

    </div>

2.  Abbreviated currencies used in £sd shorthand are wrapped in `<abbr>` elements.

    <div class="wrong">

    ``` html
    <p>£14 8s. 2d. is known as a “tuppence.”</p>
    ```

    </div>

    <div class="corrected">

    ``` html
    <p>£14 8<abbr>s.</abbr> 2<abbr>d.</abbr> is known as a “tuppence.”</p>
    ```

    </div>

3.  Abbreviated currencies used in £sd shorthand are followed by periods.

> [!TIP]
> £sd notation *may* contain actual fractions, but more often include solidi (`/` or U+002F) to represent a unit of account, *not* a fractional value. Make sure to use fractional number style (e.g. fractional glyphs like `½` or super/subscript with a fraction slash like `²⁄₆`) only when referring to *actual fractions*.
>
> <div class="wrong">
>
> ``` html
> <p>£2/³⁄₆ is two pounds, three shillings, and sixpence.</p><!--Incorrect, here / is a unit of account and not a fractional number.-->
> <p>²⁄₆ is two shillings and six pence.</p><!--Incorrect, here / is a unit of account and not a fractional number.-->
> <p>1 1/2d is a penny halfpenny.</p><!--Incorrect, here / is a fraction for "one half."-->
> ```
>
> </div>
>
> <div class="corrected">
>
> ``` html
> <p>£2/3/6 is two pounds, three shillings, and sixpence.</p>
> <p>2/6 is two shillings and six pence.</p>
> <p>1½<abbr>d.</abbr> is a penny halfpenny.</p>
> ```
>
> </div>

### Dates

1.  Years with 4 digits are set without commas, but years with 5 digits or more include commas at every 3rd decimal place.

    <div class="wrong">

    ``` html
    <p>Tutankhamun ruled till 1,325 <abbr epub:type="se:era z3998:initialism">BC</abbr>.</p>
    ```

    </div>

    <div class="corrected">

    ``` html
    <p>Tutankhamun ruled till 1325 <abbr epub:type="se:era z3998:initialism">BC</abbr>, but ancient aliens built the pyramids in 12,633 <abbr epub:type="se:era z3998:initialism">BC</abbr>.</p>
    ```

    </div>

## Latinisms

- [See here for times](/manual/VERSION/8-typography#8.11).

1.  Latinisms that can be found in a modern dictionary are not italicized, [with some exceptions](/manual/VERSION/8-typography#8.2.9.9). Examples of Latinisms that are not italicized include `e.g.`, `i.e.`, `ad hoc`, `viz.`, `ibid.`, `etc.`.

    1.  Exception: `inst.`, the abbreviation of `instante mense`, is not italicized.

        ``` html
        <p>The two bade adieu to their landlady upon Tuesday, the 4th <abbr xml:lang="la">inst.</abbr>, and departed to Euston Station with the avowed intention of catching the Liverpool express.</p>
        ```

2.  Whole passages of Latin language and Latinisms that aren’t found in a modern dictionary are italicized.

3.  `&c.` is not used, and is replaced with `etc.`.

4.  For `Ibid.`, [see Endnotes](/manual/VERSION/7-high-level-structural-patterns#7.10).

5.  Latinisms that are abbreviations are set in lowercase with periods between words and no spaces between them, except `BC`, `AD`, `BCE`, and `CE`, which are set without periods, in small caps, and wrapped with `<abbr epub:type="se:era z3998:initialism">`:

    ``` css
    abbr[epub|type~="se:era"]{
        font-variant: all-small-caps;
    }
    ```

    ``` html
    <p>Julius Caesar was born around 100 <abbr epub:type="se:era z3998:initialism">BC</abbr>.</p>
    ```

## Initials and abbreviations

- [See here for temperatures](/manual/VERSION/8-typography#8.13).
- [See here for times](/manual/VERSION/8-typography#8.11).
- [See here for Latinisms including BC and AD](/manual/VERSION/8-typography#8.9).
- [See here for measurements](/manual/VERSION/8-typography#8.8).

1.  Acronyms (terms made up of initials and pronounced as one word, like `NASA`, `SCUBA`, or `NATO`) are set in small caps, without periods, and are wrapped in an `<abbr epub:type="z3998:acronym">` element with corresponding CSS.

    ``` css
    [epub|type~="z3998:acronym"]{
        font-variant: all-small-caps;
    }
    ```

    ``` html
    <p>He was hired by <abbr epub:type="z3998:acronym">NASA</abbr> last week.</p>
    ```

2.  Initialisms (terms made up of initials in which each initial is pronounced separately, like `M.P.`, `P.S.`, or `U.S.S.R.`) are set with periods and without spaces (with some exceptions that follow) and are wrapped in an `<abbr epub:type="z3998:initialism">` element.

    ``` html
    <p>He was hired by the <abbr epub:type="z3998:initialism">U.S.</abbr> <abbr epub:type="z3998:initialism">F.B.I.</abbr> last week.</p>
    ```

3.  When an abbreviation that is not an acronym contains a terminal period, its `<abbr>` element has the additional `eoc` class (End of Clause) if the terminal period is also the last period in clause. Such sentences do not have two consecutive periods.

    ``` html
    <p>She loved Italian food like pizza, pasta, <abbr class="eoc">etc.</abbr></p>
    ```

    ``` html
    <p>He lists his name alphabetically as Johnson, <abbr class="eoc" epub:type="z3998:given-name">R. A.</abbr></p>
    ```

    ``` html
    <p>His favorite hobby was <abbr epub:type="z3998:acronym">SCUBA</abbr>.</p>
    ```

4.  Initials of people’s names are each separated by periods and spaces. The group of initials is wrapped in an `<abbr epub:type="z3998:*-name">` element. The correct semantic is selected from `z3998:personal-name` (a complete personal name including last name), `z3998:given-name` (a person's given, or first, name(s), and/or middle name), or `z3998:surname` (a person's last name). If it’s unclear whether a name is a first or last name, `z3998:personal-name` is used as a catchall.

    ``` html
    <p><abbr epub:type="z3998:given-name">H. P.</abbr> Lovecraft described himself as an aged antiquarian.</p>

    <p>William <abbr epub:type="z3998:given-name">H.</abbr> Taft was our twenty-seventh president.</p>

    <footer>
        <p epub:type="z3998:signature"><abbr epub:type="z3998:personal-name">A. A. C.</abbr></p>
        <p>Dec 12, 1933</p>
    </footer>
    ```

5.  Post-nominal letters, including academic degrees, honors, and memberships, are wrapped in an `<abbr epub:type="z3998:name-title">` element. They may also require the `z3998:initialism` semantic if they are initialisms, i.e. are wholly composed of initials and not abbreviated words like `Phil.`. Post-nominal letters that consist of initials are set with a period after each initial. Post-nominal letters that contain abbreviated words (like :string: <span class="title-ref">Ph.</span> or <span class="title-ref">Phil.</span>) are set with a hair space between the word and any preceding or following initials.

    ``` html
    <p>Judith Douglas, <abbr class="eoc" epub:type="z3998:name-title z3998:initialism">D.D.S.</abbr></p>
    <p>Abraham Van Helsing, <abbr epub:type="z3998:name-title z3998:initialism">M.D.</abbr>, <abbr epub:type="z3998:name-title">D.:ws:`hairsp`Ph.</abbr>, <abbr epub:type="z3998:name-title">D.:ws:`hairsp`Lit.</abbr>, <abbr>etc.</abbr>, <abbr class="eoc">etc.</abbr></p>
    <p>Charles Lyell, <abbr epub:type="z3998:name-title">Esq.</abbr>, <abbr epub:type="z3998:name-title">Ph.:ws:`hairsp`D.</abbr>, <abbr epub:type="z3998:name-title z3998:initialism">F.R.S.</abbr><p>
    ```

    1.  Some degrees are exceptions:
        - `LL.D.` does not have a period in `LL`, because it indicates the plural `Legum`.

6.  Postal codes and abbreviated U.S. states are set in all caps, without periods or spaces, and are wrapped in an `<abbr epub:type="z3998:place">` element.

    ``` html
    <p>Washington <abbr epub:type="z3998:place">DC</abbr>.</p>
    ```

7.  Abbreviations that are abbreviations of a single word, and that are not acronyms or initialisms (like `Mr.`, `Mrs.`, or `lbs.`) are set with `<abbr>`.

    1.  Abbreviations ending in a lowercase letter are set without spaces between the letters, and have a trailing period.

    2.  Abbreviations without lowercase letters are set without spaces and without a trailing period.

    3.  Abbreviations that describe the next word, like `Mr.`, `Mrs.`, `Mt.`, and `St.`, are set with a no-break space (U+00A0) between the abbreviation and its target.

        ``` html
        <p>He called on <abbr epub:type="z3998:name-title">Mrs.</abbr>:ws:`nbsp`Jones yesterday.</p>
        ```

8.  Compass points are separated by periods and spaces. The group of points are wrapped in an `<abbr epub:type="se:compass">` element.

    ``` html
    <p>He traveled <abbr epub:type="se:compass">S.</abbr>, <abbr epub:type="se:compass">N. W.</abbr>, then <abbr class="eoc" epub:type="se:compass">E. S. E.</abbr></p>
    ```

9.  Strings of assigned numbers and letters used to uniquely identify an item within a class of related items, for example radio station call signs (`WBEZ`, `2LO`) or aircraft model numbers (`Embraer E190-E2`, `Gulfstream G700`) are not abbreviations and are therefore not within an `<abbr>` element. They may or may not be set with periods, whichever is customary for that particular string.

### Exceptions

1.  The following are not abbreviations, and are set without periods or spaces.

    - `A1`
    - `BB`, when referring to a BB gun or its projectiles.
    - `OK`
    - `SOS`
    - `SS`, when referring to [collars of SS](https://www.merriam-webster.com/dictionary/collar%20of%20SS).

2.  The following are initialisms, but are set without periods or spaces:

    - `TV`, i.e. `television`.

    - `AC` and `DC`, when referring to electrical current.

    - `G`, when used in the sense of `G-force`. Also see [8.8.7.4.2](#8.8.7.4.2).

    - Stock ticker symbols.

      ``` html
      <p>She bought 125 shares of <abbr epub:type="z3998:initialism">XYZ</abbr> corporation.</p>
      ```

3.  The following are abbreviations, but are not initialisms. Unlike almost all other abbreviations, they are in all caps and only have a period at the end.

    - `MS.` (manuscript)
    - `MSS.` (manuscripts)
    - `M.` (Monsieur)
    - `MM.` (Messieurs)

    ``` html
    <p><abbr epub:type="z3998:name-title">MM.</abbr>:ws:`nbsp`Guy and Luc were putting the finishing touches on the <abbr>MS.</abbr> of their new novel.</p>
    ```

4.  `A.B.C.`, when used in the sense of the alphabet, is not an abbreviation, and is set with periods between the letters. But other uses, like `A.B.C. shops`, *are* abbreviations. (The abbreviation in `A.B.C. shop` stands for “[Australian Broadcasting Corporation](https://en.wikipedia.org/wiki/ABC_Commercial).”)

    ``` html
    <p>She was learning her A.B.C.s</p>
    <p>He stopped by the <abbr epub:type="z3998:initialism">A.B.C.</abbr> shop.</p>
    ```

5.  Company names and brand marks which may be abbreviations, but are stylized without periods by the brand, are kept in the style preferred by the brand.

    ``` html
    <p>He read an <abbr epub:type="z3998:initialism">AP</abbr> news wire story.</p>
    <p>She called her colleague at <abbr epub:type="z3998:initialism">IBM</abbr>.</p>
    ```

6.  The abbreviations `1D`, `2D`, `3D`, and `4D`, meaning first, second, third, and fourth dimensions, are abbreviations but do not have a trailing period.

7.  The words `recto` and `verso` are sometimes abbreviated with an initial and a superscript `o`. They are regular abbreviations, set without periods, and the `o` is superscripted with `<sup>`.

    ``` html
    <p><abbr>Ch.</abbr> 1, <abbr>fol.</abbr> 2 <abbr>r<sup>o</sup></abbr>.</p>
    ```

## Times

1.  Times in a.m. and p.m. format are set in lowercase, with periods, and without spaces.
2.  `a.m.` and `p.m.` are wrapped in an `<abbr>` element.

### Times as digits

1.  Digits in times are separated by a colon, not a period or comma.

2.  Times written in digits followed by `a.m.` or `p.m.` are set with a no-break space (U+00A0) between the digit and `a.m.` or `p.m.`.

    ``` html
    <p>He called at 6:40:ws:`nbsp`<abbr class="eoc">a.m.</abbr></p>
    ```

### Times as words

1.  Words in a spelled-out time are separated by spaces, unless they appear before a noun, where they are separated by a hyphen.

    ``` html
    <p>He arrived at five thirty.</p>
    ```

    ``` html
    <p>They took the twelve-thirty train.</p>
    ```

2.  Times written in words followed by `a.m.` or `p.m.` are set with a regular space between the time and `a.m.` or `p.m.`.

    ``` html
    <p>She wasn’t up till seven <abbr class="eoc">a.m.</abbr></p>
    ```

3.  Military times that are spelled out (for example, in dialog) are set with dashes. Leading zeros are spelled out as `oh`.

    ``` html
    <p>He arrived at oh-nine-hundred.</p>
    ```

## Chemicals and compounds

1.  Molecular compounds are set in Roman, without spaces, and wrapped in an `<abbr epub:type="se:compound">` element.

    ``` html
    <p>He put extra <abbr epub:type="se:compound">NaCl</abbr> on his dinner.</p>
    ```

2.  Elements in a molecular compound are capitalized according to their listing in the periodic table.

3.  Amounts of an element in a molecular compound are set in subscript with a `<sub>` element.

    ``` html
    <p>She drank eight glasses of <abbr epub:type="se:compound">H<sub>2</sub>O</abbr> a day.</p>
    ```

## Temperatures

1.  The minus sign glyph (`−` or U+2212), not the hyphen glyph, is used to indicate negative numbers.
2.  Either the degree glyph (`°` or U+00B0) or the word `degrees` is acceptable. Works that use both are normalized to use the dominant method.

### Abbreviated units of temperature

1.  Units of temperature measurement, like Fahrenheit or Celsius, may be abbreviated to `F` or `C`.

2.  Units of temperature measurement do not have trailing periods.

3.  If an *abbreviated* unit of temperature measurement is preceded by a number, the unit of measurement is first preceded by a hair space (` ` or U+200A).

4.  Abbreviated units of measurement are set in small caps.

5.  Abbreviated units of measurement are wrapped in an `<abbr epub:type="se:temperature">` element.

    ``` css
    [epub|type~="se:temperature"]{
        font-variant: all-small-caps;
    }
    ```

    ``` html
    <p>It was −23.33° Celsius (or −10°:ws:`hairsp`<abbr epub:type="se:temperature">F</abbr>) last night.</p>
    ```

## Scansion

Scansion is the representation of the metrical stresses in lines of verse.

1.  When scansion marks are next to, instead of above, letters, `×` (U+00d7) indicates an unstressed syllable and `/` (U+002f) indicates a stressed syllable. They are separated from each other with no-break spaces (U+00A0).

    ``` html
    <p>Several of his types, however, constantly occur; <abbr>e.g.</abbr> A and a variant (/ × | / ×) (/ × × | / ×); B and a variant (× / | × /) (× × / | × /); a variant of D (/ × | / × ×); E (/ × × | /).</p>
    ```

2.  When scansion marks are above letters, a combining breve, `◌̆` (U+0306), is used to indicate an unstressed syllable and a combining vertical line above, `◌̍` (U+030D), is used to indicate a stressed syllable. Vertical lines are always above letters, not next to them. Indicating unstressed symbols is optional.

    ``` html
    <p>I̍f wĕ sha̍dŏws ha̍ve ŏffe̍ndĕd, / Thi̍nk bŭt thi̍s ănd a̍ll ĭs me̍ndĕd.</p>
    ```

3.  In verse scansion, the grave accent is used when a silent vowel is pronounced to fit the meter, typically applied to words ending in -ed.

    ``` html
    ...
    <span>The wingèd hounds of Winter ceased to bay.</span>
    <br/>
    <span>The stupor of a doom completed lay</span>
    ...
    ```

4.  Lines of poetry listed on a single line (like in a quotation) are separated by a space, then a forward slash, then a space. Capitalization is preserved for each line.

    ``` html
    <p>The famous lines “Wake! For the Sun, who scatter’d into flight / The Stars before him from the Field of Night” are from <i epub:type="se:name.publication.book">The Rubáiyát of Omar Khayyám</i>.</p>
    ```

## Legal cases and terms

1.  Legal cases are set in italics.

2.  Either `versus` or `v.` are acceptable in the name of a legal case; if using `v.`, a period follows the `v.`, and it is wrapped in an `<abbr>` element.

    ``` html
    <p>He prosecuted <i epub:type="se:name.legal-case">Johnson <abbr>v.</abbr> Smith</i>.</p>
    ```

## Morse code

Any Morse code that appears in a book is changed to fit Standard Ebooks’ format.

### American Morse Code

1.  Middle dot glyphs (`·` or U+00B7) are used for the short mark or dot.

2.  En dash (`–` or U+2013) are used for the longer mark or short dash.

3.  Em dashes (`—` or U+2014) are used for the long dash (the letter L).

4.  If two en dashes are placed next to each other, a hair space (` ` or U+200A) is placed between them to keep the glyphs from merging into a longer dash.

5.  Only in American Morse Code, there are internal gaps used between glyphs in the letters C, O, R, or Z. No-break spaces (U+00A0) are used for these gaps.

6.  En spaces (U+2002) are used between letters.

7.  Em spaces (U+2003) are used between words.

    > <div class="wrong">
    >
    > ``` html
    > <p>--  .. ..   __  ..  - -  __  .   . ..  __  -..   .. .  .- -</p>
    > <p>My little old cat.</p>
    > ```
    >
    > </div>
    >
    > <div class="corrected">
    >
    > ``` html
    > <p>– – ·· ·· — ·· – – — · · · — –·· ·· · ·– –</p>
    > <p>My little old cat.</p>
    > ```
    >
    > </div>

## Citations

1.  Citations are wrapped in a `<cite>` element.

2.  Citations that are the source of a quote are preceded by a space and an em dash, within the `<cite>` element.

    ``` html
    <p>“The Moving Finger writes; and, having writ, moves on.” <cite>—<i epub:type="se:name.publication.book">The Rubaiyat of Omar Khayyam</i></cite>.</p>
    ```

3.  Citations within a `<blockquote>` element have the `<cite>` element as the last direct child of the `<blockquote>` parent.

    <div class="wrong">

    ``` html
    <blockquote>
        <p>“The Moving Finger writes; and, having writ, moves on.”</p>
        <p>
            <cite>—<i epub:type="se:name.publication.book">The Rubaiyat of Omar Khayyam</i></cite>
        </p>
    </blockquote>
    ```

    </div>

    <div class="corrected">

    ``` html
    <blockquote>
        <p>“The Moving Finger writes; and, having writ, moves on.”</p>
        <cite>—<i epub:type="se:name.publication.book">The Rubaiyat of Omar Khayyam</i></cite>
    </blockquote>
    ```

    </div>

### Verses and Chapters of the Bible

1.  Citations of passages from the Bible include the name of the book, followed by the chapter number and the verse number. The chapter and the verse numbers are separated by a colon.

    1.  All chapter and verse numbers are written in Arabic numerals. Similarly, if a book being cited is a “numbered” book, the number is also written in Arabic numerals.

    <div class="wrong">

    ``` html
    <blockquote>
        <p>“Though I speak with the tongues of men and of angels, and have not charity, I am become as sounding brass, or a tinkling cymbal.”</p>
        <cite>—<span epub:type="z3998:roman">I</span> Corinthians <span epub:type="z3998:roman">XIII</span> 1</cite>
    </blockquote>
    ```

    </div>

    <div class="corrected">

    ``` html
    <blockquote>
        <p>“Though I speak with the tongues of men and of angels, and have not charity, I am become as sounding brass, or a tinkling cymbal.”</p>
        <cite>—1 Corinthians 13:1</cite>
    </blockquote>
    ```

    </div>

2.  If an entire chapter, instead of a particular verse, is being cited, then the citation includes the name of the book followed by the chapter number.

    <div class="wrong">

    ``` html
    <p>“In the beginning God created the heaven and the earth” is the first verse of Genesis <span epub:type="z3998:roman">I</span>.</p>
    ```

    </div>

    <div class="corrected">

    ``` html
    <p>“In the beginning God created the heaven and the earth” is the first verse of Genesis 1.</p>
    ```

    </div>

3.  If a continuous range of verses is being cited, an en dash (`–` or U+2013) is placed between the verse numbers indicating the beginning and the end of the range.

    ``` html
    <p>Matthew 5:3–11.</p>
    ```

    Ranges may also span multiple chapters within the same book:

    ``` html
    <p>Matthew 5:1–7:29.</p>
    ```

4.  If a discontinuous group of verses in the same chapter is being cited, each distinct verse number is separated by a comma followed by a space.

    ``` html
    <p>Matthew 6:2, 16.</p>
    ```

5.  If there are multiple citations of the same book, each citation is separated by a semicolon followed by a space, and the name of the book is omitted after the first citation.

    ``` html
    <p>Matthew 5:3–11; 5:1–7:29; 6:2, 16</p>
    ```

## Non-Latin Scripts and Transliterations

1.  Greek script is set in italics. All other scripts are not set in italics unless specially required by the text.

### Greek

1.  Rough and smooth breathing marks are set using their precomposed character, if available; for example, `Ἁ`, `Ἀ`, `ἇ`, `ἄ`, and `Ἧ`.
    1.  If a precomposed rough breathing character is not available, `̔` (U+0314) is used when the mark must be combined with a character, and `ʽ` (U+02BD) is used in all other cases.
    2.  If a precompsed smooth breathing character is not available, ` ̓` (U+0313) is used when the mark must be combined with a character, and `ʼ` (U+02BC) is used in all other cases.

### Chinese

1.  Wade-Giles is the preferred method of transliterating Chinese script. ([See here for discussion.](https://github.com/standardebooks/laozi_tao-te-ching_james-legge/issues/2)) Transliteration to Wade-Giles from Legge is permitted, but not required.
2.  In Wade-Giles transliteration, rough breathing marks are set using `ʽ` (U+02BD).

## Tables

For ditto marks, see [8.7.5.4](#8.7.5.4).

1.  `<table>` elements that are used to display tabular numerical data, for example columns of sums, have CSS styling for tabular numbers: `font-variant-numeric: tabular-nums;`.

    <div class="corrected">

    ``` css
    table td:last-child{
        font-variant-numeric: tabular-nums;
        text-align: right;
    }
    ```

    ``` html
    <table>
        <tbody>
            <tr>
                <td>Amount 1</td>
                <td>100</td>
            </tr>
            <tr>
                <td>Amount 2</td>
                <td>300</td>
            </tr>
            <tr>
                <td>Total</td>
                <td>400</td>
            </tr>
        </tbody>
    </table>
    ```

    </div>
