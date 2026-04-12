# High Level Structural Patterns

Section should contain high-level structural patterns for common formatting situations.

## Sectioning

1.  The `<body>` element may only have direct children that are `<section>`, `<article>`, or `<nav>`.
2.  Major structural divisions of a larger work, like parts, volumes, books, chapters, or subchapters, are contained in a `<section>` element.
3.  Individual items in a larger collection (like a poem in a poetry collection) are contained in an `<article>` element.
    1.  Collections of very short work, like collections of poems, have all of their content in a single file, and `break-*` CSS is added to generate page breaks between items:

        ``` css
        article,
        section{
            break-after: page;
        }
        ```
4.  In `<section>` or `<article>` elements that have titles, the first child element is an `<h1>`–`<h6>` element, an `<hgroup>` element for grouping ordinals, titles, and subtitles, or a `<header>` element containing the section’s title.

### Recomposability

“Recomposability” is the concept of generating a single structurally-correct HTML5 file out of an epub file. All Standard Ebooks are recomposable.

1.  XHTML files that contain `<section>` or `<article>` elements that are semantic children of `<section>` or `<article>` elements in other files, have a `data-parent` attribute that contains the `id` of the parent sectioning element.

#### Examples

Consider a book that contains several top-level subdivisions: Books 1–4, with each book having 3 parts, and each part having 10 chapters. Below is an example of three files demonstrating the structure necessary to achieve recomposability:

Book 1 (`book-1.xhtml`):

``` html
<section id="book-1" epub:type="division">
    <h2>
        <span epub:type="label">Book</span>
        <span epub:type="ordinal z3998:roman">I</span>
    </h2>
</section>
```

Book 1, Part 2 (`part-1-2.xhtml`):

``` html
<section data-parent="book-1" id="part-1-2" epub:type="part">
    <h3>
        <span epub:type="label">Part</span>
        <span epub:type="ordinal z3998:roman">II</span>
    </h3>
</section>
```

Book 1, Part 2, Chapter 3 (`chapter-1-2-3.xhtml`):

``` html
<section data-parent="part-1-2" id="chapter-1-2-3" epub:type="chapter">
    <h4 epub:type="ordinal z3998:roman">III</h4>
    <p>...</p>
    <p>...</p>
</section>
```

## Headers

1.  `<h1>`–`<h6>` elements are used for headers of sections that are structural divisions of a document, i.e., divisions that appear in the table of contents. `<h1>`–`<h6>` elements *are not* used for headers of components that are not in the table of contents. For example, they are *not* used to mark up the title of a short poem in a chapter, where the poem itself is not a structural component of the larger ebook.

2.  A section containing an `<h1>`–`<h6>` appears in the table of contents.

3.  The book’s title on the title page is at the `<h1>` level. All other sections, including the half title page if any, begin at `<h2>`.

4.  Each `<h1>`–`<h6>` element uses the correct number for the section’s heading level in the overall book, *not* the section’s heading level in the individual file. For example, given an ebook with a file named `part-2.xhtml` containing:

    ``` html
    <section id="part-2" epub:type="part">
        <h2><span epub:type="label">Part</span> <span epub:type="ordinal z3998:roman">II</span></h2>
    </section>
    ```

    Consider this example for the file `chapter-2-3.xhtml`:

    <div class="wrong">

    ``` html
    <section id="part-2" epub:type="part">
        <section id="chapter-2-3" epub:type="chapter">
            <h2 epub:type="ordinal z3998:roman">III</h2>
            ...
        </section>
    </section>
    ```

    </div>

    <div class="corrected">

    ``` html
    <section id="part-2" epub:type="part">
        <section id="chapter-2-3" epub:type="chapter">
            <h3 epub:type="ordinal z3998:roman">III</h3>
            ...
        </section>
    </section>
    ```

    </div>

5.  Each `<h1>`–`<h6>` element has a direct parent `<section>`, `<article>`, `<header>`, or `<hgroup>` element.

6.  `<hgroup>` elements are used to group a `<h1>`–`<h6>` element together with subheading elements when a section’s title has multiple components, for example a header that contains an ordinal and a title, or a header that includes a title and a subtitle.

    1.  `<hgroup>` elements have one `<h1>`–`<h6>` child, followed by `<p>` children.
    2.  `<hgroup>` elements are only present if *more than one* title element must be grouped together, like both a title and a subtitle, or an ordinal and a title.

7.  Headers follow regular rules for italics, with the exception that headers that are entirely non-English-language are not italicized. Even though they are not italicized, they retain `xml:lang` semantics on the parent element.

    ``` html
    <hgroup>
        <h3 epub:type="ordinal z3998:roman">XI</h3>
        <p epub:type="title">The <i epub:type="se:name.vessel.ship">Nautilus</i></p>
    </hgroup>
    ```

    ``` html
    <hgroup>
        <h3 epub:type="ordinal z3998:roman">XI</h3>
        <p epub:type="title" xml:lang="la">Christus Nos Liberavit</p>
    </hgroup>
    ```

    ``` html
    <hgroup>
        <h3 epub:type="ordinal z3998:roman">XI</h3>
        <p epub:type="title">Miss Thorne’s <i xml:lang="fr">Fête Champêtre</i></p>
    </hgroup>
    ```

8.  Sections without any header content, including epigraphs or other non-prose material, have `margin-top: 20vh` applied to their sectioning container.

    ``` css
    section[epub|type~="preface"]{
        margin-top: 20vh;
    }
    ```

    ``` html
    <section epub:type="preface">
        <p>Being observations or memorials of the most remarkable occurrences...</p>
        <p>...</p>
    </section>
    ```

### Parts of a section title

Within section titles, we distinguish between labels, ordinals, titles, and subtitles.

1.  Labels are the part of a title that precedes the ordinal. Because they only appear next to ordinals, they are usually wrapped in `<span epub:type="label">` within their parent `<h1>`–`<h6>` element.

    ``` html
    <h2><span epub:type="label">Canto</span> <span epub:type="ordinal z3998:roman">III</span></h2>
    ```

2.  Ordinals are the number specifying the section’s numeric order in a sequence. They are usually wrapped in `<span epub:type="ordinal">` or `<span epub:type="ordinal z3998:roman">`, if the ordinal is a Roman numeral.

    ``` html
    <h2><span epub:type="label">Book</span> <span epub:type="ordinal z3998:roman">IV</span></h2>
    ```

    Ordinals may also appear without a label:

    ``` html
    <h2 epub:type="ordinal z3998:roman">IV</h2>
    ```

