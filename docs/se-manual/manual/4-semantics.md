# Semantics

Semantics convey what an element or section *mean* or *are*, instead of merely conveying *how they are visually presented*.

For example, the following snippet visually presents a paragraph, followed by a quotation from a poem:

``` html
<div>“All done in the tying of a cravat,” Sir Percy had declared to his clique of admirers.</div>
<div style="margin: 1em;">
    <div>“We seek him here, we seek him there,<br/>
    Those Frenchies seek him everywhere.<br/>
    Is he in heaven?⁠—Is he in hell,<br/>
    That demmed, elusive Pimpernel?”</div>
</div>
```

While that snippet might *visually* present the text as a paragraph followed by a quotation of verse, the actual HTML tells us nothing about *what these lines of text actually are*.

Compare the above snippet to this next snippet, which renders almost identically but uses semantically-correct elements and epub’s semantic inflection to tell us *what the text is*:

``` html
<p>“All done in the tying of a cravat,” Sir Percy had declared to his clique of admirers.</p>
<blockquote epub:type="z3998:poem">
    <p>
        <span>“We seek him here, we seek him there,</span>
        <br/>
        <span>Those Frenchies seek him everywhere.</span>
        <br/>
        <span>Is he in heaven?⁠—Is he in hell,</span>
        <br/>
        <span>That demmed, elusive Pimpernel?”</span>
    </p>
</blockquote>
```

By inspecting the elements above, we can see that the first line is a semantic paragraph (`<p>` stands for **p**aragraph, of course); the paragraph is followed by a semantic block quotation, which browsers automatically render with a margin; the quotation is a poem; the poem has one stanza; and there are four lines in the poem. (By SE convention, `<p>` elements in verse are stanzas and `<span>` elements are lines.)

## Semantic Elements

Epub allows for the use of the full range of elements in the HTML5 spec. Each element has a semantic meaning, and each element in a Standard Ebook is carefully considered before use.

Below is an incomplete list of HTML5 elements and their semantic meanings. These are some of the most common elements encountered in an ebook.

### Block-level elements

