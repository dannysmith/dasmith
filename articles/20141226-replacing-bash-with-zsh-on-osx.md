title: Replacing Bash with ZSH on OSX
article_id: 9
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

Much of my [.zshrc file](https://github.com/dannysmith/dotfiles/blob/master/.zshrc) was move directly from my `.bash_profile`. Let's walk through the file:

First, we set the `ZSH` variable to point to the loaction of our oh-my-zsh installation, and set the ZSH theme to use. I called my theme `dannysmith.zsh-theme`.

````bash
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="dannysmith"
````

Now we can tell oh-my-zsh to load the plugins we want. Be aware that each of thses will slow down the time it takes to load a new shell, so stick to the ones you actually use. We can also set up a couple of utility environment variables and include our PATH.

````bash
plugins=(bower brew brew-cask bundler cloudapp coffee colored-man colorize common-aliases cp docker gem git git-extras gitignore heroku history osx rails rake rbenv ruby zsh-syntax-highlighting)

# User configuration
source $ZSH/oh-my-zsh.sh

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/dsa_id"

# Code Completion from zsh-completions
fpath=(/usr/local/share/zsh-completions $fpath)

export PATH="/Users/danny/.rbenv/shims:/usr/local/mysql/bin:/usr/local/bin:/usr/local/share/npm/bin:/usr/local/lib/node_modules:/usr/local/git/bin:/usr/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"

# For Travis Gem
[ -f /Users/danny/.travis/travis.sh ] && source /Users/danny/.travis/travis.sh
````

Next, we can set Sublime Text as our default editor and create some aliases for common commands. I've got a lot of aliases for git, since I use it so frequently.

````bash

# NOTE: Sublime text is aliased as "st", through a symlink in /usr/bin.
#Sets SVN, GVS and default editors to Sublime Text 2
export EDITOR="st -w"
export CVSEDITOR="st -w"
export SVN_EDITOR="st -w"

# common typos
alias ts='st'
alias st.='st .'

#Alias for wget
alias wget="curl -O"

# Start SQL
alias smysql="/usr/local/bin/mysql.server start"

# # Enable shims and autocompletion for rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# More Git aliases
alias git='hub'
alias g='git'
alias gst='git status -s'
alias gpull='git pull'
alias gp='git push'
alias gf='git fetch'
alias gd='git difftool'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gcm='git commit -m'
alias gco='git checkout'
alias gb='git branch'
alias gba='git branch -a'
alias glog='git log --oneline --decorate'
alias glogg='git log --oneline --decorate --graph'
alias glogs='git log --oneline --decorate --stat'
alias gcl='git clone'
alias gdc='git difftool --cached'

# #Aliases for ls
alias ll='ls -lh'
alias l='ls -lhA'
alias lsa='ls -a'

alias rm='rm -i'

#Apache commands
alias apaches='sudo apachectl start'
alias apacher='sudo apachectl restart'
alias apachestop='sudo apachectl stop'

# Get OS X Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm update npm -g; npm update -g; sudo gem update --system; sudo gem update'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en1"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
# Enhanced WHOIS lookups
alias whois="whois -h whois-servers.net"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

# Faster npm for europeans
command -v npm > /dev/null && alias npme="npm --registry http://registry.npmjs.eu"

# Kill all the tabs in Chrome to free up memory
# [C] explained: http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

# Shortcuts
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias dev="cd ~/Dropbox/dev"
alias inbox="cd ~/Dropbox/Inbox"
alias docs="cd ~/Dropbox/Documents"
alias docsl="cd ~/Documents"
alias raf="cd ~/RAF"
alias sparta="cd ~/Dropbox/Documents/Sparta"
alias sshsparta="ssh -X danny@unix.spartaglobal.com -R 52698:localhost:52698"
````

# Enabling zsh as the default shell

Finally, we can change the default login shell to zsh:

````bash
chsh -s /usr/local/bin/zsh
````

