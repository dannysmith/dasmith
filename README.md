# danny.is

[![Stories in Ready](https://badge.waffle.io/dannysmith/dasmith.png?label=ready&title=Ready)](https://waffle.io/dannysmith/dasmith)
[ ![Codeship Status for dannysmith/dasmith](https://codeship.com/projects/0d2ad730-cb31-0132-b672-466a8264ab3c/status?branch=master)](https://codeship.com/projects/75685)
[![Coverage Status](https://coveralls.io/repos/dannysmith/dasmith/badge.png)](https://coveralls.io/r/dannysmith/dasmith)
[![Dependency Status](https://gemnasium.com/dannysmith/dasmith.png)](http://gemnasium.com/dannysmith/dasmith)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/dannysmith/dasmith?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) 

This is [danny.is](http://danny.is). It's a [Sinatra](http://www.sinatrarb.com/) application that parses [markdown](http://daringfireball.net/projects/markdown/) files and turns them into a simple blog. It was thrown together in a day and so is a little rough around the edges. Why did I build this instead of using a static site genrator like [Middleman](http://middlemanapp.com/)? Well, for a number of reasons:

* I want *absolute* control over everything. I'm not a fan of magic unless I understand it.
* I wanted an app, rather than a static site. Although I don;t do much at the moment, I might want to add some dynamic stuff in the future.
* I wanted a simple way of including images and din't fancy hacking Middleman.
* I want a place to play about with ruby and SASS/CSS.

Although it's not really intended for general consumption (the world really doesn't need *another* markdown > blog engine), you can use it like this...

## Installation and Use

### Running Locally

I'm using [Guard](https://github.com/guard/guard), so you can just run:

````
bundle install
bundle exec guard
````

And head to http://localhost:3000.

### Writing Posts

To publish a new post, put it in `/articles` with a name like `20130203-some-post-or-other.md`. The only part of the filename that matters is the date, which is in the form YYYYMMDD-. This is used to order the posts correctly. Any articles with a date in the future will only be published at midnight on that date.

Each page must contain some special meatdata for it to be correctly rendered - the post's title, slug and post ID. The post ID must be unique, but the slug and title don't need to be:

````
title: This is the Second Post
slug: no-2
post_id: 1

#!!====================================

The rest of the article...
````

Posts should be written in [markdown](http://daringfireball.net/projects/markdown/), and the site supports the following PHP-markdown style features:

* Tables
* Fenced codeblocks with syntax highlighting.
* Strikethrough (with `~~something~~`).
* Superscript (with `2^nd`).
* Underlines (with `_underlined_`).
* Highlighting (with  `==highlighted==`).
* Footnotes (with `Something[^1]` and then `[^1]: This is a footnote`).

In addition, two special tags are available:

````
{{gist:http://gist.github.com/name/000}}
````

will instert the code to display the gist, and

````
{{image: 1}}
````

will insert an image with a caption (see below). Note that `{{imageraw:1}}` is also available and will just inser the image, without wrapping it in a `<figure>` tag or adding a caption.

### Images

I wanted an easy way to save a series of images or screenshots and then insert them into an article where appropriate. Although you can happily use a normal markdown image tag, if you save images in the `/public/article-images` directory with a filename like this:

`2-3-Some-image-description.png`

then it's possible to use the `{{image:1}}` syntax above to insert them into articles. The first number in the filename is the post_id or the relevant post. The second number is the image number, ahile the remainder of the filename will be used as the figure caption. The image above could be inserted into the article (with `post_id: 2`) using `{{image:3}}`. It would have a caption of *Some image description*.

## Working on a new Feature

Create a local feature branch based on master.

    git checkout master
    git pull
    git checkout -b <branch-name>

Rebase frequently to incorporate upstream changes.

    git fetch origin
    git rebase origin/master

Resolve conflicts. When feature is complete and tests pass, stage the changes.

    git add --all

When you've staged the changes, commit them.

    git status
    git commit --verbose

Write a good commit message.

If you've created more than one commit, use a rebase to squash them into
cohesive commits with good messages:

    git rebase -i origin/master

Share your branch.

    git push --force origin <branch-name>

Subit a pull request on github. (Assumes you have the [hub gem](https://github.com/github/hub) installed).

    git pull-request

View a list of new commits. View changed files. Merge branch into master.

    git log origin/master..<branch-name>
    git diff --stat origin/master
    git checkout master
    git merge <branch-name> --ff-only
    git push

Delete your remote feature branch.

    git push origin --delete <branch-name>

Delete your local feature branch.

    git branch --delete <branch-name>


## Project Status

Clearley this is a very personal project and is a work in progress. Because it's just intended for me to use, there isn't a great deal of error handling built in. That said, feel free to clone/fork and use it yourself.



[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/dannysmith/dasmith/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

