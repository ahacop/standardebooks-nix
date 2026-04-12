# Filesystem Layout and File Naming Conventions

A bare Standard Ebooks directory structure looks like this:

<figure>
<img src="/images/epub-draft-tree.png" alt="/images/epub-draft-tree.png" />
</figure>

## File locations

1.  XHTML files containing the actual text of the ebook are located in `./src/epub/text/`. All files in this directory end in `.xhtml`.
2.  CSS files used in the ebook are located in `./src/epub/css/`. All files in this directory end in `.css`. This directory contains only three CSS files:
    1.  `./src/epub/css/core.css` is distributed with all ebooks and is not edited.
    2.  `./src/epub/css/se.css` is also distributed with all ebooks and is not edited.
    3.  `./src/epub/css/local.css` is used for custom CSS local to the particular ebook.
3.  Raw source images used in the ebook, but not distributed with the ebook, are located in `./images/`. These images may be, for example, very high resolution that are later converted to lower resolution for distribution, or raw bitmaps that are later converted to SVG for distribution. Every ebook contains the following images in this directory:
    1.  `./images/titlepage.svg` is the editable titlepage file that is later compiled for distribution.
    2.  `./images/cover.svg` is the editable cover file that is later compiled for distribution.
    3.  `./images/cover.source.(jpg|png|bmp|tif)` is the raw cover art file that may be cropped, resized, or otherwise edited to create `./images/cover.jpg`.
    4.  `./images/cover.jpg` is the final edited cover art that will be compiled into `./src/epub/images/cover.svg` for distribution.
4.  Images compiled or derived from raw source images, that are then distributed with the ebook, are located in `./src/epub/images/`.
5.  The table of contents is located in `./src/epub/toc.xhtml`.
6.  The epub metadata file is located in `./src/epub/content.opf`.
7.  The ONIX metadata file is located in `./src/epub/onix.xml`. This file is identical for all ebooks.
8.  The `./src/META-INF/` and `./src/mimetype` directory and files are epub structural files that are identical for all ebooks.
9.  The `./LICENSE.md` contains the ebook license and is identical for all ebooks.

## XHTML file naming conventions

1.  Numbers in filenames don’t include leading `0`s.

2.  Files containing a short story, essay, or other short work in a larger collection, are named with the URL-safe title of the work, excluding any subtitles. Works that are a single part (such as a one-act play) likewise have their one bodymatter file named as such.

    | Work | Filename |
    |----|----|
    | A short story named “The Variable Man” | `the-variable-man.xhtml` |
    | A short story named “The Sayings of Limpang-Tung (The God of Mirth and of Melodious Minstrels)” | `the-sayings-of-limpang-tung.xhtml` |
    | A one-act play named "The Libation Bearers" | `the-libation-bearers.xhtml` |

3.  Works that are divided into larger parts (sometimes called “parts,” “books,” “volumes,” “sections,” etc.) have their part divisions contained in individual files named after the type of part, followed by a number starting at `1`.

    <div class="text corrected">

    `book-1.xhtml`

    `book-2.xhtml`

    `part-1.xhtml`

    `part-2.xhtml`

    </div>

