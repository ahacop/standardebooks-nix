# Standard Ebooks Section Patterns

All Standard Ebooks contain a standardized set of sections that are included in each ebook, and which are usually generated from template files. These sections include sections like the titlepage, imprint, and Uncopyright.

## The title string

The title string is a sentence listing the title of the ebook, its author, and any other contributors. It is used in various Standard Ebooks template files.

1.  The title string is formed with the following algorithm.
    - Start with an empty string.
    - Append the title of the work, without any subtitles.
    - Append `, by`, then the author. If there are two authors, separate them with `and`. If there are three or more authors, each one is separated by `,`, and the final one is preceded by `, and`.
    - If there is a translator, append `. Translated by`, then the translator name. Multiple translators are handled in the same manner as multiple authors.
    - If there is an illustrator, append `. Illustrated by`, then the illustrator name. Multiple illustrators are handled in the same manner as multiple authors.
2.  While the title string may contain periods, it never ends in a period.

## The table of contents

The table of contents (the ToC) is not viewable as a page in the ebook’s reading order. Instead, the reader’s ereading system displays the ToC as part of its reading interface.

These rules outline how to structure the ToC. Typically, the `se build-toc` tool constructs the ToC according to these rules, without further changes being necessary.

### The `<nav>` element

1.  The first child of the ToC’s `<body>` element is a `<nav>` element with the semantic inflection `toc`.
2.  The first child of the `<nav>` element is a `<h2 epub:type="title">Table of Contents</h2>` element.
3.  The second child of the `<nav>` element is an `<ol>` element representing the items in the Table of Contents.

#### The top-level `<ol>` element

The `<nav>` element’s top-level `<ol>` element contains a list of items in the Table of Contents.

1.  The first child is a link to the titlepage.

    ``` html
    <li>
        <a href="text/titlepage.xhtml">Titlepage</a>
    </li>
    ```

2.  The second child is a link to the imprint.

    ``` html
    <li>
        <a href="text/imprint.xhtml">Imprint</a>
    </li>
    ```

3.  The second-to-last child is a link to the colophon.

    ``` html
    <li>
        <a href="text/colophon.xhtml">Colophon</a>
    </li>
    ```

4.  The last child is a link to the Uncopyright.

    ``` html
    <li>
        <a href="text/uncopyright.xhtml">Uncopyright</a>
    </li>
    ```

