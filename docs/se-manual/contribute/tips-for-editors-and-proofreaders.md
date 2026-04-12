# Tips for Editors and Proofreaders

Advances in ereading devices and software have made proofreading ebooks a whole lot easier than in the past.

Most ereading software allows you to highlight text and add notes to those highlights. If you’re using a device like a Kindle or a phone or tablet with the Google Play Books app, try holding your finger on some text. It’ll become highlighted, and you can drag the highlight to include more text if you like.

That means the quickest way for you to proofread an ebook is to [transfer it to your ereader](/help/how-to-use-our-ebooks) and start reading! Once you find an error, use the highlight feature to mark it, and keep on reading. Many errors, like mis-curled quotation marks or obvious spelling errors, don’t need a written note to accompany the highlight. But you should make a brief written note if the error wouldn’t be clear to a passing reader.

Once you’ve finished the ebook, use your ereader’s “view all notes” option to find all of your highlights in one place. Then you can either [report them to us](/contribute/report-errors), or if you’re technically-minded, correct them directly in the ebook’s [GitHub repository](http://github.com/standardebooks). Remember to read the [Standard Ebooks Manual of Style](/manual) to make sure the error you found is covered.


## Common errors to watch out for

Lots of different errors can occur during the long and complex process of digitizing a print book, but here are some of the more common ones:

- ### Mis-curled quotation marks

  Here we see two frequent errors: a mis-curled double quotation mark following the em-dash, and a mis-curled single quotation mark before the “n”:

  <figure class="text">
  <p>I was putting on some Bach when he interrupted with—”Put on some rock ‘n’ roll!”</p>
  <p>I was putting on some Bach when he interrupted with—“Put on some rock ’n’ roll!”</p>
  </figure>

- ### Incorrect or archaic use of quotation marks

  Older texts frequently use quotation marks for names of books and periodicals, or for the names of pubs, inns, and other places. Our [typography manual](/manual/latest/8-typography) requires that certain standalone media be in italics instead, and that place names *not* be set in quotes.

  <figure class="text">
  <p>He read “Candide” while having a pint at the “King’s Head.”</p>
  <p>He read <em>Candide</em> while having a pint at the King’s Head.</p>
  </figure>

- ### Missing italics

  Often transcribers just don’t include italics at all in their work. A very quick visual scan of a HathiTrust or Google Books copy of the book you’re proofing should bring any sections in italics to your attention. Make sure to confirm them in the transcription, so that we’re not missing italics that should be there.

- ### Ending dialog with a double-em-dash

  Some authors were in the habit of showing a sudden break in dialog with an extra-wide double-em-dash. Our [typography manual](/manual/latest/8-typography) requires that these be replaced by single em-dashes, so mark them for correction.

  <figure class="text">
  <p>“Why, I never——” she cried.</p>
  <p>“Why, I never—” she cried.</p>
  </figure>

  Note that a double-em-dash is appropriate when purposefully obscuring a word or place. In this case, use the two-em-dash glyph (⸻ or U+2E3A) instead of two consecutive em-dashes:

  <figure class="text">
  <p>Sally J⸺ walked through the town of ⸻ in the year 19—.</p>
  </figure>

- ### Using &c. instead of etc.

  “etc.” is an abbreviation of the Latin *et cetera*; In Latin, *et* means “and”, so older texts often abbreviated *et cetera* as “&c.”

  Our [typography manual](/manual/latest/8-typography) requires a change from &c. to etc., so make sure to mark these corrections.

- ### Use of “ibid.” in footnotes or endnotes

  In work with footnotes or endnotes, “ibid.” means that the source for this note is the same as the previous note on the page.

  Since Standard Ebooks consolidate all footnotes and endnotes into popup footnotes, ibid. becomes meaningless—there’s no concept of a “page” anymore. If you encounter ibid., replace it with the complete reference from the previous note so readers using popup footnotes won’t get confused.

- ### Text in all caps

  Many transcriptions of older texts were made in a time when rich <span class="abbr initialism">HTML</span> markup wasn’t yet available. Those transcriptions sometimes used ALL CAPS to indicate small caps or boldface in the source text.

  All caps is almost never correct typography. Mark text in all caps for conversion to small caps or boldface.

- ### Section dividers as text instead of as markup

  There are lots of ways authors mark section breaks in text. A common way to do this is with three or more asterisks:

  <figure>
  <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">Some text in the first section...</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span data-ass="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">***</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">The second section begins...</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
  </figure>

  In Standard Ebooks, sections must be marked with the `<hr/>` tag:

  <figure>
  <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">Some text in the first section...</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">hr</code></span><span class="p"><code class="sourceCode html">/&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">The second section begins...</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
  </figure>

  As you’re reading, the <span class="p">`<`</span><span class="nt">`hr`</span><span class="p">`/>`</span> element appears as a short black line dividing sections.

  Mark for correction any section breaks that don’t use the <span class="p">`<`</span><span class="nt">`hr`</span><span class="p">`/>`</span> element.

