# A Basic Standard Ebooks Source Folder


All Standard Ebooks source folders have the same basic structure. It looks a little like this:

<figure>
<img src="/images/epub-draft-tree.png" alt="A tree view of a new Standard Ebooks draft folder" />
</figure>

- `images/` contains the raw image files used in an ebook. For ebooks without illustrations, you’ll have the following three files:

  - `images/cover.svg`, the raw cover image complete with title and author.

  - `images/titlepage.svg`, the raw titlepage image.

  - `images/cover.source.jpg`, not pictured; the raw, high-resolution artwork we’ve picked as the cover image background, kept here for future reference but not actually used in the final epub file.

  - `images/cover.jpg`, not pictured; the scaled-down version of `cover.source.jpg` that will be referenced by `cover.svg` and included in the final epub file.

- `src/` contains the actual source of the epub. This is the folder that’ll be zipped up as the final epub file, and where the bulk of our work will happen.

  - `src/META-INF/`, `src/META-INF/container.xml`, and `src/mimetype` are required by the epub spec; don’t edit them.

  - `src/epub/css/` contains the CSS files used in the epub.

    - `src/epub/css/core.css` is the common CSS file used across all Standard Ebooks; don’t edit it.

    - `src/epub/css/local.css` is the CSS file that contains styles for this specific ebook. This is the one you’ll be editing, *if necessary*. Not all ebooks need custom CSS—the less custom CSS, the better!

  - `src/epub/images/` contains the images used in the final epub. Right now it contains the Standard Ebooks logo file used in the colophon; don’t edit the logo. Once you’ve finished the cover and titlepage images in `./images/`, the `build-images` script will compile them and put them here.

  - `src/epub/text/` is the meat and potatoes of the ebook! You’ll place the source XHTML files here, alongside the templates **`se`**` create-draft` created for you:

    - `src/epub/text/colophon.xhtml` is the template for the Standard Ebooks colophon that appears at the end of every ebook. Usually you’ll edit this last, once you’ve finalized the cover page and metadata.

    - `src/epub/text/titlepage.xhtml` is the titlepage. **`se`**` create-draft` generated the title and author. Don’t edit this unless the title and author are incorrect.

    - `src/epub/text/uncopyright.xhtml` is the Standard Ebooks public domain dedication. Don’t edit this at all.

  - `src/epub/content.opf` is the file that contains all of the epub’s metadata. You’ll be editing this heavily.

  - `src/epub/onix.xml` is a file containing accessibility information. Don’t edit this.

