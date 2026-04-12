# General XHTML and CSS Patterns

This section covers general patterns used when producing XHTML and CSS that are not specific to ebooks.

## `id` attributes

### `id` attributes of `<section>` and `<article>` elements

1.  Each `<section>` and `<article>` element has an `id` attribute.

2.  `<section>` or `<article>` elements that are direct children of the `<body>` element have an `id` attribute identical to the filename containing that `<section>` or `<article>`, without the trailing extension.

3.  In files containing multiple `<section>` or `<article>` elements, each of those elements has an `id` attribute identical to what the filename *would* be if the section was in an individual file, without the trailing extension.

    <div class="corrected">

    ``` html
    <body epub:type="bodymatter z3998:fiction">
        <article id="the-fox-and-the-grapes" epub:type="se:short-story">
            <h2 epub:type="title">The Fox and the Grapes</h2>
            <p>...</p>
        </article>
        <article id="the-goose-that-laid-the-golden-eggs" epub:type="se:short-story">
            <h2 epub:type="title">The Goose That Laid the Golden Eggs</h2>
            <p>...</p>
        </article>
    </body>
    ```

    </div>

### `id` attributes of other elements

1.  `id` attributes are generally used to identify parts of the document that a reader may wish to navigate to using a hash in the URL. That generally means major structural divisions. Therefore, elements that are not `<section>` or `<article>` elements do not have an `id` attribute, unless a part of the ebook, like an endnote, refers to a specific point in the book, and a direct link is desirable.

2.  `id` attributes are not used as hooks for CSS styling.

3.  `<figure>` elements have an `id` attribute set to `illustration-N`, where `N` is the sequence number of the figure *across the entire ebook*, starting at `1`.

    ``` html
    <!-- chapter-1.xhtml -->
    <section id="chapter-1" epub:type="chapter">
        <p>...</p>
        <figure id="illustration-1">...</figure>
        <p>...</p>
    </section>

    <!-- chapter-3.xhtml -->
    <section id="chapter-3" epub:type="chapter">
        <p>...</p>
        <p>...</p>
        <figure id="illustration-2">...</figure>
    </section>
    ```

4.  Noteref elements have their `id` attributes set to `noteref-N`, where `N` is the sequence number of the noteref *across the entire ebook*, starting at `1`.

    ``` html
    <p>We threw an empty oil can down and it echoed for a terribly long time.<a href="endnotes.xhtml#note-228" id="noteref-228" epub:type="noteref">228</a></p>
    ```

5.  Endnote elements have their `id` attributes set to `note-N`, where `N` is the sequence number of the endnote, starting at `1`.

    ``` html
    <li id="note-1" epub:type="endnote">
        <p>Cook, <i epub:type="se:name.publication.book">A Voyage Towards the South Pole</i>, Introduction. <a href="introduction.xhtml#noteref-1" epub:type="backlink">↩</a></p>
    </li>
    ```

6.  `<dt>` elements have their `id` attribute set to the URL-safe version of the text contents of their child `<dfn>` element.

    ``` html
    <section id="glossary" epub:type="glossary">
        <dl>
            <dt id="blizzard" epub:type="glossterm">
                <dfn>Blizzard</dfn>
            </dt>
        </dl>
    </section>
    ```

7.  Other non `<dt>` children of semantic `glossary` elements do not have standardized `id` attributes, but rather should be set descriptively based on context.

8.  If an element whose `id` attribute is not otherwise standardized requires an `id` attribute, then the attribute’s value is formed by taking the `id` attribute of the closest parent `<section>`, `<article>`, or `endnote`, appending `-`, then the name of the element, then `-N`, where `N` is the sequence number of the element starting at `1` in the *flattened document tree order* of its closest parent sectioning element.

    <div class="corrected">

    ``` html
    <section id="chapter-1" epub:type="chapter">
        <header>
            <h2 epub:type="title">...</h2>
            <p epub:type="bridgehead">...</p>
        </header>
        <p id="chapter-1-p-2">...</p>
        <section id="chapter-1-1" epub:type="z3998:subchapter">
            <p>See <a href="#chapter-1-1-p-4">this paragraph</a> for more details.</p>
            <p>...</p>
            <p>See <a href="#chapter-1-p-2">this paragraph</a>.</p>
            <blockquote>
                <p id="chapter-1-1-p-4">...</p>
            </blockquote>
            <p>...</p>
        </section>
    </section>
    ```

    </div>