4.  Works that are composed of chapters, short stories, essays, or other short- to medium-length sections have each of those sections in an individual file.

    1.  Chapters *not* contained in separate volumes are named `chapter-N.xhtml`, where `N` is the chapter number starting at `1`.

        | Section   | Filename          |
        |-----------|-------------------|
        | Chapter 1 | `chapter-1.xhtml` |
        | Chapter 2 | `chapter-2.xhtml` |

    2.  Chapters contained in separate volumes, where the chapter number re-starts at 1 in each volume, are named `chapter-X-N.xhtml`, where `X` is the part number starting at `1`, and `N` is the chapter number *within the part*, starting at `1`.

        | Section          | Filename            |
        |------------------|---------------------|
        | Part 1           | `part-1.xhtml`      |
        | Part 1 Chapter 1 | `chapter-1-1.xhtml` |
        | Part 1 Chapter 2 | `chapter-1-2.xhtml` |
        | Part 1 Chapter 3 | `chapter-1-3.xhtml` |
        | Part 2           | `part-2.xhtml`      |
        | Part 2 Chapter 1 | `chapter-2-1.xhtml` |
        | Part 2 Chapter 2 | `chapter-2-2.xhtml` |

    3.  Chapters contained in separate volumes, where the chapter number does not re-start at 1 in each volume, are named `chapter-N.xhtml`, where `N` is the chapter number, starting at `1`.

        | Section   | Filename          |
        |-----------|-------------------|
        | Part 1    | `part-1.xhtml`    |
        | Chapter 1 | `chapter-1.xhtml` |
        | Chapter 2 | `chapter-2.xhtml` |
        | Chapter 3 | `chapter-3.xhtml` |
        | Part 2    | `part-2.xhtml`    |
        | Chapter 4 | `chapter-4.xhtml` |
        | Chapter 5 | `chapter-5.xhtml` |

    4.  Works that are composed of extremely short sections, like a volume of short poems, are in a single file containing all of those short sections. The filename is the URL-safe name of the work.

        | Section                                        | Filename                |
        |------------------------------------------------|-------------------------|
        | A book of short poems called “North of Boston” | `north-of-boston.xhtml` |

    5.  Frontmatter and backmatter sections have filenames that are named after the type of section, regardless of what the actual title of the section is.

        | Section                                 | Filename        |
        |-----------------------------------------|-----------------|
        | A preface titled “Note from the author” | `preface.xhtml` |

    6.  If a work contains more than one section of the same type (for example multiple prefaces), the filename is followed by `-N`, where `N` is a number representing the order of the section, starting at `1`.

        | Section | Filename |
        |----|----|
        | The work’s first preface, titled “Preface to the 1850 Edition” | `preface-1.xhtml` |
        | The work’s second preface, titled “Preface to the Charles Dickens Edition” | `preface-2.xhtml` |

5.  If a work contains images other than the cover art, the filename of each image should be `illustration-` followed by `-N`, where `N` is a number representing the image’s order of appearance in the work, starting at `1`.

## The `se-lint-ignore.xml` file

The `se lint` tool makes best guesses to alert the user to potential issues in an ebook production, and it may sometimes guess wrong. An `se-lint-ignore.xml` file can be placed in the ebook root to make `se lint` ignore specific error numbers in an ebook.

1.  `se-lint-ignore.xml` is optional. If it exists, it is in the ebook root.

2.  An empty `se-lint-ignore.xml` file looks like this:

    ``` html
    <?xml version="1.0" encoding="utf-8"?>
    <se-lint-ignore>
    </se-lint-ignore>
    ```

3.  The `<se-lint-ignore>` root element contains one or more `<file>` elements.

    1.  `<file>` elements have a `path` attribute containing a filename to match relative to the repository root.

        ``` html
        <file path="chapter-3-1-11.xhtml">
        </file>
        ```

    2.  `path` attributes accept shell-style globbing to match files.

        ``` html
        <file path="chapter-*.xhtml">
        </file>
        ```

    3.  Each `<file>` element contains one or more `<ignore>` elements.

        1.  `<ignore>` elements have a `<code>` attribute containing the lint code to ignore. This code will be ignored for its parent file(s) when `se lint` is next run.
        2.  `<ignore>` elements may contain zero or more `<line>` elements whose text is the line number to ignore for the given code.
        3.  `<ignore>` elements have one `<reason>` element whose text is a prose explanation about why the code was ignored. This aids future producers or reviewers in understanding the reasoning behind why an error code was ignored.

### Example

``` xml
<?xml version="1.0" encoding="utf-8"?>
<se-lint-ignore>
    <file path="introduction.xhtml">
        <ignore code="t-002">
            <reason>Punctuation is deliberately placed outside of quotes in this ebook to prevent confusion with mathematical symbols and formulas.</reason>
        </ignore>
    </file>
    <file path="tractatus-logico-philosophicus.xhtml">
        <ignore code="s-021">
            <reason>The &lt;title&gt; tag is accurate; the work title appears in the half title.</reason>
        </ignore>
        <ignore code="t-002">
            <line>3</line>
            <line>18</line>
            <reason>Punctuation is deliberately placed outside of quotes in this ebook to prevent confusion with mathematical symbols and formulas.</reason>
        </ignore>
    </file>
</se-lint-ignore>
```