5.  In books with half title pages, the half title page is listed in the ToC and the next sibling is an `<ol>` element containing the book’s contents.

    ``` html
    <li>
        <a href="text/halftitlepage.xhtml">The Moon Pool</a>
        <ol>
            <li>
                <a href="text/chapter-1.xhtml"><span epub:type="z3998:roman">I</span>: The Thing on the Moon Path</a>
            </li>
            <li>
                <a href="text/chapter-2.xhtml"><span epub:type="z3998:roman">II</span>: “Dead! All Dead!”</a>
            </li>
    ```

    1.  In books that have a half title page, and whose body text is a single file without heading content (for example, [Father Goriot](https://standardebooks.org/ebooks/honore-de-balzac/father-goriot/ellen-marriage) or [The Path to Rome](https://standardebooks.org/ebooks/hilaire-belloc/the-path-to-rome)), the half title page ToC entry text is set to `Half-Titlepage`.

    ``` html
    <li>
        <a href="text/halftitlepage.xhtml">Half-Titlepage</a>
        <ol>
            <li>
                <a href="text/father-goriot.xhtml">Father Goriot</a>
            </li>
    ```

#### `<li>` descendents

1.  Each `<li>` contains an `<a>` element pointing to a file or hash, and optionally also contains an `<ol>` element representing a nested series of ToC items.

2.  If an `<li>` element contains a nested `<ol>` element, that `<li>`’s first child is an `<a>` element that points to the beginning of that section.

    ``` html
    <li>
        <a href="text/halftitlepage.xhtml">Sybil</a>
        <ol>
            <li>
                <a href="text/book-1.xhtml">Book <span epub:type="z3998:roman">I</span></a>
                <ol>
                    <li>
                        <a href="text/chapter-1-1.xhtml" epub:type="z3998:roman">I</a>
                    </li>
    ```

3.  Roman numerals in the ToC have a `<span>` element if the entire contents of the `<a>` element are not a Roman numeral.

    <div class="wrong">

    ``` html
    <li>
        <a href="text/chapter-1.xhtml">I</a>
    </li>
    ```

    </div>

    <div class="wrong">

    ``` html
    <li>
        <a href="text/chapter-1.xhtml"><span epub:type="z3998:roman">I</span></a>
    </li>
    ```

    </div>

    <div class="corrected">

    ``` html
    <li>
        <a href="text/chapter-1.xhtml" epub:type="z3998:roman">I</a>
    </li>
    ```

    </div>

    <div class="corrected">

    ``` html
    <li>
        <a href="text/book-1.xhtml">Book <span epub:type="z3998:roman">I</span></a>
        <ol>
            ...
        </ol>
    </li>
    ```

    </div>

#### `<a>` descendents

1.  The `title`, `subtitle`, `ordinal`, and any [related title epub semantics](https://www.w3.org/TR/epub-ssv-11/#sec-titles) are not included in ToC entries. Their usage context is only within actual heading content.
2.  The text of the `<a>` element is decided as follows:
    1.  If there is no `<hgroup>` in the section, the text becomes the inner XHTML of the top `<h1>`–`<h6>` element with any of the above semantics removed.
    2.  If there is an `<hgroup>` element:
        1.  If the `<hgroup>`’s closest parent `<section>` or `<article>` has an `epub:type` value of `part`, `division`, or `volume`, then keep all `<hgroup>` children.
        2.  Otherwise, if the `<hgroup>`’s closest parent `<section>` or `<article>` has an `epub:type` value of `halftitlepage`, or if the first child of the `<hgroup>` has the `title` semantic, then discard any children with the `subtitle` semantic.
        3.  Then, the text becomes the inner XHTML of the first `<hgroup>` child. If there is a second child, append a colon and space to the text, then the inner XHTML of the second child. The above semantics are then removed.

##### Examples

``` html
<article id="a-daughter-of-albion" epub:type="se:short-story">
    <h2 epub:type="title">A Daughter of Albion</h2>
    <p>...</p>
</article>
```

Result: `A Daughter of Albion`

``` html
<section id="book-1" epub:type="part">
    <hgroup>
        <h2>
            <span epub:type="label">Book</span>
            <span epub:type="ordinal z3998:roman">I</span>
        </h2>
        <p epub:type="title">The Coming of the Martians</p>
    </hgroup>
    <p>...</p>
</section>
```

Result: `Book <span epub:type="z3998:roman">I</span>: The Coming of the Martians`

``` html
<section id="chapter-1" epub:type="chapter">
    <hgroup>
        <h2 epub:type="ordinal z3998:roman">I</h2>
        <p epub:type="title">A Fellow Traveller</p>
    </hgroup>
    <p>...</p>
</section>
```

Result: `<span epub:type="z3998:roman">I</span>: A Fellow Traveller`

``` html
<section id="epilogue" epub:type="epilogue">
    <hgroup>
        <h3 epub:type="title">Epilogue</h3>
        <p epub:type="subtitle">A Morning Call</p>
    </hgroup>
    <p>...</p>
</section>
```

Result: `Epilogue`

### The landmarks `<nav>` element

After the first `<nav>` element, there is a second `<nav>` element with the semantic inflection of `landmarks`.

1.  The first child is an `<h2 epub:type="title">Landmarks</h2>` element.
2.  The second child is an `<ol>` element listing the major structural divisions of the book.

#### `<li>` descendents

Each `<li>` element contains a link to either the start of the main text (i.e. the start of the bodymatter, excluding a half titlepage), or to a major reference section (i.e. backmatter including endnotes, bibliography, glossary, index, LoI, etc.). [See the IDPF a11y best practices document](http://idpf.org/epub/a11y/techniques/#sem-003) for more information.

1.  Each `<li>` element has the computed semantic inflection of top-level `<section>` element in the file. The computed semantic inflection includes inherited semantic inflection from the `<body>` element.

    ``` html
    <li>
        <a href="text/endnotes.xhtml" epub:type="backmatter endnotes">Endnotes</a>
    </li>
    ```

2.  The body text, as a single unit regardless of internal divisions, is represented by a link to the first file of the body text. In a prose novel, this is usually Chapter 1 or Part 1. In a collection this is usually the first item, like the first short story in a short story collection. The text is the title of the work as represented in the metadata `<dc:title>` element.

    ``` html
    <li>
        <a href="text/book-1.xhtml" epub:type="bodymatter z3998:fiction">Sybil</a>
    </li>
    ```

    ``` html
    <li>
        <a href="text/chapter-1.xhtml" epub:type="bodymatter z3998:fiction">The Moon Pool</a>
    </li>
    ```

    ``` html
    <li>
        <a href="text/the-adventure-of-wisteria-lodge.xhtml" epub:type="bodymatter z3998:fiction">His Last Bow</a>
    </li>
    ```

## The titlepage

1.  The Standard Ebooks titlepage is the first item in the ebook’s content flow. Standard Ebooks do not have a separate cover page file within the content flow.

2.  The title page has a `<title>` element with the value `Titlepage`.

3.  The titlepage contains one `<section id="titlepage" epub:type="titlepage">` element which in turn contains one `<h1 epub:type="title">` element, author information, as well as one `<img src="../images/titlepage.svg">` element.

4.  The titlepage does not contain the subtitle, if there is one.

5.  The `<img>` element has an empty `alt` attribute.

6.  A complete titlepage looks like the following template:

    ``` html
    <?xml version="1.0" encoding="utf-8"?>
    <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" epub:prefix="z3998: http://www.daisy.org/z3998/2012/vocab/structure/, se: https://standardebooks.org/vocab/1.0" xml:lang="en-US">
        <head>
            <title>Titlepage</title>
            <link href="../css/core.css" rel="stylesheet" type="text/css"/>
            <link href="../css/se.css" rel="stylesheet" type="text/css"/>
        </head>
        <body epub:type="frontmatter">
            <section id="titlepage" epub:type="titlepage">
                <h1 epub:type="title">TITLE</h1>
                <p>By <b epub:type="z3998:author">AUTHOR</b>.</p>
                <p>Translated by <b epub:type="z3998:translator">TRANSLATOR</b>.</p>
                <p>Illustrated by <b>ILLUSTRATOR</b>.</p>
                <img alt="" src="../images/titlepage.svg" epub:type="se:image.color-depth.black-on-transparent"/>
            </section>
        </body>
    </html>
    ```

## The imprint

1.  The Standard Ebooks imprint is the second item in the ebook’s content flow.

2.  The imprint has a `<title>` element with the value `Imprint`.

3.  The imprint contains one `<section id="imprint" epub:type="imprint">` element, which in turn contains one `<header>` element with the Standard Ebooks logo, followed by a series of `<p>` elements containing the imprint’s content.

4.  The second `<p>` element contains links to the online transcription that the ebook is based off of, followed by a link to the online page scans used to proof against.

    1.  While the template lists Project Gutenberg and the Internet Archive as the default sources for transcriptions and scans, these may be adjusted to the specific sources used for a particular ebook.

    2.  When a source is preceded by “the”, “the” is outside of the link to the source.

        <div class="wrong">

        ``` html
        <p>This particular ebook is based on digital scans from <a href="IA_URL">the Internet Archive</a>.</p>
        ```

        </div>

        <div class="corrected">

        ``` html
        <p>This particular ebook is based on digital scans from the <a href="IA_URL">Internet Archive</a>.</p>
        ```

        </div>

    3.  If an ebook is based on multiple sources or transcriptions (for example, a short story collection of a voluminous author), then the source sentence is altered to reflect that either the transcriptions, the page scans, or both, came from various sources.

        1.  If transcriptions or page scans come from the same domain (like only the Internet Archive or HathiTrust):

            > ``` html
            > <p>This particular ebook is based on transcriptions from <a href="EBOOK_URL#transcriptions">Project Gutenberg</a> and on digital scans from the <a href="IA_URL">Internet Archive</a>.</p>
            > ```
            >
            > ``` html
            > <p>This particular ebook is based on a transcription from <a href="PG_URL">Project Gutenberg</a> and on digital scans from the <a href="EBOOK_URL#page-scans">Internet Archive</a>.</p>
            > ```
            >
            > ``` html
            > <p>This particular ebook is based on transcriptions from <a href="EBOOK_URL#transcriptions">Project Gutenberg</a> and on digital scans from the <a href="EBOOK_URL#page-scans">Internet Archive</a>.</p>
            > ```

        2.  If transcriptions or page scans come from more than one domain (like both the Internet Archive and HathiTrust):

            > ``` html
            > <p>This particular ebook is based on transcriptions from <a href="EBOOK_URL#transcriptions">various sources</a> and on digital scans from the <a href="IA_URL">Internet Archive</a>.</p>
            > ```
            >
            > ``` html
            > <p>This particular ebook is based on a transcription from <a href="PG_URL">Project Gutenberg</a> and on digital scans from <a href="EBOOK_URL#page-scans">various sources</a>.</p>
            > ```
            >
            > ``` html
            > <p>This particular ebook is based on transcriptions from <a href="EBOOK_URL#transcriptions">various sources</a> and on digital scans from <a href="EBOOK_URL#page-scans">various sources</a>.</p>
            > ```

5.  A complete imprint looks like the following template:

    ``` html
    <?xml version="1.0" encoding="utf-8"?>
    <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" epub:prefix="z3998: http://www.daisy.org/z3998/2012/vocab/structure/, se: https://standardebooks.org/vocab/1.0" xml:lang="en-US">
        <head>
            <title>Imprint</title>
            <link href="../css/core.css" rel="stylesheet" type="text/css"/>
            <link href="../css/se.css" rel="stylesheet" type="text/css"/>
        </head>
        <body epub:type="frontmatter">
            <section id="imprint" epub:type="imprint">
                <header>
                    <h2 epub:type="title">Imprint</h2>
                    <img alt="The Standard Ebooks logo." src="../images/logo.svg" epub:type="z3998:publisher-logo se:image.color-depth.black-on-transparent"/>
                </header>
                <p>This ebook is the product of many hours of hard work by volunteers for <a href="https://standardebooks.org">Standard Ebooks</a>, and builds on the hard work of other literature lovers made possible by the public domain.</p>
                <p>This particular ebook is based on a transcription from <a href="PG_URL">Project Gutenberg</a> and on digital scans from the <a href="IA_URL">Internet Archive</a>.</p>
                <p>The source text and artwork in this ebook are believed to be in the United States public domain; that is, they are believed to be free of copyright restrictions in the United States. They may still be copyrighted in other countries, so users located outside of the United States must check their local laws before using this ebook. The creators of, and contributors to, this ebook dedicate their contributions to the worldwide public domain via the terms in the <a href="https://creativecommons.org/publicdomain/zero/1.0/">CC0 1.0 Universal Public Domain Dedication</a>. For full license information, see the <a href="uncopyright.xhtml">Uncopyright</a> at the end of this ebook.</p>
                <p>Standard Ebooks is a volunteer-driven project that produces ebook editions of public domain literature using modern typography, technology, and editorial standards, and distributes them free of cost. You can download this and other ebooks carefully produced for true book lovers at <a href="https://standardebooks.org">standardebooks.org</a>.</p>
            </section>
        </body>
    </html>
    ```

## The half title page

1.  A half title page is included when there is front matter of any type in an ebook besides the titlepage and imprint.

2.  The half title page is located after the last item of front matter, before the body matter.

3.  The half title page has a `<title>` element containing the full title of the ebook.

4.  The half title page contains one `<section id="halftitlepage" epub:type="halftitlepage">` element, which in turn contains either one `<h2 epub:type="fulltitle">` element containing the full title of the ebook, or one `<hgroup epub:type="fulltitle">` element containing one `<h2 epub:type="title">` element and one `<p epub:type="subtitle">` element.

5.  If the ebook has a subtitle, it is included in the half title page.

6.  The `fulltitle` semantic is applied to the top-level heading element in the half title page. This is usually either `<hgroup>` in works with subtitles or `<h2>` in works without.

7.  Formatting for the `<h2>` element follows patterns in [7.2.9](/manual/VERSION/7-high-level-structural-patterns#7.2.9).

8.  A complete half title page looks like the following template:

    ``` html
    <?xml version="1.0" encoding="utf-8"?>
    <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" epub:prefix="z3998: http://www.daisy.org/z3998/2012/vocab/structure/, se: https://standardebooks.org/vocab/1.0" xml:lang="en-GB">
        <head>
            <title>His Last Bow</title>
            <link href="../css/core.css" rel="stylesheet" type="text/css"/>
            <link href="../css/local.css" rel="stylesheet" type="text/css"/>
        </head>
        <body epub:type="frontmatter">
            <section id="halftitlepage" epub:type="halftitlepage">
                <hgroup epub:type="fulltitle">
                    <h2 epub:type="title">His Last Bow</h2>
                    <p epub:type="subtitle">Some Reminiscences of Sherlock Holmes</p>
                </hgroup>
            </section>
        </body>
    </html>
    ```

## The colophon

1.  The colophon is the second-to-last item in the ebook’s content flow.
2.  The colophon has a `<title>` element with the value `Colophon`.
3.  The colophon contains one `<section id="colophon" epub:type="colophon">` element, which in turn contains one `<header>` element with the Standard Ebooks logo, followed by a series of `<p>` elements containing the colophon’s content.

### Names

1.  Within `<p>` elements, proper names except for the book title and cover art title are wrapped in an `<a>` element pointing to the name’s Wikipedia page, or to a link representing the name, like a personal homepage.

2.  If a name does not have an English-language Wikipedia entry, the name is wrapped in `<b epub:type="z3998:personal-name">`.

3.  Two names are separated by `and`. Three or more names are separated by commas, with the final name separated by `, and`. (I.e., with an Oxford comma.)

    <div class="wrong">

    ``` html
    <b epub:type="z3998:personal-name">Fritz Ohrenschall</b>, <b epub:type="z3998:personal-name">Sania Ali Mirza</b> and <a href="https://www.pgdp.net">The Online Distributed Proofreading Team</a>
    ```

    </div>

    <div class="corrected">

    ``` html
    <b epub:type="z3998:personal-name">Fritz Ohrenschall</b>, <b epub:type="z3998:personal-name">Sania Ali Mirza</b>, and <a href="https://www.pgdp.net">The Online Distributed Proofreading Team</a>
    ```

    </div>

#### Anonymous contributors

1.  Anonymous or unknown primary contributors (like the author) are listed as `<b>Anonymous</b>`.
2.  Anonymous or unknown cover artists are listed as `<b>An Unknown Artist</b>`. Note that their *metadata entries* are still listed as `Anonymous`, even though their *colophon entries* differ.
3.  Anonymous volunteers working on digitization or the actual ebook production are listed as `<b>An Anonymous Volunteer</b>`. Note that their *metadata entries* are still listed as `Anonymous`, even though their *colophon entries* differ.
4.  Both types of volunteer strings are not names, therefore their parent `<b>` elements do not have name semantics.

### Sponsors

1.  An ebook may have a financial sponsor. If so, the following block:

    > ``` html
    > <p>This ebook was produced for<br/>
    > <a href="https://standardebooks.org">Standard Ebooks</a><br/>
    > by<br/>
    > ```

    is replaced with:

    > ``` html
    > <p><a href="SPONSOR_HOMEPAGE_URL">SPONSOR_NAME</a><br/>
    > sponsored the production of this ebook for<br/>
    > <a href="https://standardebooks.org">Standard Ebooks</a>.<br/>
    > It was produced by<br/>
    > ```

### Subsections

1.  Subsections are represented by a `<p>` element.
    1.  Within each `<p>` element, a `<br/>` element is placed before and after any proper name block. A proper name block may contain more than one name in a direct series (like a list of transcribers).

        ``` html
        <p><i epub:type="se:name.publication.book">The Moon Pool</i><br/>
        was published in 1919 by<br/>
        <a href="https://en.wikipedia.org/wiki/Abraham_Merritt">Abraham Merritt</a>.</p>
        ```

    2.  The first `<p>` block names the book, its publication year, and its author.

        ``` html
        <p><i epub:type="se:name.publication.book">The Moon Pool</i><br/>
        was published in 1919 by<br/>
        <a href="https://en.wikipedia.org/wiki/Abraham_Merritt">Abraham Merritt</a>.</p>
        ```

        1.  If the book has a translator, a translator block follows the author name in the same `<p>` element. The translator block follows this formula: `It was translated from LANGUAGE in YEAR by <a href="TRANSLATOR_WIKI_URL">TRANSLATOR</a>.`.

            ``` html
            <p><i epub:type="se:name.publication.book">Eugene Onegin</i><br/>
            was published in 1837 by<br/>
            <a href="https://en.wikipedia.org/wiki/Alexander_Pushkin">Alexander Pushkin</a>.<br/>
            It was translated from Russian in 1881 by<br/>
            <a href="https://en.wikipedia.org/wiki/Henry_S._Spalding">Henry Spalding</a>.</p>
            ```

    3.  The second `<p>` block names the Standard Ebooks producer, the original transcribers, and the page scan sources.

        ``` html
        <p>This ebook was produced for<br/>
        <a href="https://standardebooks.org">Standard Ebooks</a><br/>
        by<br/>
        <a href="https://www.robinwhittleton.com/">Robin Whittleton</a>,<br/>
        and is based on a transcription produced in 1997 by<br/>
        <b>An Anonymous Volunteer</b> and <b epub:type="z3998:personal-name">David Widger</b><br/>
        for<br/>
        <a href="https://www.gutenberg.org/ebooks/965">Project Gutenberg</a><br/>
        and on digital scans from the<br/>
        <a href="https://archive.org/details/worksofdumas24dumaiala">Internet Archive</a>.</p>
        ```

        1.  If the Standard Ebooks producer also transcribed the book *in its entirety*, then the first line becomes: `<p>This ebook was transcribed and produced for<br/>`.
        2.  If an ebook is based on multiple sources or transcriptions (for example, a short story collection of a voluminous author), then the source sentence is altered to reflect that either the transcriptions, the page scans, or both, came from various sources. Individual transcriber names are omitted.
            1.  If the transcriptions or page scans all came from the same source (i.e., all of the transcriptions came from Project Gutenberg):

                ``` html
                <p>This ebook was produced for<br/>
                <a href="https://standardebooks.org">Standard Ebooks</a><br/>
                by<br/>
                <a href="https://www.robinwhittleton.com/">Robin Whittleton</a>,<br/>
                and is based on transcriptions from<br/>
                <a href="EBOOK_URL#transcriptions">Project Gutenberg</a><br/>
                and on digital scans from the<br/>
                <a href="https://archive.org/details/worksofdumas24dumaiala">Internet Archive</a>.</p>
                ```

                ``` html
                <p>This ebook was produced for<br/>
                <a href="https://standardebooks.org">Standard Ebooks</a><br/>
                by<br/>
                <a href="https://www.robinwhittleton.com/">Robin Whittleton</a>,<br/>
                and is based on a transcription produced in 1997 by<br/>
                <b>An Anonymous Volunteer</b> and <b epub:type="z3998:personal-name">David Widger</b><br/>
                for<br/>
                <a href="https://www.gutenberg.org/ebooks/965">Project Gutenberg</a><br/>
                and on digital scans from the<br/>
                <a href="EBOOK_URL#page-scans">Internet Archive</a>.</p>
                ```

                ``` html
                <p>This ebook was produced for<br/>
                <a href="https://standardebooks.org">Standard Ebooks</a><br/>
                by<br/>
                <a href="https://www.robinwhittleton.com/">Robin Whittleton</a>,<br/>
                and is based on transcriptions from<br/>
                <a href="EBOOK_URL#transcriptions">Project Gutenberg</a><br/>
                and on digital scans from the<br/>
                <a href="EBOOK_URL#page-scans">Internet Archive</a>.</p>
                ```

            2.  If the transcriptions or page scans came from different sources:

                ``` html
                <p>This ebook was produced for<br/>
                <a href="https://standardebooks.org">Standard Ebooks</a><br/>
                by<br/>
                <a href="https://www.robinwhittleton.com/">Robin Whittleton</a>,<br/>
                and is based on transcriptions from <br/>
                <a href="EBOOK_URL#transcriptions">various sources</a><br/>
                and on digital scans from the<br/>
                <a href="https://archive.org/details/worksofdumas24dumaiala">Internet Archive</a>.</p>
                ```

                ``` html
                <p>This ebook was produced for<br/>
                <a href="https://standardebooks.org">Standard Ebooks</a><br/>
                by<br/>
                <a href="https://www.robinwhittleton.com/">Robin Whittleton</a>,<br/>
                and is based on a transcription produced in 1997 by<br/>
                <b>An Anonymous Volunteer</b> and <b epub:type="z3998:personal-name">David Widger</b><br/>
                for<br/>
                <a href="https://www.gutenberg.org/ebooks/965">Project Gutenberg</a><br/>
                and on digital scans from<br/>
                <a href="EBOOK_URL#page-scans">various sources</a>.</p>
                ```

                ``` html
                <p>This ebook was produced for<br/>
                <a href="https://standardebooks.org">Standard Ebooks</a><br/>
                by<br/>
                <a href="https://www.robinwhittleton.com/">Robin Whittleton</a>,<br/>
                and is based on transcriptions from<br/>
                <a href="EBOOK_URL#transcriptions">various sources</a><br/>
                and on digital scans from<br/>
                <a href="EBOOK_URL#page-scans">various sources</a>.</p>
                ```

    4.  The third `<p>` block names the cover art, cover artist, and the typefaces used on the cover and title pages.

        ``` html
        <p>The cover page is adapted from<br/>
        <i epub:type="se:name.visual-art.painting">Floral Still Life</i>,<br/>
        a painting completed in 1639 by<br/>
        <a href="https://en.wikipedia.org/wiki/Hans_Gillisz._Bollongier">Hans Bollongier</a>.<br/>
        The cover and title pages feature the<br/>
        <b epub:type="se:name.visual-art.typeface">League Spartan</b> and <b epub:type="se:name.visual-art.typeface">Sorts Mill Goudy</b><br/>
        typefaces created in 2014 and 2009 by<br/>
        <a href="https://www.theleagueofmoveabletype.com">The League of Moveable Type</a>.</p>
        ```

    5.  The fourth `<p>` block lists the original release date of the ebook and its Standard Ebooks page URL.

        ``` html
        <p>The first edition of this ebook was released on<br/>
        <b>May 11, 2018, 2:13 <abbr class="eoc">a.m.</abbr></b><br/>
        You can check for updates to this ebook, view its revision history, or download it for different ereading systems at<br/>
        <a href="https://standardebooks.org/ebooks/alexandre-dumas/the-black-tulip/p-f-collier-and-son">standardebooks.org/ebooks/alexandre-dumas/the-black-tulip/p-f-collier-and-son</a>.</p>
        ```

    6.  The fifth `<p>` block is a short formula inviting volunteers.

        ``` html
        <p>The volunteer-driven Standard Ebooks project relies on readers like you to submit typos, corrections, and other improvements. Anyone can contribute at <a href="https://standardebooks.org">standardebooks.org</a>.</p>
        ```

### Dates

1.  Dates in the colophon that are after the year 1 CE are wrapped in `<time>` elements.

    1.  If the date is a year with four digits, the `<time>` element does not have a `datetime` attribute.

    ``` html
    <p><i epub:type="se:name.publication.book">Ben Hur</i><br/>
    was published in <time>1880</time> by<br/>
    <a href="https://en.wikipedia.org/wiki/Lew_Wallace">Lew Wallace</a>.</p>
    ```

    1.  If the date is a year with less than four digits, the `<time>` element has a `datetime` attribute that contains the year padded with zeros up to four digits.

    ``` html
    <p><i epub:type="se:name.publication.poem">Beowulf</i><br/>
    is thought to have been written between <time datetime="0975">975</time> and <time>1010</time>.<br/>
    ```

    1.  Years before 1 CE are not supported by the `<time>` element, therefore they are not wrapped in a `<time>` elements in the colophon.

    ``` html
    <p><i epub:type="se:name.publication.play">Oedipus at Colonus</i><br/>
    was written in 406 <abbr epub:type="se:era z3998:initialism">BCE</abbr> by<br/>
    <a href="https://en.wikipedia.org/wiki/Sophocles">Sophocles</a>.<br/>
    It was translated from Ancient Greek in <time>1912</time> by<br/>
    <b epub:type="z3998:personal-name">Francis Storr</b>.</p>
    ```

### An example of a complete colophon

``` html
<?xml version="1.0" encoding="utf-8"?>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" epub:prefix="z3998: http://www.daisy.org/z3998/2012/vocab/structure/, se: https://standardebooks.org/vocab/1.0" xml:lang="en-US">
    <head>
        <title>Colophon</title>
        <link href="../css/core.css" rel="stylesheet" type="text/css"/>
        <link href="../css/local.css" rel="stylesheet" type="text/css"/>
    </head>
    <body epub:type="backmatter">
        <section id="colophon" epub:type="colophon">
            <header>
                <h2 epub:type="title">Colophon</h2>
                <img alt="The Standard Ebooks logo" src="../images/logo.svg" epub:type="z3998:publisher-logo se:image.color-depth.black-on-transparent"/>
            </header>
            <p><i epub:type="se:name.publication.book">The Black Tulip</i><br/>
            was published in <time>1850</time> by<br/>
            <a href="https://en.wikipedia.org/wiki/Alexandre_Dumas">Alexandre Dumas</a>.<br/>
            It was translated from French in <time>1902</time> by<br/>
            <a href="https://en.wikipedia.org/wiki/Peter_F._Collier"><abbr epub:type="z3998:given-name">P. F.</abbr> Collier and Son</a>.</p>
            <p>This ebook was produced for<br/>
            <a href="https://standardebooks.org">Standard Ebooks</a><br/>
            by<br/>
            <a href="https://www.robinwhittleton.com/">Robin Whittleton</a>,<br/>
            and is based on a transcription produced in <time>1997</time> by<br/>
            <b>An Anonymous Volunteer</b> and <b epub:type="z3998:personal-name">David Widger</b><br/>
            for<br/>
            <a href="https://www.gutenberg.org/ebooks/965">Project Gutenberg</a><br/>
            and on digital scans from the<br/>
            <a href="https://archive.org/details/worksofdumas24dumaiala">Internet Archive</a>.</p>
            <p>The cover page is adapted from<br/>
            <i epub:type="se:name.visual-art.painting">Floral Still Life</i>,<br/>
            a painting completed in <time>1639</time> by<br/>
            <a href="https://en.wikipedia.org/wiki/Hans_Gillisz._Bollongier">Hans Bollongier</a>.<br/>
            The cover and title pages feature the<br/>
            <b epub:type="se:name.visual-art.typeface">League Spartan</b> and <b epub:type="se:name.visual-art.typeface">Sorts Mill Goudy</b><br/>
            typefaces created in <time>2014</time> and <time>2009</time> by<br/>
            <a href="https://www.theleagueofmoveabletype.com">The League of Moveable Type</a>.</p>
            <p>The first edition of this ebook was released on<br/>
            <b><time datetime="2018-05-11T02:13">May 11, 2018, 2:13 <abbr class="eoc">a.m.</abbr></time></b><br/>
            You can check for updates to this ebook, view its revision history, or download it for different ereading systems at<br/>
            <a href="https://standardebooks.org/ebooks/alexandre-dumas/the-black-tulip/p-f-collier-and-son">standardebooks.org/ebooks/alexandre-dumas/the-black-tulip/p-f-collier-and-son</a>.</p>
            <p>The volunteer-driven Standard Ebooks project relies on readers like you to submit typos, corrections, and other improvements. Anyone can contribute at <a href="https://standardebooks.org">standardebooks.org</a>.</p>
        </section>
    </body>
</html>
```

## The Uncopyright

Where traditionally published ebooks may contain a copyright page at the front of the ebook, Standard Ebooks contain an Uncopyright page at the end of the ebook.

1.  The Uncopyright page is the last item in the ebook’s content flow.
2.  The Uncopyright page follows the template created by `se create-draft` exactly.