3.  Labels and ordinals are wrapped in an `<h1>`–`<h6>` element, but that wrapper element is not a semantic title.

4.  Titles are the main title of the section. Often sections may have labels and ordinals, but not titles; or sections may have a title, but no label or ordinal.

    ``` html
    <h2 epub:type="title">The New Villa</h2>
    ```

    ``` html
    <hgroup>
        <h2 epub:type="ordinal z3998:roman">IV</h2>
        <p epub:type="title">The Letter Signed “Bella”</p>
    </hgroup>
    ```

5.  Subtitles are supplementary titles in addition to the main title.

    ``` html
    <hgroup>
        <h2 epub:type="title">Between the Scenes</h2>
        <p epub:type="subtitle">Progress of the Story Through the Post</p>
    </hgroup>
    ```

### Header patterns

For sections without heading material, see [7.2.8](/manual/VERSION/7-high-level-structural-patterns#7.2.8).

1.  Sections with ordinals but without titles:

    ``` html
    <h2 epub:type="ordinal z3998:roman">XI</h2>
    ```

2.  Sections with titles but without ordinals:

    ``` html
    <h2 epub:type="title">A Daughter of Albion</h2>
    ```

3.  Sections with titles and ordinals:

    ``` html
    <hgroup>
        <h2 epub:type="ordinal z3998:roman">XI</h2>
        <p epub:type="title">Who Stole the Tarts?</p>
    </hgroup>
    ```

4.  Sections with titles and subtitles but no ordinals:

    ``` html
    <hgroup>
        <h2 epub:type="title">An Adventure</h2>
        <p epub:type="subtitle">(A Driver’s Story)</p>
    </hgroup>
    ```

5.  Sections with labels and ordinals:

    ``` html
    <h2>
        <span epub:type="label">Book</span>
        <span epub:type="ordinal z3998:roman">II</span>
    </h2>
    ```

6.  Sections with labels, ordinals, and titles:

    ``` html
    <hgroup>
        <h2>
            <span epub:type="label">Book</span>
            <span epub:type="ordinal z3998:roman">II</span>
        </h2>
        <p epub:type="title">The Man in the Street</p>
    </hgroup>
    ```

7.  Sections that have a non-unique title, but that are required to be identifed in the ToC with a unique title (e.g., multiple poems identified as “Sonnet” in the body matter, which require their ToC entry to contain the poem’s first line to differentiate them):

    ``` html
    <hgroup>
        <h2 epub:type="title">Sonnet</h2>
        <p hidden="hidden" epub:type="subtitle">Happy Is England!</p>
    </hgroup>
    ```

8.  Sections that require titles, but that are not in the table of contents:

    ``` css
    header{
        font-variant: small-caps;
        margin: 1em;
        text-align: center;
    }
    ```

    ``` html
    <header>
        <p>The Title of a Short Poem</p>
    </header>
    ```

9.  Half title pages without subtitles:

    ``` html
    <h2 epub:type="fulltitle">Eugene Onegin</h2>
    ```

10. Half title pages with subtitles:

    ``` html
    <hgroup epub:type="fulltitle">
        <h2 epub:type="title">His Last Bow</h2>
        <p epub:type="subtitle">Some Reminiscences of Sherlock Holmes</p>
    </hgroup>
    ```

11. Headers for sections in which the book’s main author shares a byline:

    ``` html
    <header>
        <h2 epub:type="title">Happy Ending</h2>
        <p epub:type="contributors">By Mack Reynolds and Frederic Brown</p>
    </header>
    ```

### Bridgeheads

Bridgeheads are sections in a chapter header that give an abstract or summary of the following chapter. They may be in prose or in a short list with clauses separated by em dashes.

1.  Bridgeheads have the following CSS and HTML structure:

    ``` css
    [epub|type~="bridgehead"]{
        display: inline-block;
        font-style: italic;
        max-width: 60%;
        text-align: justify;
        text-indent: 0;
    }

    [epub|type~="bridgehead"] i{
        font-style: normal;
    }

    [epub|type~="z3998:hymn"] [epub|type~="bridgehead"],
    [epub|type~="z3998:poem"] [epub|type~="bridgehead"],
    [epub|type~="z3998:song"] [epub|type~="bridgehead"],
    [epub|type~="z3998:verse"] [epub|type~="bridgehead"]{
        text-align: justify;
    }
    ```

    ``` html
    <header>
        <h2 epub:type="ordinal z3998:roman">I</h2>
        <p epub:type="bridgehead">Which treats of the character and pursuits of the famous gentleman Don Quixote of La Mancha.</p>
    </header>
    ```

    ``` html
    <header>
        <h2 epub:type="ordinal z3998:roman">X</h2>
        <p epub:type="bridgehead">Our first night⁠:ws:`wj`—Under canvas⁠:ws:`wj`—An appeal for help⁠:ws:`wj`—Contrariness of teakettles, how to overcome⁠:ws:`wj`—Supper⁠:ws:`wj`—How to feel virtuous⁠:ws:`wj`—Wanted! a comfortably-appointed, well-drained desert island, neighbourhood of South Pacific Ocean preferred⁠:ws:`wj`—Funny thing that happened to George’s father⁠:ws:`wj`—A restless night.</p>
    </header>
    ```

2.  Bridgeheads are typically set in italics. [Exceptions are allowed according to rules for italics](/manual/VERSION/8-typography#8.2.13).

3.  The last clause in a bridgehead ends in appropriate punctuation, like a period.

4.  Bridgeheads consisting of a series of clauses that summarize the following chapter have each clause separated by an em dash. Each clause is sentence-cased.

    ``` html
    <header>
        <h2 epub:type="ordinal z3998:roman">XI</h2>
        <p epub:type="bridgehead">How George, once upon a time, got up early in the morning⁠:ws:`wj`—George, Harris, and Montmorency do not like the look of the cold water⁠:ws:`wj`—Heroism and determination on the part of <abbr epub:type="z3998:given-name">J.</abbr>⁠:ws:`wj`—George and his shirt: story with a moral⁠:ws:`wj`—Harris as cook⁠:ws:`wj`—Historical retrospect, specially inserted for the use of schools.</p>
    </header>
    ```

## Dedications

Dedications are typically either a short phrase centered on the page, or a longer prose-form dedication similar in appearance and typesetting to regular prose.

Dedications are frequently styled uniquely by authors. Therefore there is freedom to style dedications to match the author’s unique style choices, for example by including small caps, different font sizes, alignments, etc.

1.  Short-type dedications are centered on the page for ereaders that support advanced CSS. For all other ereaders, such dedications are horizontally centered with a small top margin. The following CSS is used for such dedications:

    ``` css
    /* Centered dedications */
    section[epub|type~="dedication"]{
        text-align: center;
    }

    section[epub|type~="dedication"] > *{
        display: inline-block;
        margin: auto;
        margin-top: 3em;
        max-width: 80%;
    }

    @supports(display: flex){
        section[epub|type~="dedication"]{
            align-items: center;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            justify-content: center;
            min-height: calc(98vh - 3em);
            padding-top: 3em;
        }

        section[epub|type~="dedication"] > *{
            margin: 0;
        }
    }
    /* End centered dedications */
    ```

2.  Prose-type dedications are styled like regular chapters, including a top margin if there is no heading material.

## Epigraphs

1.  All epigraphs include this CSS:

    ``` css
    /* All epigraphs */
    [epub|type~="epigraph"]{
        font-style: italic;
        hyphens: none;
        -epub-hyphens: none;
    }

    [epub|type~="epigraph"] em,
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
    /* End all epigraphs */
    ```

2.  Epigraphs are typically set in italics. [Exceptions are allowed according to rules for italics](/manual/VERSION/8-typography#8.2.13).

3.  Epigraphs may sometimes contain quotes from plays and drama. Such quotations use the [standard play formatting](/manual/VERSION/7-high-level-structural-patterns#7.6) and this additional CSS to remove italics from personas:

    ``` css
    [epub|type~="epigraph"] [epub|type~="z3998:persona"]{
        font-style: normal;
    }
    ```

4.  Epigraphs may sometimes contain headings. Headings have italics removed with the following CSS:

    ``` css
    [epub|type~="epigraph"] h2{
        font-style: normal;
    }
    ```

### Epigraphs in section headers

1.  Epigraphs in section headers have the quote source in a `<cite>` element set in small caps, without a leading em dash and without a trailing period.

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
    [epub|type~="epigraph"] cite{
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

2.  In addition to the [CSS used for all epigraphs](/manual/VERSION/7-high-level-structural-patterns#7.4.1), this additional CSS is included for epigraphs in section headers:

    ``` css
    /* Epigraphs in section headers */
    article > header [epub|type~="epigraph"],
    section > header [epub|type~="epigraph"]{
        display: inline-block;
        margin: auto;
        max-width: 80%;
        text-align: initial;
    }

    article > header [epub|type~="epigraph"] + *,
    section > header [epub|type~="epigraph"] + *{
        margin-top: 3em;
    }

    @supports(display: table){
        article > header [epub|type~="epigraph"],
        section > header [epub|type~="epigraph"]{
            display: table;
        }
    }
    /* End epigraphs in section headers */
    ```

### Full-page epigraphs

1.  In full-page epigraphs, the epigraph is centered on the page for ereaders that support advanced CSS. For all other ereaders, the epigraph is horizontally centered with a small margin above it.

2.  Full-page epigraphs that contain multiple quotations are represented by multiple `<blockquote>` elements.

3.  In addition to the [CSS used for all epigraphs](/manual/VERSION/7-high-level-structural-patterns#7.4.1), this additional CSS is included for full-page epigraphs:

    ``` css
    /* Full-page epigraphs */
    section[epub|type~="epigraph"]{
        text-align: center;
    }

    section[epub|type~="epigraph"] > *{
        display: inline-block;
        margin: auto;
        margin-top: 3em;
        max-width: 80%;
        text-align: initial;
    }

    @supports(display: flex){
        section[epub|type~="epigraph"]{
            align-items: center;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            justify-content: center;
            min-height: calc(98vh - 3em);
            padding-top: 3em;
        }

        section[epub|type~="epigraph"] > *{
            margin: 0;
        }

        section[epub|type~="epigraph"] > * + *{
            margin-top: 3em;
        }
    }
    /* End full-page epigraphs */
    ```

4.  Example HTML:

    ``` html
    <body epub:type="frontmatter">
        <section id="epigraph" epub:type="epigraph">
            <blockquote>
                <p>Reorganisation, irrespectively of God or king, by the worship of Humanity, systematically adopted.</p>
                <p>Man’s only right is to do his duty.</p>
                <p>The Intellect should always be the servant of the Heart, and should never be its slave.</p>
            </blockquote>
            <blockquote>
                <p>“We tire of thinking and even of acting; we never tire of loving.”</p>
            </blockquote>
        </section>
    </body>
    ```

## Poetry, verse, and songs

Unfortunately there’s no great way to semantically format poetry in HTML. As such, unrelated elements are conscripted for use in poetry.

1.  A stanza is represented by a `<p>` element styled with this CSS:

    ``` css
    [epub|type~="z3998:poem"] p{
        text-align: initial;
        text-indent: 0;
    }

    [epub|type~="z3998:poem"] p + p{
        margin-top: 1em;
    }
    ```

2.  Each stanza contains `<span>` elements, each one representing a line in the stanza, styled with this CSS:

    ``` css
    [epub|type~="z3998:poem"] p > span{
        display: block;
        padding-left: 1em;
        text-indent: -1em;
    }
    ```

3.  Each `<span>` line is followed by a `<br/>` element, except for the last line in a stanza, styled with this CSS:

    ``` css
    [epub|type~="z3998:poem"] p > span + br{
        display: none;
    }
    ```

4.  Indented `<span>` lines have the `i1` class. `Do not` use `nbsp` for indentation. Indenting to different levels is done by incrementing the class to `i2`, `i3`, and so on, and including the appropriate CSS.

    ``` css
    p span.i1{
        padding-left: 2em;
        text-indent: -1em;
    }

    p span.i2{
        padding-left: 3em;
        text-indent: -1em;
    }
    ```

5.  Poems, songs, and verse that are a shorter part of a longer work, like a novel, are wrapped in a `<blockquote>` element.

    ``` html
    <blockquote epub:type="z3998:poem">
        <p>
            <span>...</span>
            <br/>
            <span>...</span>
        </p>
    </blockquote>
    ```

6.  The parent element of poetry, verse, or song, has the semantic inflection of `z3998:poem`, `z3998:verse`, `z3998:song`, or `z3998:hymn`.

    1.  The z3998 vocabulary does not explicitly define their terms for each of the above; these are the standards for our productions.
        1.  `z3998:poem` is used when an entire poem is quoted, even a short one.
        2.  `z3998:verse` is used for poem or verse fragments.
        3.  `z3998:song` is used when song lyrics are quoted, in whole or in part.
        4.  `z3998:hymn` is used when the song lyrics are for a hymn, either well known (e.g. “Amazing Grace”) or specifically labeled as such in the source text. When in doubt, use `z3998:song`.

7.  If a poem is quoted and has one or more lines removed, the removed lines are represented with a vertical ellipsis (`⋮` or U+22EE) in a `<span class="elision">` element styled with this CSS:

    ``` css
    span.elision{
        margin: .5em;
        margin-left: 3em;
    }

    /* If eliding within an epigraph, include this additional style: */
    [epub|type~="epigraph"] span.elision{
        font-style: normal;
    }
    ```

    ``` html
    <blockquote epub:type="z3998:verse">
        <p>
            <span>O Lady! we receive but what we give,</span>
            <br/>
            <span>And in our life alone does nature live:</span>
            <br/>
            <span>Ours is her wedding garments, ours her shroud!</span>
            <br/>
            <span class="elision">⋮</span>
            <br/>
            <span class="i1">Ah! from the soul itself must issue forth</span>
            <br/>
            <span>A light, a glory, a fair luminous cloud,</span>
        </p>
    </blockquote>
    ```

8.  If a poem contains an `<hgroup>` element which in turn contains a `<p>` element, then the following CSS is included to correct the desired centered alignment of headers:

    ``` css
    [epub|type~="z3998:hymn"] hgroup p,
    [epub|type~="z3998:poem"] hgroup p,
    [epub|type~="z3998:song"] hgroup p,
    [epub|type~="z3998:verse"] hgroup p{
        text-align: center;
    }
    ```

### Examples

Note that below we include CSS for the `.i2` class, even though it’s not used in the example. It’s included to demonstrate how to adjust the CSS for indentation levels after the first.

``` css
[epub|type~="z3998:poem"] p{
    text-align: initial;
    text-indent: 0;
}

[epub|type~="z3998:poem"] p > span{
    display: block;
    padding-left: 1em;
    text-indent: -1em;
}

[epub|type~="z3998:poem"] p > span + br{
    display: none;
}

[epub|type~="z3998:poem"] p + p{
    margin-top: 1em;
}

p span.i1{
    padding-left: 2em;
    text-indent: -1em;
}

p span.i2{
    padding-left: 3em;
    text-indent: -1em;
}
```

``` html
<blockquote epub:type="z3998:poem">
    <p>
        <span>“How doth the little crocodile</span>
        <br/>
        <span class="i1">Improve his shining tail,</span>
        <br/>
        <span>And pour the waters of the Nile</span>
        <br/>
        <span class="i1">On every golden scale!</span>
    </p>
    <p>
        <span>“How cheerfully he seems to grin,</span>
        <br/>
        <span class="i1">How neatly spread his claws,</span>
        <br/>
        <span>And welcome little fishes in</span>
        <br/>
        <span class="i1"><em>With gently smiling jaws!</em>”</span>
    </p>
</blockquote>
```

## Plays and drama

1.  Dialog in plays is structured using `<table>` elements.

2.  Each `<tr>` is either a block of dialog or a standalone stage direction.

3.  Personas are typically characters that have speaking roles. They are set in small caps and never in italics, even if the surrounding text is in italics.

4.  Works that are plays or that contain sections of dramatic dialog have this core CSS:

    ``` css
    [epub|type~="z3998:drama"] table,
    table[epub|type~="z3998:drama"]{
        border-collapse: collapse;
        margin: 1em auto;
        width: 100%;
    }

    [epub|type~="z3998:drama"] tr:first-child td{
        padding-top: 0;
    }

    [epub|type~="z3998:drama"] tr:last-child td{
        padding-bottom: 0;
    }

    [epub|type~="z3998:drama"] td{
        padding: .5em;
        vertical-align: top;
    }

    [epub|type~="z3998:drama"] td:last-child{
        padding-right: 0;
    }

    [epub|type~="z3998:drama"] td:first-child{
        padding-left: 0;
    }

    [epub|type~="z3998:drama"] td[epub|type~="z3998:persona"]{
        hyphens: none;
        -epub-hyphens: none;
        text-align: right;
        width: 20%;
    }

    [epub|type~="z3998:stage-direction"]{
        font-style: italic;
    }

    [epub|type~="z3998:stage-direction"] [epub|type~="z3998:persona"],
    em [epub|type~="z3998:persona"],
    i [epub|type~="z3998:persona"]{
        font-style: normal;
    }

    [epub|type~="z3998:stage-direction"]::before{
        content: "(";
        font-style: normal;
    }

    [epub|type~="z3998:stage-direction"]::after{
        content: ")";
        font-style: normal;
    }

    [epub|type~="z3998:persona"]{
        font-variant: all-small-caps;
    }

    section[epub|type~="z3998:scene"] > p{
        margin: 1em auto;
        width: 75%;
    }

    @media(max-width: 400px){
        [epub|type~="z3998:drama"] td,
        [epub|type~="z3998:drama"] td[epub|type~="z3998:persona"],
        [epub|type~="z3998:drama"] td:last-child{
            display: block;
            padding: 0;
            text-align: initial;
            width: 100%;
        }

        [epub|type~="z3998:drama"] td[epub|type~="z3998:persona"]{
            break-after: avoid;
            margin-top: 1.5em;
        }

        /* `together` rows get a pseudo-stage-direction. */
        [epub|type~="z3998:drama"] tr.together td[epub|type~="z3998:persona"]::after{
            content: " (Together.)";
            font-style: italic;
            font-variant: normal;
        }

        [epub|type~="z3998:drama"] .together td:last-child{
            border: none;
            padding: 0;
        }

        /* Rows that are only stage direction get a top margin. */
        [epub|type~="z3998:drama"] td:first-child:not([epub|type]) + td{
            margin-top: 1.5em;
        }
    }
    ```

### Dialog rows

1.  The first child of a row of dialog is a `<td>` element with the semantic inflection of `z3998:persona` containing the name of the speaker, without ending punctuation.

2.  The second child of a row of dialog is a `<td>` element containing the actual dialog. Elements that contain only one line of dialog do not have a block-level child (like `<p>`).

    ``` html
    <tr>
        <td epub:type="z3998:persona">Algernon</td>
        <td>Did you hear what I was playing, Lane?</td>
    </tr>
    <tr>
        <td epub:type="z3998:persona">Lane</td>
        <td>I didn’t think it polite to listen, sir.</td>
    </tr>
    ```

    1.  Dialog rows that have dialog broken over several lines, i.e. in dialog in verse form, have [semantics, structure, and CSS for verse.](/manual/VERSION/7-high-level-structural-patterns#7.5) The `<td>` element has the `z3998:verse` semantic.

        ``` html
        <tr>
            <td epub:type="z3998:persona">Queen Isabel</td>
            <td epub:type="z3998:verse">
                <p>
                    <span>Our gracious brother, I will go with them.</span>
                    <br/>
                    <span>Haply a woman’s voice may do some good,</span>
                    <br/>
                    <span>When articles too nicely urg’d be stood on.</span>
                </p>
            </td>
        </tr>
        ```

3.  When several personas speak at once, or a group of personas (“The Actors”) speaks at once, the containing `<tr>` element has the `together` class, and the first `<td>` child has a `rowspan` attribute corresponding to the number of lines spoken together.

    ``` css
    tr.together{
        break-inside: avoid;
    }

    tr.together td{
        padding: 0 .5em 0 0;
        vertical-align: middle;
    }

    tr.together td:only-child,
    tr.together td + td{
        border-left: 1px solid;
    }

    .together + .together td[rowspan],
    .together + .together td[rowspan] + td{
        padding-top: .5em;
    }

    [epub|type~="z3998:drama"] .together td:last-child{
        padding-left: .5em;
    }
    ```

    ``` html
    <tr class="together">
        <td rowspan="3" epub:type="z3998:persona">The Actors</td>
        <td>Oh, what d’you think of that?</td>
    </tr>
    <tr class="together">
        <td>Only the mantle?</td>
    </tr>
    <tr class="together">
        <td>He must be mad.</td>
    </tr>
    <tr class="together">
        <td rowspan="2" epub:type="z3998:persona">Some Actresses</td>
        <td>But why?</td>
    </tr>
    <tr class="together">
        <td>Mantles as well?</td>
    </tr>
    ```

### Stage direction

1.  Stage direction is wrapped in an `<i epub:type="z3998:stage-direction">` element.

    1.  Stage directions that are included from a different edition additionally have the `class="editorial"` attribute, with this additional CSS:

        ``` css
        [epub|type~="z3998:stage-direction"].editorial::before{
            content: "[";
        }

        [epub|type~="z3998:stage-direction"].editorial::after{
            content: "]";
        }
        ```

2.  Personas mentioned in stage direction are wrapped in a `<b epub:type="z3998:persona">` element.

    1.  Possessive `’s` or `’` are included within the associated `<b>` element.

        ``` html
        <i epub:type="z3998:stage-direction">Lowering his voice for <b epub:type="z3998:persona">Maury’s</b> ear alone.</i>
        ```

3.  Stage direction in shorthand (for example, `Large French window, R. 3 E.`) is wrapped in an `<abbr epub:type="z3998:stage-direction">` element, with this additional CSS:

    ``` css
    abbr[epub|type~="z3998:stage-direction"]{
        font-style: normal;
        font-variant: all-small-caps;
    }

    abbr[epub|type~="z3998:stage-direction"]::before,
    abbr[epub|type~="z3998:stage-direction"]::after{
        content: "";
    }
    ```

#### Stage direction rows

1.  The first child of a row containing only stage direction is an empty `<td>` element.
2.  The second child of a row containing only stage direction is a `<td>` element containing the stage direction.

##### Examples

``` html
<tr>
    <td/>
    <td>
        <i epub:type="z3998:stage-direction">Large French window, <abbr class="eoc" epub:type="z3998:stage-direction">R. 3 E.</abbr> <b epub:type="z3998:persona">Lane</b> is arranging afternoon tea on the table, and after the music has ceased, <b epub:type="z3998:persona">Algernon</b> enters.</i>
    </td>
</tr>
```

#### Inline stage direction

1.  Inline stage direction that is not an interjection within a containing clause begins with a capital letter and ends in punctuation, usually a period.
2.  Inline stage direction that *is* an interjection within a containing clause does not begin with a capital letter, and ending punctuation is optional and usually omitted.

##### Examples

``` html
<tr>
    <td epub:type="z3998:persona">Jackson</td>
    <td>I see you don’t know much! A costume <i epub:type="z3998:stage-direction">putting his finger on his forehead</i> is a thing which calls for deep thought. Have you seen my Sun here? <i epub:type="z3998:stage-direction">Strikes his posterior.</i> I looked for it two years.</td>
</tr>
```

### Works that are complete plays

1.  The top-level element (usually `<body>`) has the `z3998:drama` semantic inflection.

2.  Acts are `<section>` elements containing at least one `<table>` for dialog, and optionally containing an act title and other top-level stage direction.

3.  Introductory or high-level stage direction is presented using `<p>` elements outside of the dialog table.

    ``` html
    <body epub:type="bodymatter z3998:fiction z3998:drama">
        <section id="act-1" epub:type="chapter z3998:scene">
            <h2><span epub:type="label">Act</span> <span epub:type="ordinal z3998:roman">I</span></h2>
            <p>Scene: Morning-room in <b epub:type="z3998:persona">Algernon’s</b> flat in Half-Moon Street. The room is luxuriously and artistically furnished. The sound of a piano is heard in the adjoining room.</p>
            <table>
                ...
            </table>
            <p epub:type="z3998:stage-direction">Act Drop</p>
        </section>
    </body>
    ```

4.  Dramatis personae are presented as a `<ul>` element listing the characters.

    ``` css
    [epub|type~="z3998:dramatis-personae"]{
        text-align: center;
    }

    [epub|type~="z3998:dramatis-personae"] p{
        text-indent: 0;
    }

    [epub|type~="z3998:dramatis-personae"] ul{
        list-style: none;
        margin: 0;
        padding: 0;
    }

    [epub|type~="z3998:dramatis-personae"] ul li{
        font-style: italic;
        margin: 1em;
    }

    [epub|type~="z3998:dramatis-personae"] ul + p{
        margin-top: 2em;
    }
    ```

    ``` html
    <section id="dramatis-personae" epub:type="z3998:dramatis-personae">
        <h2 epub:type="title">Dramatis Personae</h2>
        <ul>
            <li>
                <p>King Henry <span epub:type="z3998:roman">V</span></p>
            </li>
            <li>
                <p>Duke of Clarence, brother to the King</p>
            </li>
            ...
        </ul>
    </section>
    ```

## Letters

Letters require particular attention to styling and semantic inflection. Letters may not exactly match the formatting in the source scans, but they are in visual sympathy with the source.

1.  Letters are wrapped in a `<blockquote>` element with the appropriate semantic inflection, usually `z3998:letter`.
2.  Letters that are telegrams have `class="telegram"` and are set with `.telegram{ font-variant: all-small-caps; }`.

### Letter headers

1.  Parts of a letter prior to the body of the letter, for example the location where it is written, the date, and the salutation, are wrapped in a `<header>` element.

    1.  If the letter is within a `<blockquote>`, any `<header>` and `<footer>` elements have `role="presentation"`.

2.  If there is only a salutation and no other header content, the `<header>` element is omitted.

3.  The location and date of a letter have the semantic inflection of `se:letter.dateline`. Dates are in a `<time>` element with a computer-readable date.

    ``` html
    <header role="presentation">
        <p epub:type="se:letter.dateline">Blarney Castle, <time datetime="1863-10-11">11th of October, 1863</time></p>
    </header>
    ```

4.  The salutation (for example, “Dear Sir” or “My dearest Jane”) has the semantic inflection of `z3998:salutation`.

5.  Salutations that are on a separate line are set in small caps.

6.  Salutations that are contained within the first, larger line of the letter are wrapped in a `<span epub:type="z3998:salutation">` element (or a `<b epub:type="z3998:salutation">` element if small-caps are desired).

    ``` html
    <p><b epub:type="z3998:salutation">Dear Mother</b>, I was so happy to hear from you.</p>
    ```

7.  The first line of a letter after the salutation is not indented.

8.  The name of the recipient of the letter, when set out other than within a salutation (for example a letter headed “To: John Smith Esquire”), is given the semantic inflection of `z3998:recipient`. Sometimes this may occur at the end of a letter, particularly for more formal communications, in which case it is placed within a `<footer>` element.

### Letter footers

1.  Parts of a letter after the body of the letter, for example the signature or postscript, are wrapped in a `<footer>` element.

2.  The `<footer>` element has the following CSS:

    ``` css
    footer{
        margin-top: 1em;
        text-align: right;
    }
    ```

3.  The valediction (for example, “Yours Truly” or “With best regards”) has the semantic inflection of `z3998:valediction`.

4.  The sender’s name has semantic inflection of `z3998:sender`. If the name appears to be a signature to the letter, it has the `z3998:signature` semantic inflection and corresponding CSS.

    ``` css
    [epub|type~="z3998:signature"]{
        font-variant: small-caps;
    }
    ```

    ``` html
    <footer role="presentation">
        <p epub:type="z3998:sender z3998:signature"><abbr epub:type="z3998:given-name">R. A.</abbr> Johnson</p>
    </footer>
    ```

    ``` html
    <footer role="presentation">
        <p epub:type="z3998:sender"><span epub:type="z3998:signature">John Doe</span>, President</p>
    </footer>
    ```

5.  When the valediction and signature are a single clause, they are contained within a single `<p>`, separated by a `<br/>`.

    <div class="wrong">

    ``` html
    <footer role="presentation">
        <p epub:type="z3998:valediction">Very sincerely yours,</p>
        <p epub:type="z3998:sender z3998:signature">Sherlock Holmes</p>
    </footer>
    ```

    </div>

    <div class="corrected">

    ``` html
    <footer role="presentation">
        <p><span epub:type="z3998:valediction">Very sincerely yours,</span><br/>
        <b epub:type="z3998:sender z3998:signature">Sherlock Holmes</b></p>
    </footer>
    ```

    </div>

6.  Postscripts have the semantic inflection of `z3998:postscript` and the following CSS:

    ``` css
    [epub|type~="z3998:postscript"]{
        margin-top: 1em;
        text-align: initial;
        text-indent: 0;
    }
    ```

    1.  Postscripts that contain multiple paragraphs are grouped by having their contents wrapped in `<div epub:type="z3998:postscript">`.

### Examples

``` css
footer{
    margin-top: 1em;
    text-align: right;
}

[epub|type~="z3998:salutation"] + p{
    text-indent: 0;
}

p[epub|type~="z3998:salutation"]{
    font-variant: small-caps;
}

[epub|type~="z3998:postscript"]{
    margin-top: 1em;
    text-align: initial;
    text-indent: 0;
}
```

``` html
<blockquote epub:type="z3998:letter">
    <p epub:type="z3998:salutation">Dearest Auntie,</p>
    <p>Please may we have some things for a picnic? Gerald will bring them. I would come myself, but I am a little tired. I think I have been growing rather fast.</p>
    <footer role="presentation">
        <p><span epub:type="z3998:valediction">Your loving niece,</span><br/>
        <b epub:type="z3998:sender z3998:signature">Mabel</b></p>
        <p epub:type="z3998:postscript"><abbr epub:type="z3998:initialism">P.S.</abbr>:ws:`wj`—Lots, please, because some of us are very hungry.</p>
    </footer>
</blockquote>
```

``` css
[epub|type~="z3998:letter"] header{
    text-align: right;
}

footer{
    margin-top: 1em;
    text-align: right;
}

[epub|type~="z3998:letter"] header + p{
    text-indent: 0;
}
```

``` html
<blockquote epub:type="z3998:letter">
    <header role="presentation">
        <p epub:type="se:letter.dateline">Gracechurch-street, <time datetime="08-02">August 2</time>.</p>
    </header>
    <p><b epub:type="z3998:salutation">My dear Brother</b>, At last I am able to send you some tidings of my niece, and such as, upon the whole, I hope will give you satisfaction. Soon after you left me on Saturday, I was fortunate enough to find out in what part of London they were. The particulars, I reserve till we meet. It is enough to know they are discovered, I have seen them both⁠:ws:`wj`—</p>
    <p>I shall write again as soon as anything more is determined on.</p>
    <footer role="presentation">
        <p><span epub:type="z3998:valediction">Yours, <abbr>etc.</abbr></span><br/>
        <b epub:type="z3998:sender z3998:signature">Edward Gardner</b></p>
    </footer>
</blockquote>
```

## Images

1.  Each `<figure>` element has a unique `id` attribute.
    1.  That attribute's name is `illustration-` followed by `-N`, where `N` is the sequence number of the element starting at `1`.
2.  `<img>` elements have an `alt` attribute that uses prose to describe the image in detail; this is what screen reading software will read aloud.
    1.  The `alt` attribute describes the visual image itself in words, which is not the same as writing a caption or describing its place in the book.

        <div class="wrong">

        ``` html
        <img alt="The illustration for chapter 10" src="..." />
        ```

        </div>

        <div class="wrong">

        ``` html
        <img alt="Pierre’s fruit-filled dinner" src="..." />
        ```

        </div>

        <div class="corrected">

        ``` html
        <img alt="An apple and a pear are arranged inside a bowl, which is resting on a table." src="..." />
        ```

        </div>

        1.  The `alt` attribute does not contain no-break spaces or word joiners.

    2.  The `alt` attribute is one or more complete sentences ended with periods or other appropriate punctuation. It may be a sentence fragment if the image has no clear visual “protagonist” (for example an image of a musical score, or an image of alien writing that is inline with the text).

    3.  The `alt` attribute always has ending punctuation, unless the image is inline with running text (for example, like a musical notation symbol used in a prose context). In that case, the `alt` attribute is written to make sense when read in place with the running prose, and may be a sentence fragment without punctuation.

        <div class="corrected">

        ``` html
        <p>The notation that I have adopted is, for the enharmonic diesis, <img alt="half sharp" src="../images/illustration-4.svg" epub:type="z3998:illustration se:image.color-depth.black-on-transparent"/> quarter tone or half sharp.</p>
        ```

        </div>

    4.  The `alt` attribute is not necessarily the same as text in the image’s sibling `<figcaption>` element, if one is present.
3.  `<img>` elements have semantic inflection denoting the type of image. Common values are `z3998:illustration` or `z3998:photograph`.
4.  `<img>` element whose image is black-on-white line art (i.e. exactly two colors, **not** grayscale!) are SVG files with a transparent background. They have the `se:image.color-depth.black-on-transparent` semantic inflection.
    1.  If such an image is drawn in a “realistic” style (i.e., like a Gustave Doré or John Tenniel woodcut, and not like a flat map in an Agatha Christie murder mystery), it has the additional semantic of `se:image.style.realistic`.
5.  `<img>` elements that are meant to be aligned on the block level or displayed as full-page images are contained in a parent `<figure>` element, with an optional `<figcaption>` sibling.
    1.  An optional `<figcaption>` element containing a concise context-dependent caption may follow the `<img>` element within a `<figure>` element. This caption depends on the surrounding context, and is not necessarily (or even ideally) identical to the `<img>` element’s `alt` attribute.

    2.  All `<figure>` elements have this CSS:

        ``` css
        figure{
            break-inside: avoid;
            margin: 1em 2.5em;
        }

        figure img{
            display: block;
            margin: auto;
            max-height: 100vh;
            max-width: 100%;
        }

        figcaption{
            font-size: smaller;
            font-style: italic;
            margin: 1em;
            text-align: center;
        }

        figcaption p + p{
            text-indent: 0;
        }
        ```

    3.  `<figure>` elements that are meant to be displayed as full-page images have the `full-page` class and this additional CSS:

        ``` css
        figure.full-page{
            break-after: page;
            break-before: page;
        }
        ```

### Examples

``` css
figure{
    break-inside: avoid;
    margin: 1em 2.5em;
}

figure img{
    display: block;
    margin: auto;
    max-height: 100vh;
    max-width: 100%;
}

figcaption{
    font-size: smaller;
    font-style: italic;
    margin: 1em;
    text-align: center;
}

figcaption p + p{
    text-indent: 0;
}

/* If the image is meant to be on its own page, also include this selector... */
figure.full-page{
    break-after: page;
    break-before: page;
}
```

``` html
<p>...</p>
<figure id="illustration-10">
    <img alt="An apple and a pear are arranged inside a bowl, which is resting on a table." src="../images/illustration-10.jpg" epub:type="z3998:photograph"/>
    <figcaption>The Monk’s Repast</figcaption>
</figure>
```

``` html
<p>...</p>
<figure class="full-page" id="illustration-11">
    <img alt="A massive whale breaches the water, with a sailor floating in the water directly within the whale’s mouth." src="../images/illustration-11.jpg" epub:type="z3998:illustration"/>
    <figcaption>The Whale eats Sailor Jim.</figcaption>
</figure>
```

``` html
<p>He saw strange alien text that looked like this: <img alt="A line of alien hieroglyphs." src="../images/illustration-1.svg" epub:type="z3998:illustration se:image.color-depth.black-on-transparent" />. There was nothing else amongst the ruins.</p>
```

## List of Illustrations (the LoI)

If an ebook has any illustrations that a reader may wish to return to while reading (even just one!), then the ebook includes an `loi.xhtml` file at the end of the ebook. This file lists the illustrations in the ebook, along with a short caption or description.

1.  The LoI is an XHTML file named `./src/epub/text/loi.xhtml`.

2.  The LoI file has the `backmatter` semantic inflection.

3.  The LoI only contains links to images that a reader may wish to return to during reading.

    Examples of illustrations that a reader may wish to return to: illustrations of events in the book, like full-page drawings; illustrations essential to the plot, like diagrams of a murder scene; maps; components of the text, like photographs in a documentary narrative.

    Examples of illustrations that might *not* belong in an LoI: drawings used to represent a person’s signature, like an X mark; inline drawings representing text in made-up languages; drawings used as layout elements to illustrate forms, tables, or diagrams; illustrative musical scores; decorative end-of-chapter flourishes.

4.  The LoI file contains a single `<nav id="loi" epub:type="loi">` element, which in turn contains an `<h2 epub:type="title">List of Illustrations</h2>` element, followed by an `<ol>` element, which in turn contains list items representing the images.

5.  If an image listed in the LoI has a `<figcaption>` element, then that caption is used in the anchor text for that LoI entry. If not, the image’s `alt` attribute is used. If the `<figcaption>` element is too long for a concise LoI entry, the `alt` attribute is used instead.

6.  Links to the images go directly to the image’s corresponding `id` hashes, not just the top of the containing file.

### Examples

``` html
<?xml version="1.0" encoding="utf-8"?>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" epub:prefix="z3998: http://www.daisy.org/z3998/2012/vocab/structure/, se: https://standardebooks.org/vocab/1.0" xml:lang="en-GB">
    <head>
        <title>List of Illustrations</title>
        <link href="../css/core.css" rel="stylesheet" type="text/css"/>
        <link href="../css/local.css" rel="stylesheet" type="text/css"/>
    </head>
    <body epub:type="backmatter">
        <nav id="loi" epub:type="loi">
            <h2 epub:type="title">List of Illustrations</h2>
            <ol>
                <li>
                    <p>
                        <a href="preface.xhtml#illustration-1">The Edge of the World</a>
                    </p>
                </li>
                ...
            </ol>
        </nav>
    </body>
</html>
```

## Endnotes

1.  Ebooks do not have footnotes, only endnotes. Footnotes are instead converted to endnotes.

2.  `Ibid.` is a Latinism commonly used in endnotes to indicate that the source for a quotation or reference is the same as the last-mentioned source.

    When the last-mentioned source is in the previous endnote, `Ibid.` is replaced by the full reference; otherwise `Ibid.` is left as-is. Since ebooks use popup endnotes, `Ibid.` becomes meaningless without context.

### Noterefs

The noteref is the superscripted number in the body text that links to the endnote at the end of the book.

1.  Endnotes are referenced in the text by an `<a>` element with the semantic inflection `noteref`.
    1.  Noterefs point directly to the corresponding endnote `<li>` element in the endnotes file.
    2.  Noterefs have an `id` attribute like `noteref-n`, where `n` is identical to the endnote number.
    3.  The text of the noteref is the endnote number.
2.  If located at the end of a sentence, noterefs are placed after ending punctuation.
3.  If the endnote references an entire sentence in quotation marks, or the last word in a sentence in quotation marks, then the noteref is placed outside the quotation marks.

### The endnotes file

1.  Endnotes are in an XHTML file named `./src/epub/text/endnotes.xhtml`.
2.  The endnotes file has the `backmatter` semantic inflection.
3.  The endnotes file contains a single `<section id="endnotes" epub:type="endnotes">` element, which in turn contains an `<h2 epub:type="title">Endnotes</h2>` element, followed by an `<ol>` element containing list items representing the endnotes.
4.  Each endnote’s `id` attribute is in sequential ascending order.

### Individual endnotes

1.  An endnote is an `<li id="note-n" epub:type="endnote">` element containing one or more block-level text elements and one backlink element.
2.  Each endnote contains a backlink, which has the semantic inflection `backlink`, contains the text `↩`, and has the `href` attribute pointing to the corresponding noteref hash.
    1.  In endnotes where the last block-level element is a `<p>` element, the backlink goes at the end of the `<p>` element, preceded by exactly one space.
    2.  In endnotes where the last block-level element is verse, quotation, or otherwise not plain prose text, the backlink goes in its own `<p>` element following the last block-level element in the endnote.
3.  Endnotes with ending citations have those citations wrapped in a `<cite>` element, including any em dashes. A space follows the `<cite>` element, before the backlink.

### Examples

``` html
<p>... a continent that was not rent asunder by volcanic forces as was that legendary one of Atlantis in the Eastern Ocean.<a href="endnotes.xhtml#note-1" id="noteref-1" epub:type="noteref">1</a> My work in Java, in Papua, ...</p>
```

``` html
<?xml version="1.0" encoding="utf-8"?>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" epub:prefix="z3998: http://www.daisy.org/z3998/2012/vocab/structure/, se: https://standardebooks.org/vocab/1.0" xml:lang="en-GB">
    <head>
        <title>Endnotes</title>
        <link href="../css/core.css" rel="stylesheet" type="text/css"/>
        <link href="../css/local.css" rel="stylesheet" type="text/css"/>
    </head>
    <body epub:type="backmatter">
        <section id="endnotes" epub:type="endnotes">
            <h2 epub:type="title">Endnotes</h2>
            <ol>
                <li id="note-1" epub:type="endnote">
                    <p>For more detailed observations on these points refer to <abbr epub:type="z3998:given-name">G.</abbr> Volkens, “Uber die Karolinen Insel Yap.” <cite>—<abbr class="eoc" epub:type="z3998:personal-name">W. T. G.</abbr></cite> <a href="chapter-2.xhtml#noteref-1" epub:type="backlink">↩</a></p>
                </li>
                <li id="note-2" epub:type="endnote">
                    <blockquote epub:type="z3998:verse">
                        <p>
                            <span>“Who never ceases still to strive,</span>
                            <br/>
                            <span>’Tis him we can deliver.”</span>
                        </p>
                    </blockquote>
                    <p>
                        <a href="chapter-4.xhtml#noteref-2" epub:type="backlink">↩</a>
                    </p>
                </li>
            </ol>
        </section>
    </body>
</html>
```

## Glossaries

Glossaries may be included if there are a large number of domain-specific terms that are unlikely to be in a common dictionary, or which have unique meanings to the work.

Glossaries follow the [EPUB Dictionaries and Glossaries 1.0 spec](http://idpf.org/epub/dict/epub-dict.html#sec-2.5.3).

### The glossary search key map file

When including a glossary, a search key map file is required according to the [EPUB Dictionaries and Glossaries 1.0 spec](http://idpf.org/epub/dict/epub-dict.html#sec-2.5.3).

1.  The search key map file is named `./src/epub/glossary-search-key-map.xml`.
2.  The search key map file contains `<value>` elements describing all stemmed variations of the parent search term that occur in the ebook. Variations that don't occur in the ebook are excluded.
3.  If a `<match>` element only has one `<value>` element, the `<value>` element is removed in favor of `<match value="...">`.

### The glossary file

1.  Glossaries are in an XHTML file named `./src/epub/text/glossary.xhtml`.

2.  The glossary file has the `backmatter` semantic inflection.

3.  The glossary file contains a single `<section id="glossary" epub:type="glossary">` element, which may contain a title, followed by a `<dl>` element containing the glossary entries. While the EPUB glossaries spec suggests the `glossary` `epub:type` attribute be placed on the `<dl>` element, in a Standard Ebook it is placed on the `<dl>` element’s parent `<section>` element.

4.  All glossaries include the following CSS:

    ``` css
    dl{
        margin: 1em 0;
    }

    dd{
        margin-left: 40px;
    }

    dd + dt{
        margin-top: 1em;
    }
    ```

### Glossary entries

1.  The `<dl>` element contains sets of `<dt>` and `<dd>` elements.

2.  The `<dt>` element has `epub:type="glossterm"`.

3.  The `<dt>` element contains a single `<dfn>` element, which in turn contains the term to be defined.

4.  The `<dd>` element has `epub:type="glossdef"`.

5.  A `<dd>` element appears after one or more `<dt>` elements, and contains the definition for the preceding `<dt>` element(s). It must contain at least one block-level child, usually `<p>`.

    ``` html
    <dt epub:type="glossterm">
        <dfn>Coccus</dfn>
    </dt>
    <dd epub:type="glossdef">
        <p>The genus of Insects including the Cochineal. In these the male is a minute, winged fly, and the female generally a motionless, berrylike mass.</p>
    </dd>
    ```

6.  `<dt>` may appear more than once for a single glossary entry, if different variations of a term have the same definition.

    ``` html
    <dt epub:type="glossterm">
        <dfn>Compositae</dfn>
    </dt>
    <dt epub:type="glossterm">
        <dfn>Compositous Plants</dfn>
    </dt>
    <dd epub:type="glossdef">
        <p>Plants in which the inflorescence consists of numerous small flowers (florets) brought together into a dense head, the base of which is enclosed by a common envelope. (Examples, the Daisy, Dandelion, <abbr class="eoc">etc.</abbr>)</p>
    </dd>
    ```
