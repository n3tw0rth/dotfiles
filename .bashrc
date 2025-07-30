set -o vi
bind -x '"\C-l": clear'

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='$(__git_ps1 "(%s)") ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# change the fzf and fzf-tmux color to 
export FZF_DEFAULT_OPTS='--color=fg:#9AA6B2,bg:#000000,hl:#9AA6B2,prompt:#9AA6B2,pointer:#9AA6B2,marker:#9AA6B2,spinner:#9AA6B2,header:#9AA6B2'

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias rg='rg --hidden'
alias g='git'
alias vi='nvim'
alias lg='lazygit'
alias notify='completion-notifier'
alias terraform='notify -t approve,Enter terraform'
alias j='jired'
alias z='zoxide'

alias find='vi "$(fzf-tmux -p --reverse | head -n1)"'

# to enable completions for git with the alias
source /usr/share/bash-completion/completions/git
__git_complete g __git_main

alias lgit='lazygit'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# tmux
export force_color_prompt=yes

export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/usr/local/bin:$PATH

# Automatically mirror displays if a second monitor is connected
if command -v xrandr > /dev/null; then
    # Get the primary monitor (first connected monitor)
    PRIMARY_MONITOR=$(xrandr | grep " connected primary" | cut -d' ' -f1)
    
    # If no primary monitor is found, find the first connected monitor
    if [ -z "$PRIMARY_MONITOR" ]; then
        PRIMARY_MONITOR=$(xrandr | grep " connected" | head -n 1 | cut -d' ' -f1)
    fi

    # Get the second connected monitor (if any)
    SECONDARY_MONITOR=$(xrandr | grep " connected" | grep -v "$PRIMARY_MONITOR" | head -n 1 | cut -d' ' -f1)

    # If both monitors are connected, mirror the primary monitor to the secondary
    if [ -n "$SECONDARY_MONITOR" ]; then
        xrandr --output "$PRIMARY_MONITOR" --auto --output "$SECONDARY_MONITOR" --auto --same-as "$PRIMARY_MONITOR"
    fi
fi

# keychains
eval `keychain --eval ~/.ssh/id_rsa --quiet --quick`
eval `keychain --eval ~/.ssh/keys/rsa-key --quiet --quick`
eval `keychain --eval ~/.ssh/keys/ssh-key-surge --quiet --quick`

# starship
eval "$(starship init bash)"
export STARSHIP_LOG=error

#brew
# disable brew auto updates
export HOMEBREW_NO_AUTO_UPDATE=1

# Custom Binaries
export PATH=~/.config/bash/bin/:$PATH
. "$HOME/.cargo/env"

# kubectl 
source <(kubectl completion bash)
alias k=kubectl
complete -o default -F __start_kubectl k

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/theekshana/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/theekshana/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/theekshana/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/theekshana/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Remove color from nodejs output
export NO_COLOR=1
