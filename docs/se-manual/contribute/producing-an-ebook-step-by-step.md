
# Producing an Ebook, Step by Step

This guide is meant to take you step-by-step through the creation of a complete Standard Ebook. While it might seem a little long, most of the text is a description of how to use various automated scripts. It can take just an hour or two for an experienced producer to produce a draft ebook for proofreading (depending on the complexity of the ebook, of course).

Our toolset is GNU/Linux-based, and producing an ebook from scratch currently requires working knowledge of the epub file format and of Unix-like systems like Mac or Linux.

Our toolset doesn’t yet work natively on Windows, but there are [many ways to run Linux from within Windows](https://www.howtogeek.com/170870/5-ways-to-run-linux-software-on-windows/), including [one that is directly supported by Microsoft themselves](https://learn.microsoft.com/en-us/windows/wsl/install).

If you don’t have this kind of technical expertise, you can still contribute! [Check out our contributors page for details,](/contribute) or check out [Standard Ebooks Hints and Tricks](https://b-t-k.github.io/), a beginner’s guide by one of our editors.

Before you begin

We use Git to store the production and editorial history of all of our ebooks.

Maintaining a clean and orderly Git history is very important to the final ebook. You should commit early and often.

A single commit should only contain a single logical unit of work, like `Typogrified text` or `Fixed transcription typos`. Don’t cram a lot of different changes into a single commit because you forgot to commit early and often.

In particular, commits that contain editorial changes to the source text, like spelling changes, must have their commit message prefaced with `[Editorial]` and must not contain any non-editorial changes.

**Do not mix editorial and non-editorial changes in a single commit.** Commits are easy and free—it’s perfectly acceptable to have many very small commits, as long as each one is a single logical unit of work and doesn’t mix editorial and non-editorial changes.

If you commingle editorial changes with other changes in your commits, we’ll be forced to ask you to rebase your repository to tease them out. This is very difficult and you’ll get frustrated—so please make sure to keep editorial commits separate!

If your working directory contains a mix of changes and you only want to commit some of them, **`git`**` add --patch` is a [useful way to only commit parts of a file](http://git-scm.com/docs/git-add#Documentation/git-add.txt--p).

Table of Contents

1.  [Set up the Standard Ebooks toolset and make sure it’s up-to-date](#setup)

2.  [Select an ebook to produce](#select)

3.  [Locate page scans of your book online](#locate)

4.  [Contact the mailing list to pitch your production](#pitch)

5.  [Create a Standard Ebooks epub skeleton](#create)

6.  [Do a rough cleanup of the source text and perform the first commit](#rough)

7.  [Split the source text at logical divisions](#split)

8.  [Clean up the source text and perform the second commit](#clean)

9.  [Typogrify the source text and perform the corresponding commit(s)](#typogrify)

10. [Check for transcription errors](#transcription)

11. [Convert footnotes to endnotes](#footnotes)

12. [Add a list of illustrations](#illustrations)

13. [Convert British quotation to American quotation](#quotation)

14. [Add semantics](#semantics)

15. [Modernize spelling and hyphenation](#modernize)

16. [Check for consistent diacritics](#diacritics)

17. [Check for consistent dashes](#dashes)

18. [Set <span class="p">`<`</span><span class="nt">`title`</span><span class="p">`>`</span> elements](#titles)

19. [Build the manifest and spine](#manispine)

20. [Build the table of contents](#build-toc)

21. [Clean and lint](#lint)

22. [Build and proofread, proofread, proofread!](#proofread)

23. [Create the cover image](#cover)

24. [Complete content.opf](#content)

25. [Complete the imprint and colophon](#colophon)

26. [Final checks](#checks)

27. [Initial publication](#publication)

<!-- -->

1.  ## Set up the Standard Ebooks toolset and make sure it’s up-to-date

    Standard Ebooks has a toolset that will help you produce an ebook. The toolset installs the **`se`** command, which has various subcommands related to creating Standard Ebooks. You can [read the complete installation instructions](/tools), or if you already have [**`pipx`** installed](https://pipxproject.github.io/pipx/installation/), run:

    **`pipx`**` install standardebooks`

    The toolset changes frequently, so if you’ve installed the toolset in the past, make sure to update the toolset before you start a new ebook:

    **`pipx`**` upgrade standardebooks`

    Once the toolset is installed, you can check which version you have with:

    **`se`**` --version`

2.  ## Select an ebook to produce

    The best place to look for public domain ebooks to produce is [Project Gutenberg](https://www.gutenberg.org). If downloading from Project Gutenberg, be careful of the following:

    - There may be different versions of the same publication on Gutenberg, and *the best one might not be the one with the most downloads*. In particular, there could be a better translation that has fewer downloads because it was produced later, or there could be a version with better HTML markup. For example, [the version of *Journey to the Center of the Earth* with the most downloads](https://www.gutenberg.org/ebooks/18857) is a less accurate translation than its [less-frequently downloaded counterpart](https://www.gutenberg.org/ebooks/3748). However, you must verify that whichever version you ultimately select is not copyrighted. For example, [this modern translation of *Twenty Thousand Leagues Under the Seas*](https://www.gutenberg.org/ebooks/2488) compares favorably to the most-downloaded [older translation](https://www.gutenberg.org/ebooks/164), but because the modern translation is copyrighted (see the disclaimer at the top of the HTML file) it is ineligible to be the basis of a Standard Ebooks production.

    - Gutenberg usually offers both an HTML version and an epub version of the same ebook. Note that *one is not always exactly the same as the other!* A casual reader might assume that the HTML version is generated from the epub version, or the other way around; but for some reason the HTML and epub versions often differ in important ways, with the HTML version typically using fewer useless CSS classes, and including <span class="p">`<`</span><span class="nt">`em`</span><span class="p">`>`</span> elements that the epub version is often missing.

    Picking either the HTML or the epub version is fine as a starting point, but make sure to pick the one that appears to be the most accurate.

    For this guide, we’ll use *The Strange Case of Dr. Jekyll and Mr. Hyde*, by Robert Louis Stevenson. If you search for it on Gutenberg, you’ll find that there are two versions; we will use [this](https://www.gutenberg.org/ebooks/43) one rather than [this](https://www.gutenberg.org/ebooks/42) one, as it is a cleaner transcription, e.g. has more modern usage of punctuation and compound words, etc.

3.  ## Locate page scans of your book online

    As you produce your book, you’ll want to check your work against the actual page scans. Often the scans contain formatting that is missing from the source transcription. For example, older transcriptions sometimes throw away italics entirely, and you’d never know unless you looked at the page scans. So finding page scans is essential.

    Below are the three big resources for page scans. You should prefer them in this order:

    - [The Internet Archive](https://archive.org)

    - [The HathiTrust Digital Library](https://www.hathitrust.org)

    - [Google Books](https://books.google.com)

    Internet Archive has the widest amount of scans, with the most permissive viewing and lending policy. HathiTrust has many of the same scans as Google Books, but with a more permissive viewing policy. Google Books restricts readers based on IP address and does a poor job of implementing per-country copyright law, so people outside of the U.S. may not be able to access scans of books that are in the public domain of their country.

    Each of those sources allows you to filter results by publication date, so make sure you select a maximum publication date of December 31, 1930 (in other words, everything published before January 1, 1931) to ensure they’re in the U.S. public domain.

    Please keep the following important notes in mind when searching for page scans:

    - Make sure the scans you find are *published before January 1, 1931.* You *must verify the copyright page in the page scans* before proceeding.

    - Often you’ll find different editions, published at different times by different publishers, for the same book. It’s worth the effort to quickly browse through each different one to get an idea of the kinds of changes the different publishers introduced. Maybe one edition is better than another!

    You’ll enter a link to the page scans you used in the `content.opf` metadata as a <span class="p">`<`</span><span class="nt">`dc:source`</span><span class="p">`>`</span> element.

4.  ## Contact the mailing list to pitch your production

    If you’re looking to submit your ebook to Standard Ebooks, contact the [mailing list](https://groups.google.com/g/standardebooks) to pitch the ebook you’ve selected, *before you begin production*. Include links to the transcription and scans you found. If you are producing this ebook for yourself, not for release at Standard Ebooks, you can skip this step.

5.  ## Create a Standard Ebooks epub skeleton

    An epub file is just a bunch of files arranged in a particular folder structure, then all zipped up. That means editing an epub file is as easy as editing a bunch of text files within a certain folder structure, then creating a zip file out of that folder.

    You can’t just arrange files willy-nilly, though—the epub standard expects certain files in certain places. So once you’ve picked a book to produce, create the basic epub skeleton in a working directory. **`se`**` create-draft` will create a basic Standard Ebooks epub folder structure, initialize a Git repository within it, and prefill a few fields in `content.opf` (the file that contains the ebook’s metadata).

    1.  ### With the `--pg-id` option

        You can pass **`se`**` create-draft` the ID of the Project Gutenberg ebook, and it’ll try to download the ebook into `./src/epub/text/body.xhtml` and prefill a lot of metadata for you:

        **`se`**` create-draft --author `*`"Robert Louis Stevenson"`*` --title `*`"The Strange Case of Dr. Jekyll and Mr. Hyde"`*` --pg-id `*`43`*` `**`cd`**` `<u>`robert-louis-stevenson_the-strange-case-of-dr-jekyll-and-mr-hyde/`</u>

        If the book you’re working on was translated into English from another language, you’ll need to include the translator as well, using the `--translator` argument. (For translated books that don’t have a translator credited, you can use the name of the publisher for this argument.)

        **`se`**` create-draft --author `*`"Leo Tolstoy"`*` --translator `*`"Louise Maude"`*` --title `*`"Resurrection"`*` --pg-id `*`1938`*` `**`cd`**` `<u>`leo-tolstoy_resurrection_louise-maude/`</u>

        In the unusual case that your book has *multiple* translators, you will include each one by putting each translator’s name in quotation marks after the `--translator` argument, like so:

        **`se`**` create-draft --author `*`"Leo Tolstoy"`*` --translator `*`"Louise Maude"`*` `*`"Aylmer Maude"`*` --title `*`"The Power of Darkness"`*` --pg-id `*`26661`*` `**`cd`**` `<u>`leo-tolstoy_the-power-of-darkness_louise-maude_aylmer-maude/`</u>

        Because Project Gutenberg ebooks are produced in different ways by different people, **`se`**` create-draft` has to make some guesses and it might guess wrong. Make sure to carefully review the data it prefills into `./src/epub/text/body.xhtml`, `./src/epub/text/colophon.xhtml`, and `./src/epub/content.opf`.

        In particular, make sure that the Project Gutenberg license is stripped from `./src/epub/text/body.xhtml`, and that the original transcribers in `./src/epub/text/colophon.xhtml` and `./src/epub/content.opf` are presented correctly.

    2.  ### Without the `--pg-id` option

        If you prefer to do things by hand, that’s an option too.

        **`se`**` create-draft --author `*`"Robert Louis Stevenson"`*` --title `*`"The Strange Case of Dr. Jekyll and Mr. Hyde"`*` `**`cd`**` `<u>`robert-louis-stevenson_the-strange-case-of-dr-jekyll-and-mr-hyde/`</u>

        Now that we have the skeleton up, we’ll download Gutenberg’s HTML file for *Jekyll* directly into `text/` folder and name it `body.xhtml`.

        **`wget`**` -O src/epub/text/body.xhtml `*`"https://www.gutenberg.org/files/43/43-h/43-h.htm"`*

        Many Gutenberg books were produced before UTF-8 became a standard, so we may have to convert to UTF-8 before we start work. First, check the encoding of the file we just downloaded. (Mac OS users, try **`file`**` -I`.)

        **`file`**` -bi `<u>`src/epub/text/body.xhtml`</u>

        The output is `text/html; charset=iso-8859-1`. That’s the wrong encoding!

        We can convert that to UTF-8 with **`iconv`**:

        **`iconv`**` --from-code `*`"ISO-8859-1"`*` --to-code `*`"UTF-8"`*` < `<u>`src/epub/text/body.xhtml`</u>` > src/epub/text/tmp`` `**`mv`**` `<u>`src/epub/text/tmp`</u>` `<u>`src/epub/text/body.xhtml`</u>

6.  ## Do a rough cleanup of the source text and perform the first commit

    If you inspect the folder we just created, you’ll see it looks something like this:

    <figure>
    <img src="/images/epub-draft-tree.png" alt="A tree view of a new Standard Ebooks draft folder" />
    </figure>

    You can [learn more about what the files in a basic Standard Ebooks source folder are all about](/contribute/a-basic-standard-ebooks-source-folder) before you continue.

    Now that we’ve got the source text, we have to do some very broad cleanup before we perform our first commit:

    - Remove the header markup and everything, including any Gutenberg text and the work title, up to the beginning of the actual public domain text. We’ll add our own header markup to replace what we’ve removed later.

      *Jekyll* doesn’t include front matter like an epigraph or introduction; if it did, that sort of stuff would be left in, since it’s part of the main text.

    - This edition of *Jekyll* includes a table of contents *within the body text*; remove that too. S.E. ebooks place the <span class="abbr initialism">ToC</span> in a separate file outside of the body text, where it can be displayed by the ereader software via UI elements.

    - Remove any footer text (e.g. “The End”), as well as any markup after the public domain text ends. This includes the Gutenberg license—but don’t worry, we’ll credit Gutenberg in the colophon and metadata later. If you invoked **`se`**` create-draft` with the `--pg-id` option, then it may have already stripped the license for you and included some Gutenberg metadata.

    Now our source file looks something like this:

    <figure>
    <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">h2</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> STORY OF THE DOOR </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">h2</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> Mr. Utterson the lawyer was a man of a rugged countenance that was never lighted by a smile; cold, scanty and embarrassed in discourse; backward in </code><span class="c"><code class="sourceCode html"><span class="co">&lt;!--snip all the way to the end...--&gt;</span></code></span><code class="sourceCode html"> proceed to seal up my confession, I bring the life of that unhappy Henry Jekyll to an end. </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>

    Now that we’ve removed all the cruft from the top and bottom of the file, we’re ready for our first commit.

    Each commit has an accompanying message describing the changes we are making. Please use the commit messages as they are written here in this guide as the editors rely on these messages when they review the work.

    Also, try to make one commit per type of change, for example: “fixing typos in chapters 1-18” or “worked on letter formatting.”

    For this first commit:

    **`git`**` add -A`` `**`git`**` commit -m `*`"Initial commit"`*

7.  ## Split the source text at logical divisions

    The file we downloaded contains the entire work. *Jekyll* is a short work, but for longer work it quickly becomes impractical to have the entire text in one file. Not only is it a pain to edit, but ereaders often have trouble with extremely large files.

    The next step is to split the file at logical places; that usually means at each chapter break. For works that contain their chapters in larger “parts,” the part division should also be its own file. For example, see *[Treasure Island](/ebooks/robert-louis-stevenson/treasure-island)*.

    To split the work, we use **`se`**` split-file`. **`se`**` split-file` takes a single file and breaks it in to a new file every time it encounters the markup <span class="c">`<!--se:split-->`</span>. **`se`**` split-file` automatically includes basic header and footer markup in each split file. If a book includes any front matter, like a dedication or epigraph, this is a good time to save it to its own file, so that `body.xhtml` now begins with the book’s first chapter. **`se`**` add-file` is useful for creating skeleton files for front matter.

    Notice that in our source file, each chapter is marked with an <span class="p">`<`</span><span class="nt">`h2`</span><span class="p">`>`</span> element. We can use that to our advantage and save ourselves the trouble of adding the <span class="c">`<!--se:split-->`</span> markup by hand:

    **`perl`**` -pi -e `*`'s|<h2|<!--se:split--><h2|g'`*` `<u>`src/epub/text/body.xhtml`</u>

    Now that we’ve added our markers, we split the file. **`se`**` split-file` puts the results in our current directory and conveniently names them by chapter number.

    **`se`**` split-file `<u>`src/epub/text/body.xhtml`</u>` `**`mv`**` chapter`*`*`*` `<u>`src/epub/text/`</u>

    Once we’re happy that the source file has been split correctly, we can remove it.

    **`rm`**` `<u>`src/epub/text/body.xhtml`</u>

8.  ## Clean up the source text and perform the second commit

    If you open up any of the chapter files we now have in the `src/epub/text/` folder, you’ll notice that the code isn’t very clean. Paragraphs are split over multiple lines, indentation is all wrong, and so on.

    If you try opening a chapter in a web browser, you’ll also likely get an error if the chapter includes any HTML entities, like `&mdash;`. This is because Gutenberg uses plain HTML, which allows entities, but epub uses XHTML, which doesn’t.

    We can fix all of this pretty quickly using **`se`**` clean`. **`se`**` clean` accepts as its argument the root of a Standard Ebook directory. We’re already in the root, so we pass it `.`.

    **`se`**` clean `<u>`.`</u>

    Finally, we have to do a quick runthrough of each file by hand to cut out any lingering Gutenberg markup that doesn’t belong. In *Jekyll*, notice that each chapter ends with some extra empty <span class="p">`<`</span><span class="nt">`div`</span><span class="p">`>`</span>s and <span class="p">`<`</span><span class="nt">`p`</span><span class="p">`>`</span>s. These were used by the original transcriber to put spaces between the chapters, and they’re not necessary anymore, so remove them before continuing.

    Now our chapter 1 source looks like this:

    <figure>
    <span class="cp"><code class="sourceCode html"><span class="er">&lt;?</span><span class="co">xml version=&quot;1.0&quot; encoding=&quot;utf-8&quot;?&gt;</span></code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">html</code></span><code class="sourceCode html"> </code><span class="na"><code class="sourceCode html">xmlns</code></span><span class="o"><code class="sourceCode html">=</code></span><span class="s"><code class="sourceCode html">&quot;http://www.w3.org/1999/xhtml&quot;</code></span><code class="sourceCode html"> </code><span class="na"><code class="sourceCode html">xmlns:epub</code></span><span class="o"><code class="sourceCode html">=</code></span><span class="s"><code class="sourceCode html">&quot;http://www.idpf.org/2007/ops&quot;</code></span><code class="sourceCode html"> </code><span class="na"><code class="sourceCode html">epub:prefix</code></span><span class="o"><code class="sourceCode html">=</code></span><span class="s"><code class="sourceCode html">&quot;z3998: http://www.daisy.org/z3998/2012/vocab/structure/, se: https://standardebooks.org/vocab/1.0&quot;</code></span><code class="sourceCode html"> </code><span class="na"><code class="sourceCode html">xml:lang</code></span><span class="o"><code class="sourceCode html">=</code></span><span class="s"><code class="sourceCode html">&quot;en-US&quot;</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">head</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">title</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">Chapter 1</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">title</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">link</code></span><code class="sourceCode html"> </code><span class="na"><code class="sourceCode html">href</code></span><span class="o"><code class="sourceCode html">=</code></span><span class="s"><code class="sourceCode html">&quot;../css/core.css&quot;</code></span><code class="sourceCode html"> </code><span class="na"><code class="sourceCode html">rel</code></span><span class="o"><code class="sourceCode html">=</code></span><span class="s"><code class="sourceCode html">&quot;stylesheet&quot;</code></span><code class="sourceCode html"> </code><span class="na"><code class="sourceCode html">type</code></span><span class="o"><code class="sourceCode html">=</code></span><span class="s"><code class="sourceCode html">&quot;text/css&quot;</code></span><span class="p"><code class="sourceCode html">/&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">link</code></span><code class="sourceCode html"> </code><span class="na"><code class="sourceCode html">href</code></span><span class="o"><code class="sourceCode html">=</code></span><span class="s"><code class="sourceCode html">&quot;../css/local.css&quot;</code></span><code class="sourceCode html"> </code><span class="na"><code class="sourceCode html">rel</code></span><span class="o"><code class="sourceCode html">=</code></span><span class="s"><code class="sourceCode html">&quot;stylesheet&quot;</code></span><code class="sourceCode html"> </code><span class="na"><code class="sourceCode html">type</code></span><span class="o"><code class="sourceCode html">=</code></span><span class="s"><code class="sourceCode html">&quot;text/css&quot;</code></span><span class="p"><code class="sourceCode html">/&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">head</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">body</code></span><code class="sourceCode html"> </code><span class="na"><code class="sourceCode html">epub:type</code></span><span class="o"><code class="sourceCode html">=</code></span><span class="s"><code class="sourceCode html">&quot;bodymatter z3998:fiction&quot;</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">section</code></span><code class="sourceCode html"> </code><span class="na"><code class="sourceCode html">id</code></span><span class="o"><code class="sourceCode html">=</code></span><span class="s"><code class="sourceCode html">&quot;chapter-1&quot;</code></span><code class="sourceCode html"> </code><span class="na"><code class="sourceCode html">epub:type</code></span><span class="o"><code class="sourceCode html">=</code></span><span class="s"><code class="sourceCode html">&quot;chapter&quot;</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">h2</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">STORY OF THE DOOR</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">h2</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">Mr. Utterson the lawyer was a man of a rugged countenance...</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="c"><code class="sourceCode html"><span class="co">&lt;!--snip all the way to the end...--&gt;</span></code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">&quot;With all my heart,&quot; said the lawyer. &quot;I shake hands on that, Richard.&quot;</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">section</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">body</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">html</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>

    If you look carefully, you’ll notice that the <span class="p">`<`</span><span class="nt">`html`</span><span class="p">`>`</span> element has the <span class="na">`xml:lang`</span><span class="o">`=`</span><span class="s">`"en-US"`</span> attribute, even though our source text uses British spelling! We have to change the <span class="na">`xml:lang`</span> attribute for the source files to match the actual language, which in this case is en-GB. Let’s do that now:

    **`perl`**` -pi -e `*`"s|en-US|en-GB|g"`*` src/epub/text/chapter`*`*`*

    Note that we *don’t* change the language for the metadata or boilerplate files, like `colophon.xhtml`, `imprint.xhtml`, or `titlepage.xhtml`. Those must always be in American spelling, so they’ll always have the en-US language tag.

    Once the file split and cleanup is complete, you can perform your second commit.

    **`git`**` add -A`` `**`git`**` commit -m `*`"Split files and clean"`*

9.  ## Typogrify the source text and perform the corresponding commit(s)

    Now that we have a clean starting point, we can start getting the *real* work done. **`se`**` typogrify` can do a lot of the heavy lifting necessary to bring an ebook up to Standard Ebooks typography standards.

    Like **`se`**` clean`, **`se`**` typogrify` accepts as its argument the root of a Standard Ebook directory.

    **`se`**` typogrify `<u>`.`</u>

    Among other things, **`se`**` typogrify` does the following:

    - Converts straight quotes to curly quotes;

    - Adds no-break spaces where appropriate for some common abbreviations;

    - Normalizes ellipses;

    - Normalizes spacing in em-, en-, and double-em-dashes, as well as between nested quotation marks, and adds word joiners.

    While **`se`**` typogrify` does a lot of work for you, each ebook is totally different so there’s almost always more work to do that can only be done by hand. However, you will do a third commit first, to put the automated changes in a separate commit from any manual changes.

    **`git`**` add -A`` `**`git`**` commit -m `*`"Typogrify"`*

    As an example of manual changes that might be needed, in *Jekyll*, you’ll notice that the chapter titles are in all caps. The S.E. standard requires chapter titles to be in title case, and **`se`**` titlecase` can do that for us. **`se`**` titlecase` accepts a string as its argument, and outputs the string in title case.

    Many text editors allow you to configure external macros—perfect for creating a keyboard shortcut to run **`se`**` titlecase` on selected text.

    If you do that, you might find its `--no-newline` flag helpful to prevent an extra newline from being inserted into your document.

    ### Typography checklist

    There are many things that **`se`**` typogrify` isn’t well suited to do automatically. Check the [Typography section of the <span class="abbr acronym">SEMoS</span>](/manual/latest/8-typography) to see exactly how to format the work. Below is a brief, but incomplete, list of common issues that arise in ebooks:

    **`se`**` interactive-replace` is a useful tool for quickly performing a regular expression search-and-replace, while reviewing each replacement. To use it, pass it a regex and a replacement. Then for each replacement, press `y` to accept the replacement or `n` to reject it.

    - [Elision](/manual/latest/8-typography#8.7.5.3). `’` (i.e., `&rsquo;`) is used for elided letters in a word. **`se`**` typogrify` often gets this wrong, and you need to review your ebook by hand to ensure it didn’t insert `‘` (`&lsquo;`) instead.

      **`se`**` interactive-replace --ignore-case `*`"(\s)‘([a-z])"`*` `*`"\1’\2"`*` src/epub/text/`*`*`*

    - [Coordinates](/manual/latest/8-typography#8.8.1). Use the prime and double prime glyphs for coordinates.

      **`se`**` interactive-replace `*`"([0-9]+)’"`*` `*`"\1′"`*` src/epub/text/`*`*`* **`se`**` interactive-replace `*`"([0-9]+)”"`*` `*`"\1″"`*` src/epub/text/`*`*`*

    - Sometimes **`se`**` typogrify` doesn’t close quotation marks near em-dashes correctly.

      Use this regex to find incorrectly closed quotation marks near em-dashes: `—[’”][^`<span class="p">`<`</span>`\s]`

    - [Two-em dashes should be used for partially-obscured words](/manual/latest/8-typography#8.7.7.9).

    - Commas and periods should generally be inside quotation marks, not outside. Use this command to find and replace them:

      **`se`**` interactive-replace `*`"([’”])([,.])" "\2\1"`*` src/epub/text/`*`*`*

      When using this command, be careful to distinguish between the use of `’` as a quotation mark and its use in elision or as part of a plural possessive (i.e. `s’`).

      <table>
      <colgroup>
      <col style="width: 50%" />
      <col style="width: 50%" />
      </colgroup>
      <tbody>
      <tr>
      <td><strong>Correct change:</strong></td>
      <td><p><code class="sourceCode html">“Let’s have a game of ‘noses’, lads!”</code> ➔</p>
      <p><code class="sourceCode html">“Let’s have a game of ‘noses,’ lads!”</code></p></td>
      </tr>
      <tr>
      <td><strong>Incorrect change:</strong></td>
      <td><p><code class="sourceCode html">This wood now is not mine, but the peasants’.</code> ➔</p>
      <p><code class="sourceCode html">This wood now is not mine, but the peasants.’</code></p></td>
      </tr>
      </tbody>
      </table>

    - [Non-breaking hyphens are used when a word is stretched out for effect.](/manual/latest/single-page#8.7.7.6)

      Although it will produce a lot of false positives, this regex can help you find stretched words: `(?i)([a-z])-\1`

    ### The fourth commit

    Once you’ve searched the work for the common issues above, if any manual changes were necessary, you should perform the fourth commit.

    **`git`**` add -A`` `**`git`**` commit -m `*`"Manual typography changes"`*

10. ## Check for transcription errors

    Transcriptions often have errors, because the O.C.R. software might confuse letters for other, more unusual characters, or because the ebook’s character set got mangled somewhere along the way from the source to your repository. You’ll find most transcription errors when you proofread the text, but right now you use the **`se`**` find-unusual-characters` tool to see a list of any unusual characters in the transcription. If the tool outputs any, check the source to make sure those characters aren’t errors.

    **`se`**` find-unusual-characters `<u>`.`</u>

    If any errors had to be corrected, a commit is needed as well.

    **`git`**` add -A`` `**`git`**` commit -m `*`"Correct transcription errors"`*

11. ## Convert footnotes to endnotes

    Works often include footnotes, either added by an annotator or as part of the work itself. Since ebooks don’t have a concept of a “page,” there’s no place for footnotes to go. Instead, we convert footnotes to a single endnotes file, which will provide popup references in the final epub.

    The endnotes file and the format for endnote links are [standardized in the <span class="abbr acronym">SEMoS</span>](/manual/latest/7-high-level-structural-patterns#7.10).

    You can add a template of an endnotes file using:

    **`se`**` add-file endnotes `<u>`.`</u>

    If you find that you accidentally mis-ordered an endnote, never fear! **`se`**` shift-endnotes` will allow you to quickly rearrange endnotes in your ebook.

    If any footnotes were present and moved to endnotes, do another commit.

    **`git`**` add -A`` `**`git`**` commit -m `*`"Move footnotes to endnotes"`*

    *Jekyll* doesn’t have any footnotes or endnotes, so we skip this step.

12. ## Add a list of illustrations

    If a work has illustrations besides the cover and title pages, we include a “list of illustrations” at the end of the book, after the endnotes but before the colophon. The <span class="abbr initialism">LoI</span> file [is also standardized](/manual/latest/7-high-level-structural-patterns#7.9).

    You can use the **`se`**` build-loi` tool to automatically add a list of illustrations, but you’ll have to [build the manifest and spine](#manispine) first.

    If you created an LoI, do a corresponding commit.

    **`git`**` add -A`` `**`git`**` commit -m `*`"Add LoI"`*

    *Jekyll* doesn’t have any illustrations, so we skip this step.

13. ## Convert British quotation to American quotation

    If the work you’re producing uses [British quotation style](http://www.thepunctuationguide.com/british-versus-american-style.html) (single quotes for dialog and other outer quotes versus double quotes in American), we have to convert it to American style. We use American style in part because it’s easier to programmatically convert from American to British than it is to convert the other way around. *Skip this step if your work is already in American style.*

    **`se`**` british2american` attempts to automate the conversion. Your work must already be typogrified (one of the previous steps in this guide) for the script to work.

    **`se`**` british2american `<u>`.`</u>

    While **`se`**` british2american` tries its best, thanks to the quirkiness of English punctuation rules it’ll invariably mess some stuff up. Proofreading is required after running the conversion.

    This regex is useful for spotting incorrectly converted quotes next to em dashes: `“[^”‘]+’⁠—`

    After you’ve run the conversion, do another commit.

    **`git`**` commit -am `*`"Convert from British-style quotation to American style"`*

14. ## Add semantics

    Part of producing a book for Standard Ebooks is adding meaningful semantics wherever possible in the text. **`se`**` semanticate` does a little of that for us—for example, for some common abbreviations—but much of it has to be done by hand.

    Adding semantics means two things:

    1.  Using meaningful elements to mark up the work: <span class="p">`<`</span><span class="nt">`em`</span><span class="p">`>`</span> when conveying emphatic speech instead of <span class="p">`<`</span><span class="nt">`i`</span><span class="p">`>`</span>, <span class="p">`<`</span><span class="nt">`abbr`</span><span class="p">`>`</span> to wrap abbreviations, <span class="p">`<`</span><span class="nt">`section`</span><span class="p">`>`</span> to mark structural divisions, using the <span class="na">`xml:lang`</span> attribute to specify the language of a word or passage, and so on.

    2.  Using the [epub3 semantic inflection language](http://www.idpf.org/epub/30/spec/epub30-contentdocs.html#sec-xhtml-semantic-inflection) to add deeper meaning to elements.

        Currently we use a mix of [epub3 structural semantics](http://www.idpf.org/epub/vocab/structure/), [z3998 structural semantics](http://www.daisy.org/z3998/2012/vocab/structure/) for when the epub3 vocabulary isn’t enough, and our own [S.E. semantics](/vocab/1.0) for when z3998 isn’t enough.

    Use **`se`**` semanticate` to do some common cases for you:

    **`se`**` semanticate `<u>`.`</u>

    **`se`**` semanticate` tries its best to correctly add semantics, but sometimes it’s wrong. For that reason you should review the changes it made before accepting them:

    **`git`**` difftool`

    As we did with `typogrify`, we want the automated portion of adding semantics to be in its own commit. After running `semanticate`, do another commit.

    **`git`**` commit -am `*`"Semanticate"`*

    Beyond that, adding semantics is mostly a by-hand process. See the [<span class="abbr acronym">SEMoS</span>](/manual) for a detailed list of the kinds of semantics we expect in a Standard Ebook.

    Here’s a short list of some of the more common semantic issues you’ll encounter:

    - Semantics for italics: <span class="p">`<`</span><span class="nt">`em`</span><span class="p">`>`</span> should be used for when a passage is emphasized, as in when dialog is shouted or whispered. <span class="p">`<`</span><span class="nt">`i`</span><span class="p">`>`</span> is used for all other italics, [with the appropriate semantic inflection](/manual/latest/4-semantics#4.2). Older transcriptions usually use just <span class="p">`<`</span><span class="nt">`i`</span><span class="p">`>`</span> for both, so you must change them manually if necessary.

    - [Semantics rules for chapter titles](/manual/latest/8-typography#8.1).

    - [Semantics rules for abbreviations](/manual/latest/8-typography#8.10). Abbreviations should always be wrapped in the <span class="p">`<`</span><span class="nt">`abbr`</span><span class="p">`>`</span> element and with the correct <span class="na">`epub:type`</span> attribute.

      Specifically, see the [typography rules for initials](/manual/latest/8-typography#8.10.4). Wrap people’s initials in <span class="p">`<`</span><span class="nt">`abbr`</span>` `<span class="na">`epub:type`</span><span class="o">`=`</span><span class="s">`"z3998:given-name"`</span><span class="p">`>`</span>. This command helps wrap initials:

      **`se`**` interactive-replace `*`'(?<!<abbr[^<]*?>)([A-Z]\.(\s?[A-Z]\.)*)(?!</abbr>|”)'`*` `*`'<abbr epub:type="z3998:given-name">\1</abbr>'`*` src/epub/text/`*`*`*

    - [Typography rules for times](/manual/latest/8-typography#8.11). Wrap a.m. and p.m. in <span class="p">`<`</span><span class="nt">`abbr`</span><span class="p">`>`</span> and add a no-break space between digits and a.m. or p.m.

    - Words or phrases in foreign languages should always be marked up with <span class="p">`<`</span><span class="nt">`i`</span>` `<span class="na">`xml:lang`</span><span class="o">`=`</span><span class="s">`"TAG"`</span><span class="p">`>`</span>, where TAG is an [IETF language tag](https://en.wikipedia.org/wiki/IETF_language_tag). [This website can help you look them up](https://r12a.github.io/app-subtags/). If the text uses fictional or unspecific languages, use the `x-` prefix and make up a subtag yourself.

    - Semantics for poetry, verse, and song: Many Gutenberg productions use the <span class="p">`<`</span><span class="nt">`pre`</span><span class="p">`>`</span> element to format poetry, verse, and song. This is, of course, semantically incorrect. [See the Poetry section of the <span class="abbr acronym">SEMoS</span>](/manual/latest/7-high-level-structural-patterns#7.5) for templates on how to semantically format poetry, verse, and song.

    Additionally, after adding semantics, you should check for any remaining typography issues:

    - [Text in all caps](/manual/latest/8-typography#8.3.3). Text in all caps is almost never correct, and should either be converted to lowercase with the <span class="p">`<`</span><span class="nt">`em`</span><span class="p">`>`</span> element (for spoken emphasis), <span class="p">`<`</span><span class="nt">`strong`</span><span class="p">`>`</span> (for extreme spoken emphasis), or <span class="p">`<`</span><span class="nt">`b`</span><span class="p">`>`</span> (for unsemantic small caps, like in storefront signs).

      Use the following command to check for instances of all caps:

      **`se`**` xpath `*`"//p//text()[re:test(., '[A-Z]{2,}') and not(contains(., 'OK') or contains(., 'SOS')) and not(parent::abbr or parent::var or parent::a or parent::*[contains(@epub:type, 'z3998:roman')])]"`*` `<u>`src/epub/text/`*`*`*`.xhtml`</u>

    After you’ve added semantics according to the [<span class="abbr acronym">SEMoS</span>](/manual), do another commit.

    **`git`**` commit -am `*`"Manually add additional semantics"`*

15. ## Modernize spelling and hyphenation

    Many older works use outdated spelling and hyphenation that would distract a modern reader. (For example, `to-night` instead of `tonight`). **`se`**` modernize-spelling` automatically removes hyphens from words that used to be compounded, but aren’t anymore in modern English spelling.

    *Do* run this tool on prose. *Don’t* run this tool on poetry.

    **`se`**` modernize-spelling `<u>`.`</u>

    After you run the tool, *you must check what the tool did to confirm that each removed hyphen is correct*. Sometimes the tool will remove a hyphen that needs to be included for clarity, or one that changes the meaning of the word, or it may result in a word that just doesn’t seem right. Re-introducing a hyphen is OK in these cases.

    Here’s a real-world example of where **`se`**` modernize-spelling` made the wrong choice: In *[The Picture of Dorian Gray](/ebooks/oscar-wilde/the-picture-of-dorian-gray)* [chapter 11](/ebooks/oscar-wilde/the-picture-of-dorian-gray/text/chapter-11), Oscar Wilde writes:

    > He possessed a gorgeous cope of crimson silk and gold-thread damask…

    **`se`**` modernize-spelling` would replace the dash in `gold-thread` so that it reads `goldthread`. Well `goldthread` is an actual word, which is why it’s in our dictionary, and why the script makes a replacement—but it’s the name of a type of flower, *not* a golden fabric thread! In this case, **`se`**` modernize-spelling` made an incorrect replacement, and we have to change it back.

    **`git`** compares changes line-by-line, but since lines in an ebook can be very long, a line-level comparison can make spotting small changes difficult. Instead of just doing **`git`**` diff`, try the following command to highlight changes at the character level:

    **`git`**` -c color.ui=always diff -U0 --word-diff-regex=.`

    You can also [enable color in your **`git`** output globally](https://stackoverflow.com/questions/10998792/how-to-color-the-git-console), or assign this command to a shortcut in your **`git`** configuration.

    Alternatively, you can use an external diff GUI to review changes in closer detail:

    **`git`**` difftool`

    ### Modernize spacing in select words

    Over time, spelling of certain common two-word phrases has evolved into a single word. For example, `someone` used to be the two-word phrase `some one`, which would read awkwardly to modern readers. This is our chance to modernize such phrases.

    Note that we use **`se`**` interactive-replace` to perform an interactive search and replace, instead of doing a global, non-interactive search and replace. This is because some phrases caught by the regular expression should not be changed, depending on context. For example, `some one` in the following snippet from [Anton Chekhov’s short fiction](/ebooks/anton-chekhov/short-fiction/constance-garnett) *should not* be corrected:

    > He wanted to think of some one part of nature as yet untouched...

    Use each of the following commands to correct a certain set of such phrases:

    - ### some one ➔ someone

      <table>
      <colgroup>
      <col style="width: 50%" />
      <col style="width: 50%" />
      </colgroup>
      <tbody>
      <tr>
      <td>Correct change:</td>
      <td><p><code class="sourceCode html">She asked some one on the street.</code> ➔</p>
      <p><code class="sourceCode html">She asked someone on the street.</code></p></td>
      </tr>
      <tr>
      <td>Incorrect change:</td>
      <td><p><code class="sourceCode html">But every clever crime is founded ultimately on some one quite simple fact.</code> ➔</p>
      <p><span class="wrong"><code class="sourceCode html">But every clever crime is founded ultimately on someone quite simple fact.</code></span></p></td>
      </tr>
      </tbody>
      </table>

      **`se`**` interactive-replace `*`"\b([Ss])ome one" "\1omeone"`*` src/epub/text/`*`*`*

    - ### any one ➔ anyone

      <table>
      <colgroup>
      <col style="width: 50%" />
      <col style="width: 50%" />
      </colgroup>
      <tbody>
      <tr>
      <td>Correct change:</td>
      <td><p><code class="sourceCode html">“Any one else on this floor?” he asked.</code> ➔</p>
      <p><code class="sourceCode html">“Anyone else on this floor?” he asked.</code></p></td>
      </tr>
      <tr>
      <td>Incorrect change:</td>
      <td><p><code class="sourceCode html">It is not easy to restore lost property to any one of them.</code> ➔</p>
      <p><span class="wrong"><code class="sourceCode html">It is not easy to restore lost property to anyone of them.</code></span></p></td>
      </tr>
      </tbody>
      </table>

      **`se`**` interactive-replace `*`"\b([Aa])ny one" "\1nyone"`*` src/epub/text/`*`*`*

    - ### every one ➔ everyone

      <table>
      <colgroup>
      <col style="width: 50%" />
      <col style="width: 50%" />
      </colgroup>
      <tbody>
      <tr>
      <td>Correct change:</td>
      <td><p><code class="sourceCode html">He was furious</code><span class="ws"><code class="sourceCode html">wj</code></span><code class="sourceCode html">—furious with himself, furious with every one.</code> ➔</p>
      <p><code class="sourceCode html">He was furious</code><span class="ws"><code class="sourceCode html">wj</code></span><code class="sourceCode html">—furious with himself, furious with everyone.</code></p></td>
      </tr>
      <tr>
      <td>Incorrect change:</td>
      <td><p><code class="sourceCode html">I’m sure we missed ten for every one we saw.</code> ➔</p>
      <p><span class="wrong"><code class="sourceCode html">I’m sure we missed ten for everyone we saw.</code></span></p></td>
      </tr>
      </tbody>
      </table>

      **`se`**` interactive-replace `*`'(?<![Ee]ach and )([Ee])very one(?!\s+of)' "\1veryone"`*` src/epub/text/`*`*`*

    - ### any way ➔ anyway

      <table>
      <colgroup>
      <col style="width: 50%" />
      <col style="width: 50%" />
      </colgroup>
      <tbody>
      <tr>
      <td>Correct change:</td>
      <td><p><code class="sourceCode html">Not all, of course, but any way it is much better than the life here.</code> ➔</p>
      <p><code class="sourceCode html">Not all, of course, but anyway it is much better than the life here.</code></p></td>
      </tr>
      <tr>
      <td>Incorrect change:</td>
      <td><p><code class="sourceCode html">And I’m not at fault in any way, and there’s no need for me to suffer.</code> ➔</p>
      <p><span class="wrong"><code class="sourceCode html">And I’m not at fault in anyway, and there’s no need for me to suffer.</code></span></p></td>
      </tr>
      </tbody>
      </table>

      **`se`**` interactive-replace `*`'(?<!in\s+)\b([Aa])ny way(?!\s+(?:of|to))' "\1nyway"`*` src/epub/text/`*`*`*

    - ### with out ➔ without

      <table>
      <colgroup>
      <col style="width: 50%" />
      <col style="width: 50%" />
      </colgroup>
      <tbody>
      <tr>
      <td>Correct change:</td>
      <td><p><code class="sourceCode html">Send with out delay warrant of arrest to Bombay.</code> ➔</p>
      <p><code class="sourceCode html">Send without delay warrant of arrest to Bombay.</code></p></td>
      </tr>
      <tr>
      <td>Incorrect change:</td>
      <td><p><code class="sourceCode html">“Who on earth are you talking with out there?” called the querulous voice.</code> ➔</p>
      <p><span class="wrong"><code class="sourceCode html">“Who on earth are you talking without there?” called the querulous voice.</code></span></p></td>
      </tr>
      </tbody>
      </table>

      **`se`**` interactive-replace `*`"\b([Ww])ith out\b([^-])" "\1ithout\2"`*` src/epub/text/`*`*`*

    After you’ve reviewed the changes, create an `[Editorial]` commit. This type of commit is important, because it gives purists an avenue to reverse these changes back to the original text.

    Editorial changes are those where we make an editorial decision to alter the original text, for example modernizing spelling or fixing a probable printer’s typo.

    Fixing a transcriber’s typo—i.e. where the transcriber made a mistake when converting the page scans to digital text—is **not** an editorial change.

    `[Editorial]` commits are an important part of the ebook’s history. They make it easier for reviewers to confirm your work, and they make it easy for readers to see how we may have changed the text.

    You **must** use commits prefaced with `[Editorial]` when you’re making editorial changes to the text. These commits may **only** contain editorial changes and **no other work on the ebook**.

    Commits are easy and free. Don’t worry about making many small commits, if it means that editorial commits are clean and isolated. If you commingle editorial changes with other changes, we’ll have to ask you to rebase your repository to tease them out. This is very difficult—so please make sure to keep editorial commits separate!

    **`git`**` commit -am `*`"[Editorial] Modernize hyphenation and spelling"`*

    ### Manual spelling changes

    You can and should update spelling of other words that you come across during proofreading, with the following caveats:

    - We modernize **sound-alike spelling**, not grammar or word usage. Thus, updating `mak` to `make` is OK, but changing `maketh` to `makes` is not.

    - We usually don’t bother with adding or removing dashes or spaces from compound words, other than what **`se`**` modernize-spelling` does. For example `dining-room` might read more modern with a space, but dashes and spaces are inconsistent over a large number of words and it’s too much work to keep a master list.

    - Don’t change spelling from en-US to en-GB or vice-versa, even to align with a book’s “language.” Having mixed spelling in a book was common and not something we standardize. [This article](https://en.wikipedia.org/wiki/American_and_British_English_spelling_differences) provides a good overview of the differences between British and U.S. English.

    - If, after having run **`se`**` modernize-spelling`, you find a hyphenated compound word that appears in Merriam-Webster's basic online search results without a hyphen, then you can make an Editorial change to update it. Please also let us know so that we can update **`se`**` modernize-spelling`.

    - If you find an archaic word that you think should be modernized, a good way to check is with a [Google Ngram search](https://books.google.com/ngrams/). Remember to select either American English or British English!

    Any manual spelling changes made must be in an `[Editorial]` commit, e.g.

    **`git`**` commit -m `*`"[Editorial] mak -> make"`*

16. ## Check for consistent diacritics

    Sometimes during transcription or even printing, instances of some words might have diacritics while others don’t. For example, a word in one chapter might be spelled `châlet`, but in the next chapter it might be spelled `chalet`.

    **`se`**` find-mismatched-diacritics` lists these instances for you to review. Spelling should be normalized across the work so that all instances of the same word are spelled in the same way. Keep the following in mind as you review these instances:

    - In modern English spelling, many diacritics are removed (like `chalet`). If in doubt, ask your assigned project manager.

    - Even though diacritics might be removed in English spelling, they may be preserved in non-English text, or in proper names.

      > He visited the hotel called the Châlet du Nord.

    **`se`**` find-mismatched-diacritics `<u>`.`</u>

    If any changes had to be made, a corresponding editorial commit should be done as well.

    **`git`**` commit -am `*`"[Editorial] Correct mismatched diacritics"`*

17. ## Check for consistent dashes

    Similar to **`se`**` find-mismatched-diacritics`, **`se`**` find-mismatched-dashes` lists instances where a compound word is spelled both with and without a dash. Dashes in words should be normalized to one or the other style.

    **`se`**` find-mismatched-dashes `<u>`.`</u>

    If corrections were made, another commit is needed.

    **`git`**` commit -am `*`"[Editorial] Correct mismatched dashes"`*

18. ## Set <span class="p">`<`</span><span class="nt">`title`</span><span class="p">`>`</span> elements

    After you’ve added semantics and correctly marked up [section headers](/manual/latest/7-high-level-structural-patterns#7.2), it’s time to update the <span class="p">`<`</span><span class="nt">`title`</span><span class="p">`>`</span> elements in each chapter to match [their expected values](/manual/latest/5-general-xhtml-and-css-patterns#5.4).

    The **`se`**` build-title` tool takes a well-marked-up section header from a file, and updates the file’s <span class="p">`<`</span><span class="nt">`title`</span><span class="p">`>`</span> element to match:

    **`se`**` build-title `<u>`.`</u>

    Once you’ve verified the titles look good, commit:

    **`git`**` commit -am `*`"Add titles"`*

19. ## Build the manifest and spine

    In `content.opf`, the manifest is a list of all of the files in the ebook. The spine is the reading order of the various XHTML files.

    **`se`**` build-manifest` and **`se`**` build-spine` will create these for you. Run these on our source directory and they’ll update the <span class="p">`<`</span><span class="nt">`manifest`</span><span class="p">`>`</span> and <span class="p">`<`</span><span class="nt">`spine`</span><span class="p">`>`</span> elements in `content.opf`.

    If you’re using a Mac and its badly-behaved Finder program, you may find that it has carelessly polluted your work directory with `.DS_Store` files. Before continuing, you should [find a better file manager program](https://duckduckgo.com/?q=mac+alternative+file+manager), then delete all of that litter. Otherwise, **`se`**` build-manifest` and **`se`**` build-spine` will include that litter in their output, and your epub won’t be valid.

    Use this command to delete all of them in one go:

    **`find`**` `<u>`.`</u>` -name `*`".DS_Store"`*` -type f -delete`

    Since this is the first time we’re editing `content.opf`, we’re OK with replacing both the manifest and spine elements with a guess at the correct contents.

    ` `**`se`**` build-manifest `<u>`.`</u>` `**`se`**` build-spine `<u>`.`</u>` `

    The manifest is already in the correct order and doesn’t need to be edited. The spine, however, will have to be reordered to be in the correct reading order. Once you’ve done that, commit!

    **`git`**` commit -am `*`"Add manifest and spine"`*

20. ## Build the table of contents

    With the spine in the right order, we can now build the table of contents.

    The table of contents is a structured document that lets the reader easily navigate the book. In a Standard Ebook, it’s stored outside of the readable text directory with the assumption that the reading system will parse it and display a navigable representation for the user.

    Use **`se`**` build-toc` to generate a table of contents for this ebook.

    **`se`**` build-toc `<u>`.`</u>

    Review the generated ToC in `./src/epub/toc.xhtml` to make sure **`se`**` build-toc` did the right thing. **`se`**` build-toc` is a valuable tool to discover structural problems in your ebook. If an entry is arranged in a way you weren’t expecting, perhaps the problem isn’t with **`se`**` build-toc`, but with your XHTML code—be careful!

    It’s very rare that **`se`**` build-toc` makes an error given a correct ebook structure, but if it does, you may have to make changes to the table of contents by hand.

    Once you’re done, commit:

    **`git`**` commit -am `*`"Add ToC"`*

21. ## Clean and lint

    Before you build the ebook for proofreading, it’s a good idea to check the ebook for some common problems you might have run into during production.

    First, run **`se`**` clean` one more time to both clean up the source files, and to alert you if there are XHTML parsing errors. Even though we ran **`se`**` clean` before, it’s likely that in the course of production the ebook got into less-than-perfect markup formatting. Remember you can run **`se`**` clean` as many times as you want—it should always produce the same output.

    **`se`**` clean `<u>`.`</u>

    Now, run **`se`**` lint`. If your ebook has any problems, you’ll see some output listing them. We’re expecting some errors, because we haven’t added a cover or completed the colophon or metadata. You can ignore those errors for now, because we’ll fix them in a later step. But, you *do* want to correct any fixable errors related to your previous work.

    **`se`**` lint `<u>`.`</u>

    If there are no errors, **`se`**` lint` will complete silently—but again, at this stage we’re expecting to see some errors because our ebook isn’t done yet.

    When correcting the errors, be sure to keep each commit to a single unit of work, and to signify what is being *changed* in the commit message, not what prompted the change. Lint can identify a wide variety of issues, and they should not all be lumped together in the same commit, nor should the commit message be something like “Fix lint errors.” Instead, “Fix transcription typos identified by lint” or “Correct header semantics identified by lint,” and so forth, would be more appropriate.

22. ## Build and proofread, proofread, proofread!

    At this point, our ebook is still missing some important things—a cover, the colophon, and some metadata—but the actual book is in a state where we can start proofreading. We complete a cover-to-cover proofread now, even though there’s still work to be done on the ebook, because once you’ve actually read the book, you’ll have a better idea of what kind of cover to select and what to write in the metadata description.

    **`se`**` build` will create a usable epub file for transfer to your ereader. We’ll run it with the `--kindle` and `--kobo` flag to build a file for Kindles and Kobos too. If you won’t be using a Kindle or Kobo, you can omit those flags.

    **`se`**` build --output-dir=$HOME/dist/ --kindle --kobo `<u>`.`</u>

    If there are no errors, we’ll see five files in the brand-new `~/dist/` folder in our home directory:

    - `the-strange-case-of-dr-jekyll-and-mr-hyde_advanced.epub` is the zipped up version of our source. Unfortunately most ebook readers don’t fully support all of epub3’s capabilities yet, or the advanced CSS selectors and XHTML structure we use, so we’re more interested in…

    - `the-strange-case-of-dr-jekyll-and-mr-hyde.epub`, the compatible epub version of our ebook. This file is the raw source, plus various compatiblity fixes applied during our build process. If you don’t have a Kindle, this is the file you’ll be using to proofread.

    - `the-strange-case-of-dr-jekyll-and-mr-hyde.kepub.epub` is the Kobo version of our ebook. You can copy this to a Kobo using a USB cable.

    - `the-strange-case-of-dr-jekyll-and-mr-hyde.azw3` is the Kindle version of our ebook. You can copy this to a Kindle using a USB cable.

    - `thumbnail_xxxx_EBOK_portrait.jpg` is a thumbnail file you can copy to your Kindle to have the cover art appear in your reader. A bug in Amazon’s software prevents the Kindle from reading cover images in side-loaded files; contact Amazon to complain.

    Now, transfer the ebook to your ereader and start a cover-to-cover proofread.

    ### What do we mean by “proofreading”?

    “Proofreading” means a close reading of the text to try to spot any transcription errors or issues which the <span class="abbr acronym">SEMoS</span> says we must update. It’s typically *not* a line-by-line comparison to the page scans—that work was already done by the initial transcriber. Rather, proofreading is reading the book as you would any other book, but with careful attention to possible problems in the transcription or in your production. For some general tips on what to look out for when proofreading see the guide [here](/contribute/how-tos/things-to-look-out-for-when-proofreading).

23. ## Create the cover image

    STOP

    **Do not commit cover art to your repository’s history until you have [cleared your selection with the S.E. Editor-in-Chief or your assigned project manager.](https://groups.google.com/g/standardebooks)**

    If you commit non-public-domain cover art, you’ll have to rebase your repository to remove the art from its history. This is complicated, dangerous, and annoying, and you’ll be tempted to give up.

    [Contact us first](https://groups.google.com/g/standardebooks) with page scans verifying your cover art’s public domain status before you commit your cover art!

    Now that you’ve read the ebook, you’re ready to find a cover image.

    Cover images for Standard Ebooks books have a standardized layout. The bulk of the work you’ll be doing is locating a suitable public domain painting to use. See the [Art and Images section of the <span class="abbr acronym">SEMoS</span>](/manual/latest/10-art-and-images) for details on assembling a cover image.

    As you search for an image, keep the following in mind:

    - Cover images must be in the public domain. Thanks to quirks in U.S. copyright law, this is harder to decide for paintings than it is for published writing. You must provide proof of the public domain status of your selection to the S.E. in the form of a page scan of the painting from a book published before January 1, 1931, and your project manager must approve your selection before you can commit it to your repository. Our [Artwork Database](/artworks) contains preapproved cover art options that you can browse by subject.

    - Find the largest possible cover image you can. Since the final image is 1400 × 2100, having to resize a small image will greatly reduce the quality of the final cover.

    - Your selection must in the style of a “fine art” oil painting, so that all Standard Ebooks have a consistent cover style.

    - The Standard Ebooks Editor-in-Chief has the final say on the cover image you pick, and it may be rejected for, among other things, poor public domain status research, being too low resolution, not fitting in with the “fine art” style, or being otherwise inappropriate for your ebook.

    Make sure to read our detailed guide on [how to choose and create a cover image](/contribute/how-tos/how-to-choose-and-create-a-cover-image), including tips and tricks, gotchas, and resources for finding suitable cover art.

    You can use the [Standard Ebooks Artwork Database](/artworks) to browse preapproved cover art by subject.

    What can we use for *Jekyll*? In 1863 Hans von Marées painted an [eerie self-portrait with a friend](https://commons.wikimedia.org/wiki/File:Hans_von_Mar%C3%A9es_-_Double_Portrait_of_Mar%C3%A9es_and_Lenbach_-_WGA14059.jpg). The sallow, enigmatic look of the man on the left suggests the menacing personality of Hyde hiding just behind the sober Jekyll. It was [reproduced in a book published in 1910](https://books.google.com/books?id=etcwAQAAMAAJ&pg=PA336).

    You usually won’t have to edit the actual cover SVG file, `./images/cover.svg`, because it’s automatically generated. All you have to do is resize and crop your cover art to 1400 × 2100 and move it to `./images/cover.jpg`.

    After you’re done with the cover, you’ll have four files in `./images/`:

    - `cover.source.jpg` is the raw image file we used for the cover. We keep it in case we want to make adjustments later. For *Jekyll*, this would be the raw portrait downloaded from Wikimedia.

    - `cover.jpg` is the scaled cover image that `cover.svg` links to. This file is exactly 1400 × 2100. For *Jekyll*, this is a crop of `cover.source.jpg`, and resized up to our target resolution.

    - `cover.svg` is the full cover image including the title and author. This is auto-generated by **`se`**` create-draft`.

    - `titlepage.svg` is the titlepage image auto-generated by **`se`**` create-draft`.

    **`se`**` build-images` takes both `./images/cover.svg` and `./images/titlepage.svg`, converts text to paths, and embeds the cover artwork. The output is placed in `./src/epub/images/`, where you’ll commit it to your repo’s history.

    Once we built the images successfully, perform a commit.

    **`git`**` add -A`` `**`git`**` commit -m `*`"Add cover image"`*

24. ## Complete content.opf

    STOP

    **Do not use AI tools to write or edit any part of the metadata,** including the descriptions.

    Using AI tools in any part of the step-by-step guide is strictly prohibited.

    `content.opf` is the file that contains the ebook metadata like author, title, description, and reading order. Most of it will be filling in that basic information, and including links to various resources related to the text. We already completed the manifest and spine in an earlier step.

    `content.opf` is standardized. See the [Metadata section of the <span class="abbr acronym">SEMoS</span>](/manual/latest/9-metadata) for details on how to fill it out.

    The last details to fill out here will be the short and long descriptions, verifying any Wikipedia links that **`se`**` create-draft` automatically found, adding cover artist metadata, filling out any missing author or contributor metadata, and adding your own metadata as the ebook producer.

    The long description must be *escaped* HTML, which can be difficult to write by hand. It’s much easier to write the long description in regular HTML, and then run **`se`**` clean`, which will escape the long description for you.

    Once you’re done, commit:

    **`git`**` commit -am `*`"Complete content.opf"`*

25. ## Complete the imprint and colophon

    **`se`**` create-draft` put a skeleton `imprint.xhtml` file in the `./src/epub/text/` folder. Fill out the links to the transcription and page scans.

    There’s also a skeleton `colophon.xhtml` file. Now that we have the cover image and artist, we can fill out the various fields there. Make sure to credit the original transcribers of the text (generally we assume them to be whoever’s name is on the file we download from Project Gutenberg) and to include a link back to the Gutenberg text we used, along with a link to any scans we used (from the Internet Archive or HathiTrust, for example).

    You can also include your own name as the producer of this Standard Ebooks edition. Besides that, the colophon is standardized; don’t get too creative with it.

    Leave the release date unchanged, as **`se`**` prepare-release` will fill it in for you in a later step.

    Once you’re done, commit:

    **`git`**` commit -am `*`"Complete the imprint and colophon"`*

26. ## Final checks

    It’s a good idea to run **`se`**` typogrify` and **`se`**` clean` one more time before running these final checks. Make sure to review the changes with **`git`**` difftool` before accepting them—**`se`**` typogrify` is usually right, but not always!

    Now that our ebook is complete, let’s verify that there are no errors at the <span class="abbr">S.E.</span> style level:

    **`se`**` lint `<u>`.`</u>

    Once **`se`**` lint` completes without errors, we’re ready to confirm that there are no errors at the epub level. (If you plan on submitting your project to Standard Ebooks and haven’t touched your repository in a while, make sure your toolset is up-to-date before linting.) We do this by invoking **`se`**` build` with the `--check-only` flag, which will run **`epubcheck`** to verify that our final epub has no errors, but won’t output ebook files, since we don’t need them right now.

    **`se`**` build --check-only `<u>`.`</u>

    Once that completes without errors, we’re ready to move on to the final step!

27. ## Initial publication

    You’re ready to publish!

    - **If you’re submitting your ebook to Standard Ebooks:**

      Contact the mailing list with a link to your GitHub repository to let them know you’re finished. A reviewer will review your production and work with you to fix any issues. They’ll then release the ebook for you.

      *Don’t run **`se`**` prepare-release` on an ebook you’re submitting for review!*

    - **If you’re producing this ebook for yourself, not for release at Standard Ebooks:**

      Complete the initial publication by adding a release date, modification date, and final word count to `content.opf` and `colophon.xhtml`. **`se`**` prepare-release` does all of that for us.

      **`se`**` prepare-release `<u>`.`</u>

      With that done, we commit again using a commit message of `Initial publication` to signify that we’re all done with production, and now expect only proofreading corrections to be committed. (This may not actually be the case in reality, but it’s still a nice milestone to have.)

      ` `**`git`**` add -A`` `**`git`**` commit -m `*`"Initial publication"`*` `

      Finally, build everything again.

      ` `**`se`**` build --output-dir=$HOME/dist/ --kindle --kobo --check `<u>`.`</u>` `

    Congratulations! You’ve just finished producing a Standard Ebook!

