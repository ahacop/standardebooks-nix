# XHTML, CSS, and SVG Code Style

The `se clean` tool in the [Standard Ebooks toolset](https://standardebooks.org/tools) formats XML, XHTML, CSS, and SVG code according to our style guidelines. The vast majority of the time its output is correct and no further modifications to code style are necessary.

## XHTML formatting

1.  The first line of all XHTML files is:

    ``` html
    <?xml version="1.0" encoding="utf-8"?>
    ```

2.  The second line of all XHTML files is (replace `xml:lang="en-US"` with the [appropriate language tag](https://en.wikipedia.org/wiki/IETF_language_tag) for the file):

    ``` html
    <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" epub:prefix="z3998: http://www.daisy.org/z3998/2012/vocab/structure/, se: https://standardebooks.org/vocab/1.0" xml:lang="en-US">
    ```

3.  Tabs are used for indentation.

4.  Tag names are lowercase.

5.  Elements whose content is [phrasing content](https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/Content_categories#Phrasing_content) are on a single line, with no whitespace between the opening and closing tags and the content.

    <div class="wrong">

    ``` html
    <p>
        It was a dark and stormy night...
    </p>
    ```

    </div>

    <div class="corrected">

    ``` html
    <p>It was a dark and stormy night...</p>
    ```

    </div>

### `<br/>` elements

1.  `<br/>` elements within [phrasing content](https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/Content_categories#Phrasing_content) are on the same line as the preceding phrasing content, and are followed by a newline.

    <div class="wrong">

    ``` html
    <p>“Pray for the soul of the
    <br/>
    Demoiselle Jeanne D’Ys.</p>
    ```

    </div>

    <div class="wrong">

    ``` html
    <p>“Pray for the soul of the
    <br/>Demoiselle Jeanne D’Ys.</p>
    ```

    </div>

    <div class="corrected">

    ``` html
    <p>“Pray for the soul of the<br/>
    Demoiselle Jeanne D’Ys.</p>
    ```

    </div>

2.  The next indentation level after a `<br/>` element is the same as the previous indentation level.

    <div class="wrong">

    ``` html
    <p>“Pray for the soul of the<br/>
        Demoiselle Jeanne D’Ys,<br/>
        who died<br/>
        in her youth for love of<br/>
        Philip, a Stranger.</p>
    ```

    </div>

    <div class="corrected">

    ``` html
    <p>“Pray for the soul of the<br/>
    Demoiselle Jeanne D’Ys,<br/>
    who died<br/>
    in her youth for love of<br/>
    Philip, a Stranger.</p>
    ```

    </div>

3.  The closing tag of the phrasing content broken by a `<br/>` element is on the same line as the last line of the phrasing content.

    <div class="wrong">

    ``` html
    <p>“Pray for the soul of the<br/>
    Demoiselle Jeanne D’Ys.
    </p>
    ```

    </div>

    <div class="corrected">

    ``` html
    <p>“Pray for the soul of the<br/>
    Demoiselle Jeanne D’Ys.</p>
    ```

    </div>

4.  `<br/>` elements have phrasing content both before and after; they don’t appear with phrasing content only before, or only after.

    <div class="wrong">

    ``` html
    <p>“Pray for the soul of the<br/>
    Demoiselle Jeanne D’Ys<br/></p>
    ```

    </div>

    <div class="corrected">

    ``` html
    <p>“Pray for the soul of the<br/>
    Demoiselle Jeanne D’Ys</p>
    ```

    </div>

### Attributes

1.  Attributes are in alphabetical order.

2.  Attributes, their namespaces, and their values are lowercase, except for values which are IETF language tags. In IETF language tags, the country subtag is capitalized.

    <div class="wrong">

    ``` html
    <section EPUB:TYPE="CHAPTER" XML:LANG="EN-US">...</section>
    ```

    </div>

    <div class="corrected">

    ``` html
    <section epub:type="chapter" xml:lang="en-US">...</section>
    ```

    </div>

3.  The string `utf-8` is lowercase.

## CSS formatting

1.  The first two lines of all CSS files are:

    ``` css
    @charset "utf-8";
    @namespace epub "http://www.idpf.org/2007/ops";
    ```

2.  Tabs are used for indentation.

3.  Selectors, properties, and values are lowercase.

### Selectors

1.  Selectors are each on their own line, directly followed by a comma or a brace with no whitespace in between.

    <div class="wrong">

    ``` css
    abbr[epub|type~="se:era"], abbr[epub|type~="se:temperature"]{
        font-variant: all-small-caps;
    }
    ```

    </div>

    <div class="corrected">

    ``` css
    abbr[epub|type~="se:era"],
    abbr[epub|type~="se:temperature"]{
        font-variant: all-small-caps;
    }
    ```

    </div>

2.  Complete selectors are separated by exactly one blank line.

    <div class="wrong">

    ``` css
    abbr[epub|type~="se:era"]{
        font-variant: all-small-caps;
    }


    strong{
        font-weight: normal;
        font-variant: small-caps;
    }
    ```

    </div>

    <div class="corrected">

    ``` css
    abbr[epub|type~="se:era"]{
        font-variant: all-small-caps;
    }

    strong{
        font-weight: normal;
        font-variant: small-caps;
    }
    ```

    </div>

3.  Closing braces are on their own line.

### Properties

1.  Properties are each on their own line (even if the selector only has one property) and indented with a single tab.

    <div class="wrong">

    ``` css
    abbr[epub|type~="se:era"]{ font-variant: all-small-caps; }
    ```

    </div>

    <div class="corrected">

    ``` css
    abbr[epub|type~="se:era"]{
        font-variant: all-small-caps;
    }
    ```

    </div>

2.  *Where possible*, properties are in alphabetical order.

    This isn’t always possible if a property is attempting to override a previous property in the same selector, and in some other cases.

3.  Properties are directly followed by a colon, then a single space, then the property value.

    <div class="wrong">

    ``` css
    blockquote{
        margin-left:    1em;
        margin-right:   1em;
        border:none;
    }
    ```

    </div>

    <div class="corrected">

    ``` css
    blockquote{
        margin-left: 1em;
        margin-right: 1em;
        border: none;
    }
    ```

    </div>

4.  Property values are directly followed by a semicolon, even if it’s the last value in a selector.

    <div class="wrong">

    ``` css
    abbr[epub|type~="se:era"]{
        font-variant: all-small-caps
    }
    ```

    </div>

    <div class="corrected">

    ``` css
    abbr[epub|type~="se:era"]{
        font-variant: all-small-caps;
    }
    ```

    </div>

5.  Property values that are numbers do not have a leading `0`.

    <div class="wrong">

    ``` css
    margin: 0.5em
    ```

    </div>

    <div class="corrected">

    ``` css
    margin: .5em
    ```

    </div>

#### Fonts

1.  Font sizes are never less than `1em` where possible.

2.  When font size is changed in isolation, the keywords `larger` and `smaller` are used instead of specific unit measurements. Font sizes that are changed relatively in close proximity to each other may be specified in unit measurements to show their size relative to each other.

    <div class="corrected">

    ``` html
    <header>
        <h2 epub:type="title">The Dance of Death</h2>
        <blockquote epub:type="epigraph">
            <p>“Many words for few things!”</p>
        </blockquote>
        <blockquote epub:type="epigraph">
            <p>“Death ends all; judgment comes to all.”</p>
        </blockquote>
        <p>Death Speaks</p>
    </header>
    ```

    ``` css
    header blockquote + p{
        font-size: larger;
        font-variant: small-caps;
        font-weight: bold;
        text-indent: 0;
    }
    ```

    </div>

    <div class="corrected">

    ``` html
    <p class="continued">After sixty seconds I shouted:</p>
    <blockquote>
        <p>“Transvaaltruppentropentransporttrampelthiertreibertrauungsthraenentragoedie!”</p>
    </blockquote>
    <p class="continued">—and lit up the green fire! After waiting only forty seconds this time, I spread my arms abroad and thundered out the devastating syllables of this word of words:</p>
    <blockquote>
        <p>“Mekkamuselmannenmassenmenchenmoerdermohrenmuttermarmormonumentenmacher!”</p>
    </blockquote>
    ```

    ``` css
    blockquote:nth-of-type(1) p{
        font-size: 1.2em;
    }

    blockquote:nth-of-type(2) p{
        font-size: 1.5em;
    }
    ```

    </div>

## SVG Formatting

1.  SVG formatting follows the same directives as [XHTML formatting](/manual/VERSION/1-code-style#1.1).

## Commits and Commit Messages

1.  Commits are broken into single units of work. A single unit of work may be, for example, "fixing typos across 10 files", or "adding cover art", or "working on metadata".
2.  Commits that introduce material changes to the ebook text (for example modernizing spelling or fixing a probable printer’s typo; but not fixing a transcriber’s typo) are prefaced with the string `[Editorial]`, followed by a space, then the commit message. This makes it easy to search the repo history for commits that make editorial changes to the work.