Block-level elements are by default rendered with `display: block;`. See the [complete list of block-level elements](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements#text_content).

1.  Sectioning block-level elements denote major structural divisions in a work.
    1.  `<body>`: The top-level element in any XHTML file. Must contain a direct child that is either a `<section>` or `<article>`.
    2.  `<section>`: A major structural division in a work. Typically a part, volume, chapter, or subchapter. Semantically a `<section>` cannot stand alone, but is part of a larger work.
    3.  `<article>`: An item in a larger work that could be pulled out of the work and serialized or syndicated separately. For example, a single poem in a poetry collection, or a single short story in a short story collection; but *not* a single poem in a larger novel.
2.  Other block-level elements have well-defined semantic meanings.
    1.  `<p>`: A paragraph of text.
    2.  `<blockquote>`: A quotation displayed on the block level. This may include non-speech “quotations” like business cards, headstones, telegrams, letters, and so on.
    3.  `<figure>`: Encloses a photograph, chart, or illustration, represented with an `<img>` element. Optionally includes a `<figcaption>` element for a context-appropriate caption.
    4.  `<figcaption>`: Only appears as a child of `<figure>`. Represents a context-appropriate caption for the sibling `<img>`. A caption *is not the same* as an `<img>` element’s `alt` text. `alt` text is strictly a textual description of the image used for screen readers, whereas `<figcaption>` has more freedom in its contents, depending on its context.
    5.  `<header>`: Denotes a header section applying to its direct parent. `<header>` is typically found in sections where there is additional header content besides the section title, but can also be used in `<blockquote>`s or other block-level elements that require header styling.
    6.  `<footer>`: Denotes a footer section applying to its direct parent. Typically used to denote signatures in sections like prefaces, forewords, letters, telegrams, and so on.
    7.  `<hr/>`: Denotes a thematic break. `<hr/>` *is not used* any place a black border is desired; it *strictly denotes* a thematic break.
    8.  `<ol>`: Denotes an ordered list. Ordered lists are automatically numbered by the renderer.
    9.  `<ul>`: Denotes an unordered list. Unordered lists are bulleted by the renderer.
    10. `<li>`: Denotes a list item in a parent `<ol>` or `<ul>`.
    11. `<table>`: Denotes a tabular section, for example when displaying tabular data, or reports or charts where a tabular appearance is desired.
3.  `<div>` elements are almost never appropriate, as they have no semantic meaning. However, they may in rare occasions be used to group related elements in a situation where no other semantic element is appropriate.

### Inline elements

Inline elements are by default rendered with `display: inline;`. See the [complete list of inline elements](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements#inline_text_semantics).

1.  `<em>`: Text rendered in italics, with the semantic meaning of emphasized speech, or speech spoken in a different tone of voice; for example, a person shouting, or putting stress on a particular word.

2.  `<i>`: Text rendered in italics, without any explicit semantic meaning. Because `<i>` lacks semantic meaning, the `epub:type` attribute is added with appropriate semantic inflection to describe the contents of the element.

    <div class="corrected">

    ``` html
    <p>The <abbr epub:type="z3998:initialism">H.M.S.</abbr> <i epub:type="se:name.vessel.ship">Bounty</i>.</p>
    ```

    </div>

3.  `<b>`: Text rendered in small caps, without any explicit semantic meaning. Because `<b>` lacks semantic meaning, the `epub:type` attribute can be added with appropriate semantic inflection to describe the contents of the element; however, unlike `<i>`, it’s rare for `<b>` to require semantic meaning, as it is generally used only for visual styling.

4.  `<span>`: Plain inline text that requires specific styling or semantic meaning that cannot be achieved with any other semantically meaningful inline element. Typically used in conjunction with a `class` or `epub:type` attribute.

## Semantic Inflection

The epub spec allows for [semantic inflection](https://www.w3.org/TR/epub-ssv-11/), which is a way of adding semantic metadata to elements in the ebook document.

For example, an ebook producer may want to convey that the contents of a certain `<section>` are part of a chapter. They would do that by using the `epub:type` attribute:

``` html
<section epub:type="chapter">...</section>
```

1.  The epub spec includes a [vocabulary](https://www.w3.org/TR/epub-ssv-11/) that can be used in the `epub:type` attribute. This vocabulary has priority when selecting a semantic keyword, even if other vocabularies contain the same one.

2.  The epub spec might not contain a keyword necessary to describe the semantics of a particular element. In that case, the [z3998 vocabulary](http://www.daisy.org/z3998/2012/vocab/structure/) is consulted next.

    Keywords using this vocabulary are preceded by the `z3998` namespace.

    ``` html
    <blockquote epub:type="z3998:letter">...</blockquote>
    ```

3.  If the z3998 vocabulary doesn’t have an appropriate keyword, the [Standard Ebooks vocabulary](/vocab/1.0) is consulted next.

    Keywords using this vocabulary are preceded by the `se` namespace.

    Unlike other vocabularies, the Standard Ebooks vocabulary is organized hierarchically. A complete vocabulary entry begins with the root vocabulary entry, with subsequent children separated by `.`.

    ``` html
    The <abbr epub:type="z3998:initialism">H.M.S.</abbr> <i epub:type="se:name.vessel.ship">Bounty</i>.
    ```

4.  The `epub:type` attribute can have multiple keywords separated by spaces, even if the vocabularies are different.

    ``` html
    <section epub:type="chapter z3998:letter">...</section>
    ```

5.  Child elements inherit the semantics of their parent element.

    In this example, both chapters are considered to be “non-fiction,” because they inherit it from the `<body>` element:

    ``` html
    <body epub:type="z3998:non-fiction">
        <section id="chapter-1" epub:type="chapter">
            <h2 epub:type="ordinal z3998:roman">I</h2>
            ...
        </section>
        <section id="chapter-2" epub:type="chapter">
            <h2 epub:type="ordinal z3998:roman">II</h2>
            ...
        </section>
    </body>
    ```
