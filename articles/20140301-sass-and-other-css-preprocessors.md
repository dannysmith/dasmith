title: On Sass and Other CSS Preprocessors
post_id: 4
slug: sass-and-other-css-preprocessors

#!!==========================================================

CSS Preprocessors like [Sass](http://sass-lang.com) and [LESS](http://lesscss.org) have taken the web design world by storm over the last year or so. A few years ago these tools were the preserve of developers and [unicorns](http://uxdiogenes.com/blog/on-being-a-designer-and-a-developer-not-quite-unicorn-rare), but today it's accepted that designers who write CSS can, in fact, wrap their head around preprocessors and get a great deal of value from them. Despite that, I regularly encounter designers who are scared of adopting them – the reasons given broadly fall into two categories:

1. I’m scared of adding another level of complexity to my code. I'm a purist, after all.
2. I don't need a preprocessor – it can't offer me anything useful.

# I started with Sass a while ago

My journey into the world of Sass started in 2007 when I began using Haml in the Ruby on Rails projects I was working on. The simplicity of Haml really appealed to me — particularly because it was made to play nicely with Ruby. Back then Sass came in the same gem as Haml, so I naturally started using it to write my CSS. Rather than taking advantage of the benefits it offers now, I was using it because of the ruby-like syntax:

````sass
.name
  :border 1px solid red
  :color yellow
````

Looking back through my github repos, the first time I *really* took advantage of sass's cleverness was in [this miniature framework](https://github.com/dannysmith/1kbgrid-sass). I remember being incredibly excited at the possibility of treating my CSS in the same way as my ruby code.

**And then I stopped using Sass**

Why, you ask?

The answer: because I wasn't very good at CSS.

As is the norm when learning a language, much of the code I used was copy/pasted from tutorials. Because I was writing and thinking in Sass and not in CSS, I found it incredibly difficult to learn more about the intricacies of CSS. It was also an almighty pain in the arse having to laboriously convert CSS examples into Sass, completely nullifying the entire point of the syntax -- speed of writing.

Then came the greatest milestone in Sass' history: the [introduction of SCSS](http://sass-lang.com/documentation/file.SASS_CHANGELOG.html#scss_sassy_css), a superset of CSS. This meant that we could pick and choose which bits of Sass to use, and to freely copy/paste CSS from other places. Win!

Except that I still didn't start using Sass.

Why, you ask again?

Because it was too easy to convert code pinched from a tutorial into a mixin, and therefore abstract away the inner workings of that code. It's all well and good having a mixin that we can call like this:

````scss
.my-thing {
  @include triangle(right, #444, 1em)
}
````

But if we don't understand — and I mean *really* understand — how to build a triangle using CSS borders, then we're going to have trouble understanding how other elements interact with it.

Yes, CSS is a simple language to learn. Unfortunately for us, It's an incredibly difficult language to master – not least because it's possible to make half-decent websites without truly understanding the details of [specificity](http://coding.smashingmagazine.com/2007/07/27/css-specificity-things-you-should-know/), [z-index](http://coding.smashingmagazine.com/2009/09/15/the-z-index-css-property-a-comprehensive-look/), [floats](http://coding.smashingmagazine.com/2007/05/01/css-float-theory-things-you-should-know/), [selectors](http://coding.smashingmagazine.com/2009/08/17/taming-advanced-css-selectors/) and the like (let alone more recent developments like [flexbox](http://dev.w3.org/csswg/css-flexbox/) and [regions](http://dev.w3.org/csswg/css-regions/)). Take Dave Shariff's [Front End Web Development Quiz](http://davidshariff.com/quiz/) if you don't believe me. 

## But I thought you said preprocessors were a good thing?

I did. But before you can make preprocessors work for you, **you need to be good at plain old CSS**. In other words, you need to fully understand the compiled CSS that Sass spits out. Here are two rules I applied when jumping back on the preprocessor bandwaggon last year:

- If you still look at bits of CSS and think "that's magic - I can't see why it works", then you should probably aviod Sass for now and get a better understanding of the various [CSS specs](http://www.w3.org/Style/CSS/specs.en.html).
- You should read the generated CSS regularly. If it's not the sort of CSS you'd actually write, then you're writing bad Sass.

Assuming that you've read this far and I haven't put you off with all this preprocessor-negativity, it's time for some positives.

## Why do I use a preprocessor?

There are a whole bunch of features in Sass, but I don't really use all of them. I'm someone who likes writing CSS and I'm acutely aware how easy it is to over-abstract in the name of DRY and 'possible future reuse'. Perhaps at some point I'll begin to use some of the more advanced features, but for now I use sass for four reasons:

1. Code Organisation
2. Nested rules & media queries
3. Variables & functions
4. Mixin libraries

If you're aiming to 'ease' into Sass, then it might be an idea to introduce these one at a time. Thanks to SCSS being a superset of CSS, it's possible to convert a legacy codebase to SCSS a little at a time.

### 1. Code Organisation

Organising CSS isn't exactly the easiest thing in the world. We all know that having too many HTTP requests isn't a good idea. Look at this:

{{image:1}}

That's 16 HTTP requests for CSS on the login page alone. Many of those will be cached but it'd probably be better if we could serve one minified CSS file.

The problem with that is code organisation: the CSS for a *very small* project I'm working on right now, excluding comments and code pulled in from plugins, runs to about 7,000 lines. Which ever way you look at it, that's hard to manage.

Wouldn't it be nice if we could keep all the CSS for `widget-X` in it's own CSS file? That way, we'd know exactly where to look if we wanted to change the widget's styling.

With Sass, we can split up our CSS into as many files as we need, and use `@import` statements to pull them all together and minify them. Here's a screenshot of a project's Scss folder:

{{image:2}}

The structure is up to you, but in the screenshot above you can see a bunch of folders inside `scss/`. the base folder contains global styling…

| File          | Contents  |
| ------------- |-----------|
| _base.scss | Global rules |
| _helpers.scss | Classes like `.clearfix` |
| _layout.scss | Global layout rules and grids |
| _normalise.scss | [This CSS reset](http://necolas.github.io/normalize.css/) |
| _print.scss | Print styles
| _shame.scss | [Hacky stuff that needs fixing](http://csswizardry.com/2013/04/shame-css-full-net-interview/) |
| _typography.scss | Type setting and a baseline grid |
| _variables.scss | Global Sass variables which I'll explain later |

The [bourbon](http://bourbon.io), [fontawesome](http://fontawesome.io) and [neat](http://neat.bourbon.io) folders contain mixins and the like (which, because they're kept separate, can be easily updated using something like [Bower](http://bower.io)).

The modules folder contains code specific to each 'module' (or widget) in the project. You can see that the navigation has it's own module, as does the featured product.

This makes it stupidly easy to change something about the navigation - I can just hit <kbd>Cmd</kbd> + <kbd>T</kbd> in [Sublime](http://www.sublimetext.com/3) and jump straight to the `navigation.scss` file. No more scrolling up and down massive CSS files.

We can pull all of these together into one file by importing them. Here's my main.scss file, which will be compiled to main.css.

````scss
//Import bourbon
@import "bourbon/bourbon";
@import "neat/neat";
@import "fontawesome/font-awesome";

//Import mixin Library
@import "/Users/danny/Dropbox/Manyhats/Internal/Code Templates/mixin-library/mixins.scss";

// Import basic Styles & layout
@import "base/normalize";
@import "base/variables";
@import "base/base";
@import "base/typography";
@import "base/layout";

// Import Modules:
@import "modules/example-module";
@import "modules/navigation";
@import "modules/featured-product";

// Import Print & Helpers
@import "base/helpers";
@import "base/print";

// Import shame.scss (for shit that's broken and needs refactoring)

@import "base/shame";
````

Another big advantage to this modular approach comes when you're working with a large team using version control. It's easy to see what others are changing just from the files they've touched in a particular commit.

All of this makes it possible to adopt a [more atomic](http://coding.smashingmagazine.com/2013/08/02/other-interface-atomic-design-sass/) approach to front-end development, which really comes into it's own when working on large-scale applications. Brad Frost has written [a great article on the subject](http://bradfrostweb.com/blog/post/atomic-web-design/)[^1].

### 2. Nested Rules & Media Queries

My second-most-useful-thing-about-sass goes hand-in-hand with the first. It's another way to keep my CSS organised.

Let's look at media queries. A lot of people keep their media queries somewhere near the bottom of that big ol' CSS file. But what happens if we want to change the layout of our widget? We've got to look in **at least two places** to find the code that relates to it. Even if we keep our media queries with the code they affect, we've still got to update the selectors for each breakpoint if we ever change them.

With Sass, we can nest selectors and media queries inside other selectors. Take this code for our widget:

````scss
.widget {

  /* Style the widget */
  display: block;
  background: #ccc;

  /* Style the headings in the widget */
  h1, h2, h3 {
    border-bottom: 1px solid #aaa;
    font-size: 2rem;

    @media screen and (min-width: 30em) {
      font-size: 4rem;
      font-weight: 100;
    }
  }

  /* Style any links in the widget */
  a {
    text-decoration: none;
    color: red;
    &:hover {text-decoration: underline}
  }
}
````

The nesting makes it pretty obvious that all of the code here will apply only to stuff inside the widget, but look how many times I've had to type `.widget`. Once. How much easier is it for me to change the class of my widget to `.thinggy` now?

This is what the code above looks like when compiled to CSS:

````scss
/* Style the widget */
.widget {
  display: block;
  background: #ccc;
}

/* Style the H1 in the widget */
.widget h1,
.widget h2,
.widget h3 {
  border-bottom: 1px solid #aaa;
  font-size: 2rem;
}

@media screen and (min-width: 30em) {
  .widget h1,
  .widget h2,
  .widget h3 {
    font-size: 4rem;
    font-weight: 100;
  }
}

/* Style any links in the widget */
.widget a {
  text-decoration: none;
  color: red;
}
.widget a:hover {
  text-decoration: underline;
}
````

There's one caveat here though — it's very easy to write nested Sass that spits out stupidly long CSS selectors. If that's what we need then it's not a problem, but there's little point having a selector like:

````scss
.widget .highlighted p span a.current .link-arrow
````

when `.widget .link-arrow` would do the same job.

We should always think about the CSS our Sass will produce, and only nest if it's useful.

### 3. Variables & Functions

One of the most obvious advantages of a preprocessor like Sass is the availability of variables. If we want to change a colour, for instance, we can change it in just one place (rather than having to find everywhere that `#0087AF`) is defined. Sass variables are incredibly useful for defining colours and sizes that are used across a project or module — I tend use them in two ways:

Stuff that is site-wide tends to go in it’s own `_variables.scss` file:

````scss
// Colours
$default-color: white;
$primary-color: #458DC5;
$success-color: #6EB268;
$info-color: #67BFDB;
$warning-color: #ECAD5E;
$danger-color: #D15D52;


// Sizes
$header-bar-height: 3.5em;
$header-bar-breakpoint: 800px;

$footer-height: 50px;
$header-height: 46px;
````

Sometimes, I end up with a particular size that I’m using again and again in just one module. In that case, we can abstract that out into a variable that lives within the module:

````scss
$widget_highlight_color: #f44653;
.widget {

  /* Style the widget */
  display: block;
  background: #ccc;
  border: 1px solid $widget_highlight_color;

  /* Style the headings in the widget */
  > h1, h2, h3 {
    color: $widget_highlight_color;
    border-bottom: 1px solid $widget_highlight_color;
    font-size: 2rem;

    @media screen and (min-width: 30em) {
      font-size: 4rem;
      font-weight: 100;
    }
  }
}
````

Sass also makes a bunch of colour-manipulation functions available to us so we can do things like:

````scss
color: $widget_highlight_color;
border-bottom: 1px solid darken($widget_highlight_color, 20%)
````
Having said all that, it's very easy to go overboard and ‘variableize’ every colour and size in our CSS. This isn’t always necessary, and can often lead to enormous amounts of complexity where they really aren’t needed.

Along with the built-in functions like `darken()`, Sass also gives us the ability to write our own. Let’s say we’re setting up a typographic hierarchy with a base font size and line height in pixels. We could write a function to convert that into ems for us, but then we’d run into all the difficulties associated with using em’s on a big project (typographic scales are a topic for another time). Thanks to the reasonably wide-spread support for rems, I’ve taken to writing my vertical sizes like this:

````scss
height: 5.2rem;
height: 52px; /* fallback for older browsers */
````

Assuming the height of a line in my baseline grid is 26px/2.6rem, this represents two `line-height’s` worth of space, or two lines in my grid. Wouldn’t it be nice if, instead of getting the calculator out and multiplying the number of vertical lines by the line-hight, we could just add

````scss
lines(2)
````

to our CSS? Here’s a function that lets us do that:


````scss
$base: 16;
$line-height: 26;

$base-rem: $base / 10;
$line-height-rem: $line-height / 10;

/* Convert lines into rems or pixels
   Usage:
     height: lines(2); #=> height: 5.2rem;
     height: lines-px(2); #=> height: 52px;
*/

@function lines($lines)    {@return $lines * $line-height-rem * 1rem;}
@function lines-px($lines) {@return $lines * $line-height * 1px;}
````

If I want a widget to be six lines high, I can just do this:

````scss
height: lines(6);
height: lines-px(6); /* fallback for older browsers */
````

As with variables, it’s very easy to get carried away with functions and vastly over-complicate your code. Sometimes it’s easier and less confusing to manually calculate sizes. That said, if they’re used carefully, functions can be enormously useful and can actually *reduce* the complexity of your code. 

### 4. Mixin Libraries

Sass offers two other ways to abstract parts of our code and avoid repetition: [Extends](http://sass-lang.com/guide#7) and [Mixins](http://sass-lang.com/guide#6). When used properly, both of these are fantastically useful.

Rather than explaining what they are and some of the possible pitfalls, I’ll let Hugo Giraudel do it with his excellent article [Sass: Mixin or Placeholder?](http://www.sitepoint.com/sass-mixin-placeholder/).

I’ll wait while you read it.

When using mixins, there’s a big danger that we’ll add an enormous amount of repetition to our generated CSS. Let’s say we have a really long mixin:

````scss
@mixin pretty-border() {
  <lots of properties>
}
````

And we then use that in loads of our widgets:

````scss
.widget1 {
  float: left;
  @include pretty-border;
}

.widget2 {
  float: right;
  @include pretty-border;
}
````

The generated CSS would include all of our `<lots of properties> `for both `.widget` classes. Although we can mitigate this (as  Hugo explains) by using `@extend` instead, it might well be better to create a new class of `.pretty-border` which we apply to the HTML elements directly. So, as with everything else, **be aware of the generated CSS** when working with a preprocessor.

One of the nicest things about mixins is their ability to abstract away some of the boring repetitive stuff we have to do.  Take vendor prefixes:

````css
.gradiant {
  background: -webkit-linear-gradient(red, blue); /* For Safari 5.1 to 6.0 */
  background: -o-linear-gradient(red, blue); /* For Opera 11.1 to 12.0 */
  background: -moz-linear-gradient(red, blue); /* For Firefox 3.6 to 15 */
  background: linear-gradient(red, blue); /* Standard syntax */
}
````

There’s no arguing that it’s rubbish having to change a property in four places. With Sass, we could put this into a mixin and call something like:

````scss
.gradiant {
  @include linear-gradient(red, blue)
}
````

There’s a whole bunch of frameworks that provide useful mixins like this, [Compass](http://compass-style.org) being the most well-known. 

The trouble I have with Compass is the complexity it can add to your codebase. I prefer the more lightweight libraries, [Bourbon](http://bourbon.io/docs/) and [Neat](http://neat.bourbon.io/docs/). Check out the documentation to see what magic they can do for you.

## Should you use a preprocessor?

Here are those two ‘rules’ I mentioned earlier:

- If you still look at bits of CSS and think "that's magic - I can't see why it works", then you should probably aviod Sass for now and get a better understanding of the various [CSS specs](http://www.w3.org/Style/CSS/specs.en.html).
- You should read the generated CSS regularly. If it's not the sort of CSS you'd actually write, then you're writing bad Sass.

Providing you bear them in mind, **yes, you most definitely should use a preprocessor**.

If you're still dubious, why don't you pick a smallish project and convert it to  use SCSS? You could start by separating your code into separate files and adding a few variables, perhaps.

[^1]: Jonathan Snook's <http://smacss.com> is a fantastic place to start with modular CSS, although I don't agree with everything he proposes.
