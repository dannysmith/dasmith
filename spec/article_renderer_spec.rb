require 'spec_helper'

describe DannyIs::ArticleRenderer do

  let(:image1) { instance_double('DannyIs::ArticleImage', filename: '2-1-this-is-file-one.png',
                                       order: 1,
                                       title: 'This is file one',
                                       url: '/article-images/2-1-this-is-file-one.png') }
  let(:image2) { instance_double('DannyIs::ArticleImage', filename: '2-2-this-is-file-two.png',
                                       order: 2,
                                       title: 'This is file two',
                                       url: '/article-images/2-2-this-is-file-two.png') }
  let(:images) { [image1,image2] }
  let(:parser) { Redcarpet::Markdown.new(DannyIs::ArticleRenderer.new(images, prettify: true),  autolink: false,
                                           prettify: true,
                                           no_intra_emphasis: true,
                                           fenced_code_blocks: true,
                                           disable_indented_code_blocks: false,
                                           strikethrough: true,
                                           space_after_headers: true,
                                           superscript: true,
                                           underline: true,
                                           highlight: true,
                                           tables: true,
                                           quote: false,
                                           footnotes: true) }

  it "should render a gist correctly" do
    markdown = <<EOS
# Heading
Thisis aparagraph.

{{gist: https://gist.github.com/232fac9721d5908f5c44}}

Thisis aparagraph.
EOS

    expected_response = <<EOS
<h1>Heading</h1>
<p>Thisis&nbsp;aparagraph.</p>

<script src="https://gist.github.com/232fac9721d5908f5c44.js"></script><p>Thisis&nbsp;aparagraph.</p>

EOS
    expect(parser.render markdown).to eq expected_response
  end

    it "should render images correctly" do
    markdown = <<EOS
Thisis aparagraph.

{{image: 1}}

Thisis aparagraph.

{{image: 2}}

Thisis aparagraph.

EOS

    expected_response = <<EOS
<p>Thisis&nbsp;aparagraph.</p>

<figure class="o-pull-block o-pull-block--left c-image-figure">
  <a class="o-pull-block__content" href="/article-images/2-1-this-is-file-one.png">
    <img src="/article-images/2-1-this-is-file-one.png" alt="This is file one" />
  </a>
  <figcaption class="o-pull-block__footer">This is file one</figcaption>
</figure>

<p>Thisis&nbsp;aparagraph.</p>

<figure class="o-pull-block o-pull-block--left c-image-figure">
  <a class="o-pull-block__content" href="/article-images/2-2-this-is-file-two.png">
    <img src="/article-images/2-2-this-is-file-two.png" alt="This is file two" />
  </a>
  <figcaption class="o-pull-block__footer">This is file two</figcaption>
</figure>

<p>Thisis&nbsp;aparagraph.</p>

EOS
    expect(parser.render markdown).to eq expected_response
  end


 it "should render raw images correctly" do
    markdown = <<EOS
Thisis aparagraph.

{{imageraw: 1}}

Thisis aparagraph.

{{imageraw: 2}}

Thisis aparagraph.

EOS

    expected_response = <<EOS
<p>Thisis&nbsp;aparagraph.</p>

<img src="/article-images/2-1-this-is-file-one.png" alt="This is file one" />
<p>Thisis&nbsp;aparagraph.</p>

<img src="/article-images/2-2-this-is-file-two.png" alt="This is file two" />
<p>Thisis&nbsp;aparagraph.</p>

EOS
    expect(parser.render markdown).to eq expected_response
  end


    it "should wrap tables in a containing div" do
    markdown = <<EOS
| Column | Column |
|--------|--------|
| Value  | Value  |
EOS

    expected_response = <<EOS
<div class="table-wrapper">
  <table>
<tr>
<th>Column</th>
<th>Column</th>
</tr>
<tr>
<td>Value</td>
<td>Value</td>
</tr>\n
  </table>
</div>
EOS
    expect(parser.render markdown).to eq expected_response
  end

    it "should render an aside correctly" do
    markdown = <<EOS
# Heading
Thisis aparagraph.

aside> This is an aside Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.

Thisis aparagraph.
EOS

    expected_response = <<EOS
<h1>Heading</h1>
<p>Thisis&nbsp;aparagraph.</p>

<aside class=\"c-aside\"><i class=\"u-icon u-icon-tags u-icon-2x pull-left\"></i> This is an aside Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.</aside>

<p>Thisis&nbsp;aparagraph.</p>

EOS
    expect(parser.render markdown).to eq expected_response
  end

  it "should add a space between the last two words of a paragraph" do
    markdown = "Thisis afunny paragraphy withsome words."
    expected_response = "<p>Thisis afunny paragraphy withsome&nbsp;words.</p>\n\n"
    expect(parser.render markdown).to eq expected_response
  end

  it "should prevent emphasized text from breaking if under four words" do
    markdown = "Thisis issome line offal text withfoo *some emphasis inside itself*. Thisis theend."
    expected_response = "<p>Thisis issome line offal text withfoo <em>some&nbsp;emphasis&nbsp;inside&nbsp;itself</em>. Thisis&nbsp;theend.</p>\n\n"
    expect(parser.render markdown).to eq expected_response
  end

  it "should allow emphasized text to break if over four words" do
    markdown = "Thisis issome line offal text withfoo *somefr longfr emphasisfr insidefr itselffr*. Thisis theend."
    expected_response = "<p>Thisis issome line offal text withfoo <em>somefr longfr emphasisfr insidefr itselffr</em>. Thisis&nbsp;theend.</p>\n\n"
    expect(parser.render markdown).to eq expected_response
  end

  it "should prevent strong text from breaking if under four words" do
    markdown = "Thisis issome line offal text withfoo **some emphasis inside itself**. Thisis theend."
    expected_response = "<p>Thisis issome line offal text withfoo <strong>some&nbsp;emphasis&nbsp;inside&nbsp;itself</strong>. Thisis&nbsp;theend.</p>\n\n"
    expect(parser.render markdown).to eq expected_response
  end

  it "should allow strong text to break if over four words" do
    markdown = "Thisis issome line offal text withfoo **somefr longfr emphasisfr insidefr itselffr**. Thisis theend."
    expected_response = "<p>Thisis issome line offal text withfoo <strong>somefr longfr emphasisfr insidefr itselffr</strong>. Thisis&nbsp;theend.</p>\n\n"
    expect(parser.render markdown).to eq expected_response
  end

  it "should prevent links from breaking if under four words" do
    markdown = "Thisis issome line offal text withfoo [a link inside itself](http://google.com). Thisis theend."
    expected_response = "<p>Thisis issome line offal text withfoo <a href=\"http://google.com\">a&nbsp;link&nbsp;inside&nbsp;itself</a>. Thisis&nbsp;theend.</p>\n\n"
    expect(parser.render markdown).to eq expected_response
  end

  it "should allow links to break if over four words" do
    markdown = "Thisis issome line offal text withfoo [avery longishfg linkfg insidefg itselffg](http://google.com). Thisis theend."
    expected_response = "<p>Thisis issome line offal text withfoo <a href=\"http://google.com\">avery longishfg linkfg insidefg itselffg</a>. Thisis&nbsp;theend.</p>\n\n"
    expect(parser.render markdown).to eq expected_response
  end

  it "should not break after short words, prepositions or dashes" do
    markdown = "This is is some text with a preposition after the major part --- here issome dash."
    expected_response = "<p>This&nbsp;is is&nbsp;some text with&nbsp;a preposition after&nbsp;the major part &mdash;&nbsp;here issome&nbsp;dash.</p>\n\n"
    expect(parser.render markdown).to eq expected_response
  end

   it "should render a blockquote with a citation" do
    markdown = <<EOS
Thisis aparagraph.

> this is my blockquote -- this is by Joseph Bloggs.

Thisis aparagraph.
EOS

    expected_response = <<EOS
<p>Thisis&nbsp;aparagraph.</p>

<blockquote class="c-blockquote o-pull-block o-pull-block--left">
  <div class="c-blockquote__content o-pull-block__content">
    <p>this&nbsp;is my&nbsp;blockquote</p>
  </div>
  <footer class="c-blockquote__footer o-pull-block__footer">
  <span>&nbsp;this is&nbsp;by Joseph&nbsp;Bloggs.</span>
  </footer>
</blockquote>
<p>Thisis&nbsp;aparagraph.</p>

EOS
    expect(parser.render markdown).to eq expected_response
  end
end

