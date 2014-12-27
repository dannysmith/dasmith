title: Replacing Bash with ZSH on OSX
post_id: 9
slug: replacing-bash-with-zsh

#!!==========================================================

About a year ago I bought a new MacBook, and while setting it up, I used parts of Thoughtbot’s [laptop](https://github.com/thoughtbot/laptop) setup scripts. Ever since then, I’ve been meaning to switch my shell from bash to zsh. There are a [whole bunch of benefits](http://www.slideshare.net/jaguardesignstudio/why-zsh-is-cooler-than-your-shell-16194692).

## iTerm 2 instead of Terminal

While I’m switching shell, I thought it might be an idea to switch my terminal app too. Although I’ve got no real problems with Terminal.app, iTerm 2 offers a few advantages, the main one being  the HotKey window that allows me to open a terminal anywhere with a key combination (in my case <kbd>Shift</kbd> + <kbd>Space</kbd>):

{{image: 1}}

Having set this up in term’s preferences, we can set iTerm to open at login and hide the iTerm dock icon with:

```bash
/usr/libexec/PlistBuddy -c 'Add :LSUIElement bool true' /Applications/iTerm.app/Contents/Info.plist
```


## Setting up ZSH

Having dug about on the internet for articles covering zsh, it seems the best way of customizing it is through [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh). Because I'd like to customize my theme, I made a [fork](https://github.com/dannysmith/oh-my-zsh) to work with.

The first thing to do is install zsh using [homebrew](http://brew.sh/) and clone oh-my-zsh into our home directory:

```bash
cd ~
brew install zsh
git clone https://github.com/dannysmith/oh-my-zsh .oh-my-zsh
```

We now need to edit `/etc/shells` and replace the current zsh line with the location of the one installed by homebrew (which should be `/usr/local/bin/zsh`).

We'll deal with setting up the .zshrc file in a minute, which is where we'll look at how to include oh-my-zsh. Before we do, we need to set up a new prompt.

## Custom Prompt

Everyone has their own preference when it comes to their prompt, and oh-my-zsh offers a huge selection. Personally, I like mine to include the current directory and, if we're in a git repo, the current branch and status. If it's clean, we'll show a green star, if it's dirty we'll show a red one:

{{image: 2}}

We can achieve this by adding a new zsh-theme file to our `~/.oh-my-zsh/themes` directory:

````bash
ZSH_THEME_GIT_PROMPT_SUFFIX="$reset_color"
ZSH_THEME_GIT_PROMPT_DIRTY="$fg[red]⋆" # Show if git is dirty
ZSH_THEME_GIT_PROMPT_CLEAN="$fg[green]⋆" # Show if git is clean
purple="%F{135}"

# Create a git prompt showing the current branch
function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo " $purple- $(parse_git_dirty)$fg[yellow]$(current_branch)"
}

# Create the prompt
PROMPT='$fg[cyan]%~$(git_prompt_info)
$fg[green]→$reset_color '

# If we're logged in as root, prefix the arrow with the word ROOT
if [[ "$USER" == "root" ]]; then
PROMPT='$fg[cyan]%~$(git_prompt_info)
$fg[red]ROOT$fg[green]→$reset_color '
fi
````

## .zshrc

Much of my [.zshrc file](https://github.com/dannysmith/dotfiles/blob/master/.zshrc) was move directly from my `.bash_profile`.

# Enabling zsh as the default shell

Finally, we can change the default login shell to zsh:

````bash
chsh -s /usr/local/bin/zsh
````

