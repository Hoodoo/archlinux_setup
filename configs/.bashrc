#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
alias ssh='TERM=xterm ssh'
alias startx='ssh-agent startx'
export PATH=/home/hoodoo/.local/bin:$PATH