9.  For poems with the `z3998:poem` semantic in which a child has an `id` attribute referring to a specific line number, the `id` attribute’s value is formed by taking the `id` attribute of the closest parent `<section>` or `<article>` that contains the `z3998:poem` semantic, appending `-line`, then `-N`, where `N` is the sequence number of the line starting at `1` in the *flattened document tree order* of the selected sectioning element, *excluding* `<header>` *elements*.

    <div class="corrected">

    ``` html
    <article id="the-waste-land" epub:type="z3998:poem">
        <section id="the-waste-land-1" epub:type="z3998:subchapter">
            <p>
                <span>April is the cruellest month, breeding</span>
                <br/>
                <span id="the-waste-land-line-2">Lilacs out of the dead land, mixing</span>
                <br/>
                <span>Memory and desire, stirring</span>
            </p>
        </section>
        <section id="the-waste-land-2" epub:type="z3998:subchapter">
            <p>
                <span>The Chair she sat in, like a burnished throne,</span>
                <br/>
                <span>Glowed on the marble, where the glass</span>
                <br/>
                <span id="the-waste-land-line-6">Held up by standards wrought with fruited vines</span>
            </p>
        </section>
    </article>
    ```

    </div>

10. Individual `id` attributes are unique across the entire ebook.

    1.  If an element requires an `id` attribute that would conflict with one in a different file, the `id` attribute of the closest parent sectioning element, followed by `-`, is prepended to each `id` attribute to differentiate them.

        <div class="wrong">

        ``` html
        <!-- chapter-1.xhtml -->
        <section id="chapter-1" epub:type="chapter">
            <p id="p-1">...</p>
        </section>


        <!-- chapter-2.xhtml -->
        <section id="chapter-2" epub:type="chapter">
            <p id="p-1">...</p>
        </section>
        ```

        </div>

        <div class="corrected">

        ``` html
        <!-- chapter-1.xhtml -->
        <section id="chapter-1" epub:type="chapter">
            <p id="chapter-1-p-1">...</p>
        </section>


        <!-- chapter-2.xhtml -->
        <section id="chapter-2" epub:type="chapter">
            <p id="chapter-2-p-1">...</p>
        </section>
        ```

        </div>

## `class` attributes

Classes denote a *class of multiple elements* sharing a similar style.

1.  Classes are *not* used as single-use style hooks to style a single element. There is almost always a way to compose a CSS selector to select a single element without the use of a one-off class.

    <div class="wrong">

    ``` css
    .business-card{
        border: 1px solid;
        padding: 1em;
    }
    ```

    ``` html
    <body epub:type="bodymatter z3998:fiction">
        <section epub:type="chapter">
            <p>...</p>
            <p>...</p>
            <p>...</p>
            <p>...</p>
            <blockquote class="business-card">
                <p>John Doe, <abbr epub:type="z3998:name-title" class="eoc">Esq.</abbr></p>
            </blockquote>
        </section>
    </body>
    ```

    </div>

    <div class="corrected">

    ``` css
    #chapter-3 blockquote{
        border: 1px solid;
        padding: 1em;
    }
    ```

    ``` html
    <body epub:type="bodymatter z3998:fiction">
        <section id="chapter-3" epub:type="chapter">
            <p>...</p>
            <p>...</p>
            <p>...</p>
            <p>...</p>
            <blockquote>
                <p>John Doe, <abbr epub:type="z3998:name-title" class="eoc">Esq.</abbr></p>
            </blockquote>
        </section>
    </body>
    ```

    </div>

2.  Classes *are* used to style a recurring *class* of elements, i.e. a class of element that appears more than once in an ebook.

    <div class="corrected">

    ``` css
    .business-card{
        border: 1px solid;
        padding: 1em;
    }
    ```

    ``` html
    <body epub:type="bodymatter z3998:fiction">
        <section id="chapter-3" epub:type="chapter">
            <p>...</p>
            <p>...</p>
            <blockquote class="business-card">
                <p>Jane Doe, <abbr epub:type="z3998:name-title" class="eoc">Esq.</abbr></p>
            </blockquote>
            <p>...</p>
            <p>...</p>
            <blockquote class="business-card">
                <p>John Doe, <abbr epub:type="z3998:name-title" class="eoc">Esq.</abbr></p>
            </blockquote>
        </section>
    </body>
    ```

    </div>

