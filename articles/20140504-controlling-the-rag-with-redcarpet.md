title: Controlling the Rag with Redcarpet
article_id: 6
slug: controlling-the-rag-with-redcarpet

#!!==========================================================

Ever since I read Mark boulton's [article](http://24ways.org/2013/run-ragged/) on controlling text's right rag on the web, I've been wanting to implement some of it on this blog. His article lays out five violations:

1. Never break a line immediately following a preposition.
2. Never break a line immediately following a dash.
3. No small words at the end of a line.
4. Hyphenate sensibly.
5. Don't break emphasised phrases of three or fewer words.

Personally, I'm not too concerned about hyphenation, but in addition to the other rules, I wanted to avoid [orphans](http://en.wikipedia.org/wiki/Widows_and_orphans) on the end of my paragraphs.

Mark points us to Nathan Ford's [ragadjust](https://github.com/nathanford/ragadjust) javascript library, but as I'm already parsing markdown into HTML on here, it seemed inefficient parse it again with JS.


> Good typographic design — on the web, in print; anywhere, in fact — relies on small, measurable improvements across an entire body of work -- Mark Boulton

# Using a Redcarpet Renderer

This blog already uses a custom red carpet renderer, but to simplify things, let's create an app which reads the contents of a markdown file called `text.md`, parses it with a custom renderer and then prints it to the terminal:

````ruby
require 'bundler/setup'
require 'redcarpet'
require './renderer.rb'

data = File.read(File.dirname(__FILE__) + "/text.md")

renderer = MyRenderer.new(with_toc_data: true, prettify: true)
markdown = Redcarpet::Markdown.new(renderer,
                                   autolink: false,
                                   space_after_headers: true,
                                   prettify: true,
                                   no_intra_emphasis: true,
                                   fenced_code_blocks: true)
puts markdown.render(data)
````

Now let's create our `renderer.rb` file:

````ruby
require 'redcarpet'

class MyRenderer < Redcarpet::Render::HTML
  include Redcarpet::Render::SmartyPants

end
````

The first thing we want to do is prevent orphans. We might write this rule as *Replace the space between the last two words of a paragraph with a `&nbsp;`*. This can be achieved fairly simply by adding our own paragraph method to the renderer:

````ruby
def paragraph(text)
  "<p>#{text.reverse.split(" ", 2).join('&nbsp;'.reverse).reverse}</p>\n\n"
````

Next, let's look at violation number five: Don't break emphasised phrases of three or fewer words. We could write this as: *If a em, strong or anchor element has fewer than four words, replace all the spaces with a `&nbsp;`*.

Let's write a short method to do that for us:

````ruby
# Replace spaces with &nbsps if tring has less than the required number of words
  def do_not_break_string(min_words = 3, text)
    if text.split.size <= min_words
      text = text.split.join('&nbsp;')
    end
    return text
  end
````

We can then add some render methods that use it:

````ruby
  # Prevent Bold, Emphasised or Linked text breaking if it's short.
  def emphasis(text)
    return "<em>#{do_not_break_string(text)}</em>"
  end

  def double_emphasis(text)
    return "<strong>#{do_not_break_string(text)}</strong>"
  end

  def link(link, title, content)
    return "<a href=\"#{link}\" title=\"#{title}\">#{do_not_break_string(content)}</a>"
  end
````

Now comes the slightly tricky bit...

We could write violations one to three like this:

*If a word is a preposition OR it is a dash of some sort OR it has fewer than three characters, replace the subsequent space with a `&nbsp;` element, otherwise leave the space where it is*

Initially, I tried to achieve this by splitting the paragraphs into arrays of words and joining them together again, but that didn't seem like a very clean or efficient solution. Instead, we're going to use a RegExp. Be warned, it's pretty long. Essentially, it matches any word which is < 3 characters, is a dash of some sort (wither literal or an HTML entity code), or is a preposition word. It then captures the word and the subsequent space.

<pre class="u-code">
/(?:\s|^|>)(?<word>(\w{0,3}|[-–—]|\&ndash\;|\&mdash\;|aboard|about|above|across|after|against|along|amid|among|anti|around|before|behind|below|beneath|beside|besides|between|beyond|concerning|considering|despite|down|during|except|excepting|excluding|following|from|inside|into|like|minus|near|onto|opposite|outside|over|past|plus|regarding|round|save|since|than|that|this|through|toward|towards|under|underneath|unlike|until|upon|versus|with|within|without)(?<space>\s))/i
</pre>

Actually implementing this is pretty simple, as we can use red carpet's `normal_text` method and ruby's gsub to replace the space after anything that matches. We're actually replacing the match with itself, stripped of the trailing space and with a non-breaking space added:

````ruby
  def normal_text(text)
    regexp = /(?:\s|^|>)(?<word>(\w{0,3}|[-–—]|\&ndash\;|\&mdash\;|aboard|about|above|across|after|against|along|amid|among|anti|around|before|behind|below|beneath|beside|besides|between|beyond|concerning|considering|despite|down|during|except|excepting|excluding|following|from|inside|into|like|minus|near|onto|opposite|outside|over|past|plus|regarding|round|save|since|than|that|this|through|toward|towards|under|underneath|unlike|until|upon|versus|with|within|without)(?<space>\s))/i

    text = text.gsub(regexp).each {|m| "#{m[0..-2]}&nbsp;"}
  end
````

And there it is. You can see a [working example on GitHub](https://github.com/dannysmith/ragged_redcarpet).

I love the idea that by making small, incremental changes to the way text is rendered, it's possible to make a big difference in the end.
