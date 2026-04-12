
# How to Review an Ebook Production for Publication

After an ebook production is completed, it must go through rounds of review before it is published to ensure the appropriate production quality is assured. Reviewers are assigned by the [editor-in-chief](/about#editor-in-chief), and may be a member of the [editorial staff](/about#editors), or an experienced Standard Ebooks producer. Below is a helpful step-by-step checklist for reviewers of ebook productions. The checklist is by no means exhaustive, but serves as a good starting point for the proofreading process. Reviewers should keep in mind the standards enumerated in the [Manual of Style](/manual), and note any discrepancies not listed below. Before any review steps, ensure the most recent version of the SE toolset is installed.

1.  ## Lint

    Run **`se`**` lint `<u>`.`</u> at the root of the project directory. If `lint` surfaces any nontrivial errors, you should direct the producer to fix the errors before proceeding. If there are false positives, the producer should create an `se-lint-ignore.xml` to suppress the false positives.

2.  ## Typogrify

    Run **`se`**` typogrify `<u>`.`</u> at the root of the project directory. The `typogrify` command is almost always correct, but sometimes not all changes it makes should be accepted. To go over the changes `typogrify` may have made, run the following **`git`** command to also highlight changes made to invisible or hard to differentiate Unicode characters:

    **`git`**` diff -U0 --word-diff-regex=.`

3.  ## Modernize spelling

    Run **`se`**` modernize-spelling `<u>`.`</u> at the root of the project directory. Note that this tool may not catch all archaic words. Prudent use of text editor spellcheckers can help picking up some of these. When in doubt, refer to the appropriate authority of spelling as noted in the [Manual](/manual/latest/single-page#8.2.9). Many words that are hyphenated in the past (<span class="abbr">e.g.</span> *to-morrow*) are in modern times concatenated. *However*, these hyphens should all be retained in poetry . That said, obvious sound-alike spelling modernization should be made and accepted.

4.  ## Semanticate

    Run **`se`**` semanticate `<u>`.`</u> at the root of the project directory. Unlike **`se`**` typogrify` or **`se`**` modernize-spelling`, **`se`**` semanticate` is more prone to error or false positives. Judicious use of the **`git`**` diff` command listed in Step 1 would be needed to prevent and revert any unwanted changes.

5.  ## Clean

    Run **`se`**` clean `<u>`.`</u> at the root of the project directory. Ideally the producer of the ebook would have ran this multiple times during their production process. However, since changes may have been made since then by the producer and stylistic deviations may be been inadvertently introduced, this will clean those potential errors up. After each step so far, it is recommended to use the **`git`**` diff` commanded listed in Step 1 to review and record all changes that are needed.

6.  ## Check dashes and diacritics

    Run both **`se`**` find-mismatched-dashes `<u>`.`</u> and **`se`**` find-mismatched-diacritics `<u>`.`</u> at the root of the project directory. Neither of these tools will make actual changes to the project, but they will list words that have inconsistent application of dashes/diacritics. Check with the language authority listed in the [Manual](/manual/latest/single-page#8.2.9) to decide on what recommendations should be made.

7.  ## Build title, table of contents, and images

    Run **`se`**` build-title `<u>`.`</u>, **`se`**` build-toc `<u>`.`</u> and **`se`**` build-images `<u>`.`</u> at the root of the project directory. No changes should be made by these tools if the producer correctly generated the title page, table of content, and image files. Any discrepancies can be highlighted and investigated via the **`git`**` diff` listed in Step 1.

8.  ## Review initial commit

    Check out the initial commit and review `body.xhtml` with your text editor of choice to make sure that the Project Gutenberg license text wasn’t accidentally committed to the repository:

    **`git`**` checkout `*`"$COMMIT"`*

    If the license text was committed, the producer will have to rebase it out. Once you are done reviewing the initial commit, use the following command to leave the detached `HEAD` state:

    **`git`**` switch -`

9.  ## Review editorial commits

    Use the following **`git`** command to highlight all editorial commits:

    **`git`**` log --pretty=`*`"format:%h: %s"`*` --grep=`*`"\[Editorial\]"`*

    Once identified, these commits can be reviewed via:

    **`git`**` diff `*`"$COMMIT~"`*` `*`"$COMMIT"`*`;`

    Alternatively, a graphical **`git`** client can be used instead.

10. ## Review en dash uses

    Run the following command to check for incorrect en dash use:

    **`grep`**` --recursive --line-number `*`"[a-z]–[a-z]"`*` `<u>`.`</u>

    Note that the dash in between the two square bracket is an *en dash* (`–` U+2013), and not a hyphen. Check the [Manual](/manual/latest/single-page#8.7.7) for the correct type of dashes to use in different cases. Alternatively, use your text editor's regular expression search to find potential incorrect usage instead of **`grep`**.

11. ## Review miscurled quotes

    Run the following command to examine possible miscurled single quotes:

    **`se`**` interactive-replace `*`"(\s)‘([a-z])"`*` `*`"\1’\2"`*` `<u>`.`</u>

    Note the use of `‘` (left single-quotation mark, U+2018) and `’` (right single-quotation mark, U+2019) in the command above, and not `'` or `` ` ``. Using **`se`**` interactive-replace` is the safest as there are many potential false positive cases here that should not be change. Refer the the relevant section of the [Manual](/manual/latest/single-page#8.7.5). Note that sometimes this type of mistakes might be committed by **`se`**` typogrify`. For example:

    <figure class="wrong html full">
    <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">He had pork ‘n’ beans for dinner</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>

    <figure class="corrected html full">
    <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">He had pork ’n’ beans for dinner</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>

    Note the right single-quotation mark is applied twice under this situation. More cases like this is in the section of the Manual linked above.

12. ## Check for punctuation outside quotation marks

    Run the following command to examine punctuation that might have to be moved inside quotation marks:

    **`se`**` interactive-replace `*`"([’”])([,.])" "\2\1"`*` src/epub/text/`*`*`*

    In general, periods and commas always go inside quotation marks, both single and double. For example:

    <figure class="wrong html full">
    <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">He pronounced it “pleasure”, and as he said it he licked his lips.</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>

    <figure class="corrected html full">
    <span class="p"><code class="sourceCode html"><span class="er">&lt;</span></code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span><code class="sourceCode html">He pronounced it “pleasure,” and as he said it he licked his lips.</code><span class="p"><code class="sourceCode html"><span class="er">&lt;</span>/</code></span><span class="nt"><code class="sourceCode html">p</code></span><span class="p"><code class="sourceCode html">&gt;</code></span>
    </figure>

    Note the right single-quotation mark is applied twice under this situation. More cases like this is in the section of the Manual linked above.

13. ## Review capitalization

    As noted in the [Manual](/manual/latest/single-page#8.3.3) text in call caps is rarely correct. Use the following command to check for instance of all caps:

    **`se`**` xpath `*`"//p//text()[re:test(., '[A-Z]{2,}') and not(contains(., 'OK') or contains(., 'SOS')) and not(parent::abbr or parent::var or parent::a or parent::*[contains(@epub:type, 'z3998:roman')])]"`*` `<u>`src/epub/text/`*`*`*`.xhtml`</u>

    If any such instances is found, check with the [Manual](/manual/latest/single-page#8.3) for the correct capitalization style in all cases.

14. ## Review era abbreviation elements

    Era abbreviations do not have punctuation in them unlike other common abbreviations (see [Manual](/manual/latest/single-page#8.9.5)). Use the following command to check each of such cases:

    **`se`**` interactive-replace `*`"(<abbr epub:type=\"se:era[^\"]*?\">)(BC|AD)</abbr>\."`*` `*`"\1\2</abbr>"`*` `<u>`.`</u>

15. ## Review italics and emphasis elements

    The <span class="p">`<`</span><span class="nt">`i`</span><span class="p">`>`</span> and <span class="p">`<`</span><span class="nt">`em`</span><span class="p">`>`</span> elements are not to be used interchangeably (see relevant section of the Manual [here](/manual/latest/single-page#4.1.2) and [here](/manual/latest/single-page#8.2)). Use the following command to check their usage in the production (alternatively, use the regular expression search function in a text editor):

    **`grep`**` --recursive --line-number --extended-regexp `*`"<i|<em"`*` `<u>`src/epub/text/`*`*`*`.xhtml`</u>

    Are there any <span class="p">`<`</span><span class="nt">`i`</span><span class="p">`>`</span> elements that lack semantics?

    **`grep`**` --recursive --line-number `*`"<i>"`*` `<u>`src/epub/text/`*`*`*`.xhtml`</u>

16. ## Review bold and strong elements

    The <span class="p">`<`</span><span class="nt">`b`</span><span class="p">`>`</span> and <span class="p">`<`</span><span class="nt">`strong`</span><span class="p">`>`</span> elements are not to be used interchangeably (see relevant section of the Manual [here](manual/latest/single-page#8.3.3)). Use the following command to check their usage in the production (alternatively, use the regular expression search function in a text editor):

    **`grep`**` --recursive --line-number --extended-regexp `*`"<(b\W|strong)"`*` `<u>`src/epub/text/`*`*`*`.xhtml`</u>

17. ## Review XHTML file structure

    Do a final look through of each XHTML file for spelling, styling, and formatting discrepancies. Possible things to look out for:

    - Check that the correct semantics for elements are used. (<span class="abbr">e.g.</span> correct usage of <span class="p">`<`</span><span class="nt">`blockquote`</span><span class="p">`>`</span>, no <span class="p">`<`</span><span class="nt">`div`</span><span class="p">`>`</span> blocks are used, <span class="abbr">etc.</span>

    - If the book is in ”parts,” “books,” or “volumes”:

      - Do the chapters have the right filenames? (See [Manual](/manual/latest/single-page#2.2))

      - Does each chapter file include the wrapping <span class="p">`<`</span><span class="nt">`section`</span><span class="p">`>`</span> element for its corresponding part, for recomposition? (See [Manual](/manual/latest/single-page#4.1.1.1))

    - If the book has illustrations, check that the illustration names and ids are correct. (See [manual](/manual/latest/single-page#7.8))

18. ## Review local CSS

    Review the `local.css` file. Possible things to look out for:

    - Any styles that have no effect? (<span class="abbr">e.g.</span>, Setting <span class="k">`text-indent`</span><span class="p">`:`</span>` `<span class="mi">`0`</span><span class="p">`;`</span> on an element which already inherits that property from `core.css`)

    - Any unusual classes that can be converted to more clever selectors instead?

    - Any selectors that should use a different pattern according to previous standards? (<span class="abbr">e.g.</span>, setting small caps by targeting a valediction, instead of targeting <span class="na">`epub:type`</span><span class="o">`=`</span><span class="s">`"z3998:signature"`</span>

19. ## Review colophon

    Review the colophon. Possible things to look out for:

    - Are names without links wrapped in <span class="p">`<`</span><span class="nt">`b`</span>` `<span class="na">`epub:type`</span><span class="o">`=`</span><span class="s">`"z3998:personal-name"`</span><span class="p">`>`</span>?

    - Are abbreviated names wrapped in <span class="p">`<`</span><span class="nt">`abbr`</span>` `<span class="na">`epub:type`</span><span class="o">`=`</span><span class="s">`"z3998:given-name"`</span><span class="p">`>`</span>?

20. ## Review metadata

    Review all metadata including those in `content.opf`. See [this](/manual/latest/single-page#9) section of the Manual for reference. Possible things to look out for:

    - Is author, translator(s), cover artist, <span class="abbr">etc.</span> in the correct order and in expected style?

    - Check all links, such as author/work Wikipedia links, are correct by *opening them in a browser*. Sometimes **`se`**` create-draft` guesses the wrong Wikipedia link for a book or person with the same name as another book or person.

    - If the book has a subtitle, check that it is represented as expected. See [here](/manual/latest/single-page#9.4.2) for reference.

    - Confirm that the long description of the book in the metadata was not copy and pasted from Wikipedia or other third-party sources.

    - Check that the short description of the book is valid (<span class="abbr">i.e.</span> a single complete sentence.)

    - If the book is part of any sets or series, check that all necessary metadata is included. See [here](/manual/latest/single-page#9.3.3) for reference.

21. ## Review cover art

    Open `./images/cover.jpg` in your image editor of choice and examine it to make sure it is cropped correctly (<span class="abbr">i.e.</span> there is no whitespace on the margins).

22. ## Lint again

    Run a final **`se`**` lint `<u>`.`</u> check, and ensure it is silent. If any warnings and errors are produced, they must be noted and addressed.

23. ## Test epub build

    Run the following command at the root of the project directory to ensure the epub builds:

    **`se`**` build --check-only `<u>`.`</u>

    Note all errors if they are produced by the command.

24. ## Submit review comments

    Log all review notes and recommendations on the production's GitHub repository issue tracker, and inform the producer and the rest of the editorial team the review has been completed, with a short summary of the results of the review and changes that may be needed before publishing.

