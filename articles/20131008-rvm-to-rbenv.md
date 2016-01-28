title: Switching from RVM to rbenv
article_id: 3
slug: switching-from-rvm-to-rbenv

#!!==========================================================

A few days ago I [threw together a new website](http://danny.is/writing/new-job-new-website-131002) for myself, built in ruby and styled with [Sass](http://sass-lang.com/). I'm also about to embark on a new project to rebuild an existing PHP-driven API in ruby, primarily as a demonstration of how quickly it's possible to make things using ruby, and because API design is fascinating me at the moment.

Before embarking on these projects, I decided that I wanted to sort a few things out:

1. A decent local ruby environment that I actually understand.
2. An easy way to do things like compile assets and refresh my browser when developing locally.
3. A decent build process for the API project.

I've got a copule of articles in the works covering the latter two points but for now, I'd like to talk about the first one.

# RVM pisses me off

To be fair, [RVM](https://github.com/wayneeseguin/rvm) was a lifesaver when I first installed it. Before that, I had no way of managing different ruby versions or the gems that went with them and spent far too much of my time trying to work out why some old project wouldn't run. My system was littered with old gem versions (including Rails 0.9!) and it wasn't pleasant. Along came RVM to the rescue -- with gemsets so I could manage things on a per-project basis. Great.

Them problem was, I had no idea where any of those gems were kept, or where the ruby versions were, or what RVM had done to my shell (not to mention `rvm gemset use project@1.8.7-wtf123`). I probably should have paid more attention when I installed it all.

With the advent of [Bundler](http://bundler.io/), my headaches regarding gem management were reduced somewhat, but what if I ran `bundle install` in the wrong gemset?

# rbenv is much cooler

Mostly because I get it. Coupled with bundler, it allows me to pretty much ignore my ruby version and gem management and feel confident that when I `cd` into a project's folder, all I have to do is `bundle install` and get on with my work. I also freed up a considerable amount of space on my hard drive by binning millions of gems.

I toyed with writing in great detail about the installation process for [rbenv](https://github.com/sstephenson/rbenv) (and how to get rid of RVM), but plenty of other people have written about that. Instead, I thought I'd share the steps I took to get it all sorted. This isn't so much of a 'howto', as a dump of my bash history.

**Disclaimer Thing:** I ran into a few issues, and spent quite a bit of time googling - the following process is the result of that googling and I'm afraid I can't remember all (read: any) of my sources. I may also have forgotten some stuff I did, so don't come after me with a pitchfork if it doesn't work.

# Stuff I did to switch from RVM to rbenv

Kill off RVM:

````bash
rvm implode
gem uninstall rvm
sudo rm -rdf /etc/rvmrc
rm -rdf ~/.rvmrc
sudo rm -rds ~/.rvm
sudo rm -rdf /etc/profile.d/rvm
````

Remove the RVM wrappers from `/usr/local/bin`

````bash
sudo rm -f /usr/local/bin/erb
sudo rm -f /usr/local/bin/gem
sudo rm -f /usr/local/bin/irb
sudo rm -f /usr/local/bin/rake
sudo rm -f /usr/local/bin/rdoc
sudo rm -f /usr/local/bin/ri
sudo rm -f /usr/local/bin/ruby
sudo rm -f /usr/local/bin/testrb
````

Get rid of any references to RVM in your `.bashrc`, `.profile`, `.irbc` and `.bash_profile`. This obviously depends how you set it up. I restarted my machine here, just to make sure I had a clean slate -- that's probably not needed, though.

Install [Homebrew](http://brew.sh/) and then install rbenv (I already had homebrew installed):

````bash
brew update
brew upgrade `brew outdated`
brew install rbenv
brew install ruby-build
````

If you've already got homebrew installed, check that you have `brew --repository/Library/Contributions/brew_bash_completion.sh` in your `.bash_profile`.

Get rid of the default gems from before you were using RVM (I also updated the the system gems and rubygems itself just so I had a 'clean' system installation of ruby):

````bash
which ruby
ruby -v
gem list
for i in `gem list --no-versions`; do sudo gem uninstall -aIx $i; done
gem update --system
gem update
````

Double-check for old versions, just in case:

````bash
/usr/bin/gem list --no-versions
````

Install [rbenv-default-gems](https://github.com/sstephenson/rbenv-default-gems) and include the gems that I always want installed with new ruby versions:

````bash
brew install rbenv-default-gems
echo -e "bundler\nhirb\nbrice\nawesome_print\njson\nrake\http\npry" >> ~/.rbenv/default-gems
````

Install ruby using rbenv and set 2.1.4 as the global default:

````bash
rbenv install 1.9.3-p550
rbenv install 2.1.4
````

Rehash and check that the right version is installed, and that all the gems have been installed correctly:

````bash
ruby --version
rbenv rehash
gem list
````

Install rbenv-bundler:

````bash
git clone -- git://github.com/carsomyr/rbenv-bundler.git ~/.rbenv/plugins/bundler
````

Install the [heroku toolbelt](https://toolbelt.herokuapp.com/) and login:

````bash
heroku login
````

The last thing I did was `cd` into a project using 1.9.3 and check everything was working, then rebuild the system locate database:

````bash
cd /old-project
ruby -v #=> 2.1.4-pXXX
rbenv local 1.9.3-p550
ruby -v #=> 1.9.3-p550
bundle install # Does it work?
cd ..
ruby -v #=> 2.0.0-p247

sudo /usr/libexec/locate.updatedb # Update locate database
````

That's it.

Like I said, this isn't meant to be a complete walkthrough, I just hope that some of the bits here will be useful to anyone else doing the same thing.
