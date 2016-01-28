title: New Job, New Website
article_id: 2
slug: new-job-new-website

#!!==========================================================

Six years ago I was a ruby programmer, indeed, I would spend hours explaining to my fellow students how pleasant it was compared with languages like PHP and Java, both of which were very much in vogue with the computer science department at Sussex University (although some of the cool kids were writing Haskell).

Not too long after leaving university, I found myself working as a designer. Admittedly, I was still a somewhat geeky designer — using sass and JavaScript to build things along with the new-fangled CSS3 and HTML5 that was amazing us all at the time. I'd still turn to ruby if I needed to write a script or make a quick web service, but it's not been a language I've used heavily for quite a while. 

That is, until a few months ago. 

I was approached by someone I know and asked if I could work on a simple project to build a website that consumed data from an API. The idea was that all the heavy lifting would be done on the web service end, and I'd just have to turn JSON into usable web pages. Unfortunately, it quickly became apparent that is wasn't going to work quite like that, and I would have to do some stuff on my end. Rather than turning to something like Node.js, which I'm not really familiar with, I built a little Sinatra app. 

To cut a long story short(er), I'm now working as a ruby developer in London, mostly writing tests for software written in other languages. Considering the software that I'm trying to test, it's quite a challenge on its own; but coupled with the fact that my new company is struggling to shift from its old, very “corporate” methods to an modern, Agile, BDD-focused approach to software development, it's very challenging indeed. Of course, that also makes it very interesting. 

When interesting things are happening around me, particularly when they relate to code, I feel compelled to write about some of them. And that, in a rather rambling fashion, brings me to the point of this article.

# I have a new website

This is it, if you hadn't noticed[^1].

I started out looking for a blogging platform that would do what I wanted as simply as possible. My criteria was:

* I must be able to write in markdown (using [iA Writer](http://www.iawriter.com/) on both my mac and iPad.
* I must have complete control of the HTML and CSS, and it must be easy for me to play around with and try out new stuff.
* I must have an easy way to save images and screenshots and include them in articles without worrying too much about remembering filenames and paths.
* I must understand all of the code, so I can fiddle with it.

Unfortunatly I couldn't find anything out there that would meet all of those criteria, so like loads of people before me, I decided to roll my own.

After looking at the possibility of building a static-site generator, I settled on a Sinatra app - mostly because it gives me the freedom to add dynamic stuff in very easily shoud I ever feel the need to. Very briefly, this is how it works…

The static assets are compiled locally by [guard-sass](https://github.com/hawx/guard-sass) and [guard-jammit](https://github.com/guard/guard-jammit). When the app is spun up, it reads all of the images in `public/article-images` which are named according to a special convention,  as well as all the markdown files in `articles`.

The [Article](https://github.com/dannysmith/dasmith/blob/master/lib/article.rb) class reads some metadata from the top of the file and then parses the remainder with a custom [Redcarpet](https://github.com/vmg/redcarpet) renderer, which also looks for special tags to insert the images (and any gists). This allows me to write articles like this:

````
title: The Title of The Article
post_id: 3
slug: the-slug-for-the-article

#!!==========================================================

The rest of the article, written in markdown..
````

It also allows me to use two special tags to insert images and gists, `{{image: 1}}` will insert the first image for this particular post and wrap it in a `<figure>` tag. The filename of the image is used as the `figcaption` and `alt` text. I also can insert gists with `{{gist:http://gist.github.com/name/000}}`. Code blocks are parsed with [Pygments.rb](https://github.com/tmm1/pygments.rb).

Because the local version of the site is in my dropbox, I can write on both my mac and iPad. When I've written a post, I can simply push the whole repo up to Heroku.

There's some more information in the [README](https://github.com/dannysmith/dasmith/blob/master/README.md).

Although I'm not certain that this is the best way for me to write, I'm happy that I've been able to throw this together so quickly. The only thing I'm slightly worried about is the fact that the app has to parse every markdown file when it spins up. This wouldn't be a problem, except that Heroku spins down apps that haven't had any visits in a while. I've installed New Relic, which [solves that problem](https://coderwall.com/p/u0x3nw) for now, but I'd still like to run some performance tests in the future.

[^1]: The code is here: https://github.com/dannysmith/dasmith

# Styles

Because I knocked this out in a day, I've not bothered styling every possible element. If I find I'm writing articles with forms and what-not in them then I'll style them up as I go. I have, however, styled the following elements:

Normal paragraphs, of course, with super^script, [links](http://google.com), some inline `code` elements as well as **bold**, *italicised*, _underlined_ and ==highlighted== text. ~~Strikethroughs~~ are also styled along with:

* Ordered
* Lists

and

1. Unordered
2. Lists

and blockquotes:

> Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam
-- by Mr Lorem

and Images:

{{image:1}}

Although I can't see me using tables overmuch, it made sense to style them:

First Header  | Second Header
------------- | -------------
Content Cell  | Content Cell
Content Cell  | Content Cell
Content Cell  | Content Cell

Because I write quite lot of code, I've also included styling for code blocks:

````ruby
def mything(foo)
  thing = "foo"
  @bar = [1,2,3]
end
````

and gists:

{{gist:https://gist.github.com/dannysmith/4468916}}

It's bugging me slightly that there's no easy way to add a footer element to a blockquote in markdown, so I may well extend the Redcarpet parser to handle that. For now though, [Let me know](http://twitter.com/dannysmith) what you think of the design.
