#
# ~/.bashrc
#

#
# Utils
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# Command prompts
#
# Prompt (hh:mm hakon <dir> $)
export PS1='\[\e[36m\]\A\[\e[m\] \[\e[32m\]hakon\[\e[m\] \[\e[37m\]\W\[\e[m\] \[\e[36m\]\$\[\e[m\] '
# Without username (hh:mm <dir> $)
# export PS1='\[\e[36m\]\A\[\e[m\] \[\e[37m\]\W\[\e[m\] \[\e[36m\]\$\[\e[m\] '
# WSL (hh:mm WSL <dir> $)
# export PS1='\[\e[36m\]\A\[\e[m\] \[\e[38;5;178m\]WSL\[\e[m\] \[\e[37m\]\W\[\e[m\] \[\e[36m\]\$\[\e[m\] '


# Configure gpin
#
# Repo root, wherever it's cloned (follows symlinks)
CONFIG_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
# Prompt (must come before gpin)
command -v starship >/dev/null && eval "$(starship init bash)"
# Add gpin
[ -f "$CONFIG_DIR/bash/gpin.sh" ] && source "$CONFIG_DIR/bash/gpin.sh"


# Set default editor
export VISUAL="nvim"
export EDITOR="nvim"


#
# Aliases
#

# Enable ls colorized and other ls aliases
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

# Scoop package manager
alias ins="scoop install"
alias rem="scoop uninstall"
alias upd="scoop update"
alias search="scoop search"
alias st="scoop status"

