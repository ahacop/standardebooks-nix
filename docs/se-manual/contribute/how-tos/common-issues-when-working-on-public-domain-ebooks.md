# Common Issues When Working on Public Domain Ebooks


## Punctuation

1.  Punctuation, other than periods, appearing immediately inside a closing parenthesis should be moved outside the parenthesis.

    This comma that is inside the closing parenthesis…

    <figure>
    <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">…my brothers, (though fain would I see you all,) before my death…</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>

    …should be moved outside the parenthesis. Since this is changing content, it is an editorial commit.

    <figure>
    <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">…my brothers, (though fain would I see you all), before my death…</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>

2.  Place names, e.g. pubs, inns, etc., should have quotation marks removed.

    For example, the quotes around the name of the inn…

    <figure>
    <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">“Shall we get supper at the ‘Lame Cow’?”</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>

    …should be removed:

    <figure>
    <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">“Shall we get supper at the Lame Cow?”</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>



## Capitalization

1.  Lowercase words immediately following exclamations and question-marks was a common practice and should be left as-is.

    <figure>
    <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">“Surrender you two! and confound you for two wild beasts!”</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>

2.  Older public domain works, especially eighteenth century and prior, often used capitalized words as a kind of emphasis. Unless they are for purposes of personification, they should be changed to lowercase.

    Here, “History” is a personification, but “Courtiers” is not.

    <figure>
    <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">To the eye of History many things, in that sick-room of Louis, are now visible, which to the Courtiers there present were invisible.</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>

    Therefore, “Courtiers” should be lowercased. This would be also be an editorial commit.

    <figure>
    <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">To the eye of History many things, in that sick-room of Louis, are now visible, which to the courtiers there present were invisible.</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>

3.  Often, the first few words of each chapter in a work are set in all- or small-caps. We do not retain that formatting.

    <figure>
    <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">I SUPPOSE that in the days before the catastrophe I was a very fair representative of the better type of business man.</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>

    The first two words should be changed to normal sentence case in an editorial commit.

    <figure>
    <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">I suppose that in the days before the catastrophe I was a very fair representative of the better type of business man.</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>



## Elision

1.  Semicolons were occasionally used for elision in names; these should be replaced with the S.E. standard two-em dash for partial elision, three-em dash for full elision.

    The ellipsis in the Bishop's name is incorrect for an S.E. production.

    <figure>
    <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">When I turned myself over to a Letter from a Beneficed Clergyman in the Country to the Bishop of C…r, I was becoming languid…</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>

    It should be changed to our standard two-em dash in an editorial commit.

    <figure>
    <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">When I turned myself over to a Letter from a Beneficed Clergyman in the Country to the Bishop of C⸺r, I was becoming languid…</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>



## Diacritics

1.  Diacritics on words that appear in Merriam-Webster without them should generally be removed. **`se`**` modernize-spelling` corrects some of these, so it is best to wait until after that step to see if any others are left. **`se`**` find-mismatched-diacritics` can help find instances of these. These commit(s) should be editorial.

    The circumflex on hôtel is unnecessary…

    <figure>
    <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">“Is not that the hôtel in which is enclosed the garden of the Lingère du Louvre?”</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>

    …and therefore can be removed:

    <figure>
    <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">“Is not that the hotel in which is enclosed the garden of the Lingère du Louvre?”</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>



## Headers

1.  Periods that appear after the chapter number or title should be removed. This…

    <figure>
    <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">h3</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">A Gascon, and a Gascon and a Half.</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">h3</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>

    …should be changed to this.

    <figure>
    <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">h3</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">A Gascon, and a Gascon and a Half</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">h3</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>



## Italics

1.  If italicized non-English words are found in Merriam-Webster, the italics should be removed.

    Here, “sotto voce” appears in the standard Merriam-Webster dictionary.

    <figure>
    <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">“No, you certainly have not, old man,” put in Rogers </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">i</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">sotto voce</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">i</code></span><span class="p"><code class="sourceCode html">&gt;.</code></span><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>

    Therefore, the italics should be removed:

    <figure>
    <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">“No, you certainly have not, old man,” put in Rogers sotto voce.</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>

2.  Words and/or phrases that are italicized in the source, or italicized and quoted, should be changed to match S.E. standards. For example, it may be italicized in the source, but should be quoted according to our style manual. Or, an English phrase may be quoted and italicized, and only one is necessary (usually the quotes).

    Here, song lyrics are both quoted and italicized.

    <figure>
    <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">blockquote</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">i</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">span</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">At nighttime in the moon’s fair glow</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">span</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">br</code></span><span class="p"><code class="sourceCode html">/</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">span class=&quot;i1&quot;</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">How sweet, as fancies wander free,</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">span</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">br</code></span><span class="p"><code class="sourceCode html">/</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">span</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">To feel that in this world there’s one</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">span</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">br</code></span><span class="p"><code class="sourceCode html">/</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">span class=&quot;i1&quot;</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">Who still is thinking but of thee!</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">span</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">i</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">blockquote</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>

    Per S.E. standards, we remove the italics.

    <figure>
    <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">blockquote</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">span</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">At nighttime in the moon’s fair glow</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">span</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">br</code></span><span class="p"><code class="sourceCode html">/</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">span</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">How sweet, as fancies wander free,</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">span</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">br</code></span><span class="p"><code class="sourceCode html">/</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">span</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">To feel that in this world there’s one</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">span</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">br</code></span><span class="p"><code class="sourceCode html">/</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">span</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">Who still is thinking but of thee!</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">span</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html"> </code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">blockquote</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>

