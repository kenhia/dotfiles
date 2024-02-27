#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Rust
. "$HOME/.cargo/env"

# autojump
[[ -s /home/ken/.autojump/etc/profile.d/autojump.sh ]] && source /home/ken/.autojump/etc/profile.d/autojump.sh

# eza
alias ls='eza'
alias ll='eza --long --git --icons'

# Paths
export PATH="/home/ken/bin:$PATH"

# Functions
# oh-my-posh
eval "$(oh-my-posh init bash --config /home/ken/.cache/oh-my-posh/themes/kone.omp.json)"

# readmd () {
#  pandoc $1 | lynx -stdin
#}

# Colorize man pages (a bit)
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export MANROFFOPT="-P -c"


source /home/ken/.config/broot/launcher/bash/br

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