3.  Class names describe *what* they are styling semantically, *not* the actual style the class is applying.

    <div class="wrong">

    ``` css
    .black-border{
        border: 1px solid;
        padding: 1em;
    }
    ```

    </div>

    <div class="corrected">

    ``` css
    .business-card{
        border: 1px solid;
        padding: 1em;
    }
    ```

    </div>

## `xml:lang` attributes

1.  When words are required to be pronounced in a language other than English, the `xml:lang` attribute is used to indicate the IETF language tag in use.

    1.  The `xml:lang` attribute is used even if a word is not required to be italicized. This allows screen readers to understand that a particular word or phrase should be pronounced in a certain way. A `<span xml:lang="TAG">` element is used to wrap text that has non-English pronunciation but that does not need further visual styling.
    2.  The `xml:lang` attribute is included in *any* word that requires special pronunciation, including names of places and titles of books.

    <div class="corrected">

    ``` html
    She opened the book titled <i epub:type="se:name.publication.book" xml:lang="la">Mortis Imago</i>.
    ```

    </div>

    1.  The `xml:lang` attribute is applied to the highest-level element possible. If italics are required and moving the `xml:lang` attribute would also remove an `<i>` element, the parent element can be styled with `body [xml|lang]{ font-style: italic; }`. This style also requires a namespace declaration at the top of the file: `@namespace xml "http://www.w3.org/XML/1998/namespace";`.

    <div class="wrong">

    ``` html
    <blockquote>
        <p><i xml:lang="es">“¿Cómo estás?”, él preguntó.</i></p>
        <p><i xml:lang="es">“Bien, gracias,” dijo ella.</i></p>
    </blockquote>
    ```

    </div>

    <div class="corrected">

    ``` html
    <blockquote xml:lang="es">
        <p>“¿Cómo estás?”, él preguntó.</p>
        <p>“Bien, gracias,” dijo ella.</p>
    </blockquote>
    ```

    </div>

## The `<title>` element

1.  The `<title>` element contains an appropriate description of the local file only. It does not contain the book title.
2.  The value of the title element is determined by the algorithm used to determine the file's ToC entry, except that no XHTML tags are allowed in the `<title>` element.

## Headers

1.  `<header>` elements have at least one direct child block-level element. This is usually a `<p>` element, but not necessarily.

## Ordered/numbered and unordered lists

1.  All `<li>` children of `<ol>` and `<ul>` elements have at least one direct child block-level element. This is usually a `<p>` element, but not necessarily; for example, a `<blockquote>` element might also be appropriate.

    <div class="wrong">

    ``` html
    <ul>
        <li>Don’t forget to feed the pigs.</li>
    </ul>
    ```

    </div>

    <div class="corrected">

    ``` html
    <ul>
        <li>
            <p>Don’t forget to feed the pigs.</p>
        </li>
    </ul>
    ```

    </div>

## Tables

