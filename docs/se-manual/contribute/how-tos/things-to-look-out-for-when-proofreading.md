# Things to Look Out For When Proofreading


- **Missing or incorrect punctuation.** Often <span class="abbr initialism">O.C.R.</span> software misses small punctuation marks like commas and periods. Does a sentence sound awkward, as if it was missing a comma? Is a period obviously missing between sentences? Mark it and check it against the page scans.

- **Missing formatting.** Transcribers often remove formatting like blockquotes or italics. Is there a section in the book that looks like it should be styled as a blockquote, like verse or a letter? Are characters speaking emphatically, but without italics? Mark these cases to compare against the page scans to see if formatting has to be restored.

- **Missing thought or paragraph breaks.** Is a paragraph unusually long? Does a scene change occur without <span class="p">`<`</span><span class="nt">`hr`</span>`/`<span class="p">`>`</span>? They might have been lost during transcription.

- **Errors caused by the S.E. toolset.** Tools like **`se`**` british2american` or even **`se`**` typogrify` can cause unexpected typography errors like quotation marks curled in the wrong direction, or dashes spaced incorrectly.

- **Archaic spellings.** Is a particular word spelled in a surprising way? Mark it to check if it should be modernized. The [Google Books Ngram Viewer](https://books.google.com/ngrams/) is a great tool to get an idea of whether a word used to be spelled one way, but isn’t spelled that way anymore. Remember to change spellings in their own commits, prefaced with `[Editorial]`!

- **Printer’s errors.** Before the computer age, hand-written manuscripts were sent to printers, whose job it was to lay the book out in lead blocks of type. During this process, the printer may have accidentally introduced their own typos, which are usually obvious errors in punctuation, spelling, or grammar. If you spot an obvious error like this that is present in both the transcription and the page scans, it may be a printer’s error that should be corrected in an `[Editorial]` commit.

There are some things that you don’t have to worry much about when proofreading:

- **Spelling errors.** Actual spelling errors are very rare. If a word appears to be misspelled, it’s worth it to check the page scans, but such cases are often done on purpose by the author, or using an older spelling, or are spelled differently in en-US vs. en-GB.

- **Changing from en-GB to en-US or vice versa.** Spelling differences between the continents were not yet settled then, so it’s common for books to be set in a blend of spellings. We don’t convert from one style to the other, or try to ensure perfect consistency between styles. This includes en-GB differences like using “an” in front of a word starting in “h,” like “an hundred.”

- **Compound words.** Some words that today are usually written as a single word may in older works be printed as two words separated by a space or a hyphen. The most common cases are handled by **`se`**` modernize-spelling`, however there are so many possible combinations that eliminating or standardizing all of them would be a major challenge. As such it is *not required* to change compound words, although this can *optionally* be done provided there is sufficient evidence that a modern printing would do so. The following words are exceptions and *should never be modernized* (<span class="abbr initialism">N.B.</span> this does not mean we split them if they are already printed as a single word):

  - none the less

  - on to

  - worth while

- **Keeping a 100% faithful representation of a print page layout.** Sometimes books have complicated page layouts in print. But ebooks are not the same as print books, with the most important distinction being that there is no “page” to align items to. So, we’re not so concerned with maintaining a pixel-perfect reproduction of print layouts; rather, we wish to *adapt* print layouts as best we can to the ebook medium.

If you’re using a transcription from Project Gutenberg as the base for this ebook, you may wish to report typos you’ve found to them, so that they can correct their copy. [Instructions for how to do so are here.](/contribute/report-errors-upstream)

