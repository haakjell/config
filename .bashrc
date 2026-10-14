#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Prompt (hh:mm hakon <dir> $)
export PS1='\[\e[36m\]\A\[\e[m\] \[\e[32m\]hakon\[\e[m\] \[\e[37m\]\W\[\e[m\] \[\e[36m\]\$\[\e[m\] '

# Without username (hh:mm <dir> $)
#export PS1='\[\e[36m\]\A\[\e[m\] \[\e[37m\]\W\[\e[m\] \[\e[36m\]\$\[\e[m\] '

# WSL (hh:mm WSL <dir> $)
#export PS1='\[\e[36m\]\A\[\e[m\] \[\e[38;5;178m\]WSL\[\e[m\] \[\e[37m\]\W\[\e[m\] \[\e[36m\]\$\[\e[m\] '

# Enable ls colorized
# and other ls aliases
alias ls='ls --color=auto'
alias la="ls -a"
alias ll="ls -la"
alias sl="sl -l"

# cd aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Clear screen with clr
alias clr="clear"

# Open windows exporer to current working directory
alias here="explorer ."

# Use neovim
alias vim="nvim"

# cd to Google Drive
alias drive="cd 'G:/My Drive/'"

# Python aliases
alias py="python"
alias pip="pip3"

# Open todo.md in vim
alias todo="vim ~/todo.md"

# Scoop package manager
alias ins="scoop install"
alias rem="scoop uninstall"
alias upd="scoop update"
alias search="scoop search"
alias st="scoop status"

# Typo
alias gti="git"

# sl command (essential)
alias sl="wsl sl -l"

# Copy tree to clipboard
alias tree="wsl tree --gitignore | iconv -f utf-8 -t utf-16le | clip"

# Set default editor
export VISUAL="nvim"
export EDITOR="nvim"