Tables can often be difficult to represent semantically. For understanding the high-level concepts of tables and the semantic meaning of the various table-related elements, refer to the [HTML Living Standard section on tables](https://html.spec.whatwg.org/multipage/tables.html). For detailed examples on how to represent complex tables in a semantic and accessible way, refer to the [Web Accessibility Initiative guide on creating accessible tables](https://www.w3.org/WAI/tutorials/tables/).

1.  `<table>` elements have a direct child `<tbody>` element.

    <div class="wrong">

    ``` html
    <table>
        <tr>
            <td>1</td>
            <td>2</td>
        </tr>
    </table>
    ```

    </div>

    <div class="corrected">

    ``` html
    <table>
        <tbody>
            <tr>
                <td>1</td>
                <td>2</td>
            </tr>
        </tbody>
    </table>
    ```

    </div>

    1.  More than one `<tbody>` element may be included if a table has additional headers in the middle of the table body.

        ``` html
        <table>
            <tbody>
                <tr>
                    <th colspan="2" scope="rowgroup">Breakfast:</th>
                </tr>
                <tr>
                    <td>1 <abbr>pt.</abbr> milk</td>
                    <td>.05</td>
                </tr>
                <tr>
                    <td>Cereal</td>
                    <td>.01</td>
                </tr>
                <tr>
                    <td>Fruit</td>
                    <td>.02</td>
                </tr>
            </tbody>
            <tbody>
                <tr>
                    <th colspan="2" scope="rowgroup">Late Supper:</th>
                </tr>
                <tr>
                    <td>Soup (potato, pea, bean)</td>
                    <td>.02</td>
                </tr>
                <tr>
                    <td>Rolls</td>
                    <td>.02</td>
                </tr>
            </tbody>
            <tfoot>
                <tr>
                    <th scope="row">Total:</th>
                    <td>.12</td>
                </tr>
            </tfoot>
        </table>
        ```

2.  `<table>` elements may have an optional direct child `<thead>` element, if a table heading is desired.

    1.  `<th>` elements are used in `<thead>` elements, instead of `<td>`.
    2.  `<th>` elements only appear in `<thead>` elements, unless they contain the `scope` attribute. The `scope` attribute may be used to semantically identify a table header which applies to a horizontal row instead of a vertical column, or to a row group in a table with multiple `<tbody>` elements.

3.  `<table>` elements that display a total or summary row at the bottom have that row contained in a `<tfoot>` element.

4.  `<table>` elements that are not used to format plays/dramas, and that do not otherwise inherit a visible margin (for example, they are not children of `<blockquote>`), have `margin: 1em;` (if the table is wide enough to extend to the full width of the page) or `margin: 1em auto;` (if it is not).

## Blockquotes

- [See here for poetry](/manual/VERSION/7-high-level-structural-patterns#7.5).
- [See here for letters](/manual/VERSION/7-high-level-structural-patterns#7.7).

1.  `<blockquote>` elements must contain at least one block-level child, like `<p>`.

2.  Blockquotes that have a citation include the citation as a direct child `<cite>` element.

    ``` html
    <blockquote>
        <p>“All things are ready, if our mind be so.”</p>
        <cite>—<i epub:type="se:name.publication.play">Henry <span epub:type="z3998:roman">V</span></i></cite>
    </blockquote>
    ```

## Definition lists

Definition lists, i.e. combinations of the `<dl>`, `<dt>`, and `<dd>` elements, are often found in glossaries.

[See here for glossaries](/manual/VERSION/7-high-level-structural-patterns#7.11).

1.  `<dd>` elements have at least one direct child block-level element. This is usually a `<p>` element, but not necessarily.

## CSS rules

- When targeting the entire contents of an element, and not a substring within it, then CSS is applied to the whole element instead of adding a new child element.

  > <div class="wrong">
  >
  > ``` html
  > <blockquote>
  >     <p>
  >         <b>It’s me Piglet, Help Help.</b>
  >     </p>
  > </blockquote>
  > ```
  >
  > </div>
  >
  > <div class="corrected">
  >
  > ``` css
  > #chapter-9 blockquote{
  >     font-variant: small-caps;
  > }
  > ```
  >
  > ``` html
  > <blockquote>
  >     <p>It’s me Piglet, Help Help.</p>
  > </blockquote>
  > ```
  >
  > </div>

- When formatting needs to be applied to only a substring or portion of an element, and an element with the required formatting is available, then that element is used instead of `<span>` with CSS.

  > <div class="wrong">
  >
  > ``` css
  > [epub|type~="z3998:salutation"]{
  >     font-variant: small-caps;
  > }
  > ```
  >
  > ``` html
  > <p><span epub:type="z3998:salutation">Dear Poirot</span>, I think I'm on the track of Number Four.</p>
  > ```
  >
  > </div>
  >
  > <div class="corrected">
  >
  > ``` html
  > <p><b epub:type="z3998:salutation">Dear Poirot</b>, I think I'm on the track of Number Four.</p>
  > ```
  >
  > </div>

- `text-align: initial;` is used instead of `text-align: left;` whenever it's necessary to explicitly set left-aligned text. This allows the reading system to opt to use `text-align: justify;` if the user prefers.

- The `vh` unit is used instead of percent units when specifying `height`, `max-height`, `top`, or `bottom`.

  > <div class="wrong">
  >
  > ``` css
  > figure{
  >     height: 100%;
  >     position: absolute;
  >     top: 5%;
  > }
  > ```
  >
  > </div>
  >
  > <div class="corrected">
  >
  > ``` css
  > figure{
  >     height: 100vh;
  >     position: absolute;
  >     top: 5vh;
  > }
  > ```
  >
  > </div>
