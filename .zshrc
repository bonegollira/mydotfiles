#
# .zshrc
#
# maintained by hanai
#

# export env
export LANG=ja_JP.UTF-8
export PATH=$PATH:$HOME/bin

# alias
alias ls="ls -ahGF"
alias ll="ls -lahGF"
alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim -u $HOME/.vimrc "$@"'

# global alias
alias -g G='| grep'
alias -g L='| vim -R -'
alias -g ID='`id -u`'


# emacs like key bind
bindkey -e

# RVM
[ -s ${HOME}/.rvm/scripts/rvm ] && source ${HOME}/.rvm/scripts/rvm

# history
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt share_history
setopt share_history

setopt auto_pushd 

setopt auto_menu

setopt auto_param_keys

setopt no_beep

setopt no_list_types

setopt magic_equal_subst

autoload -U compinit && compinit

# disable Ctrl-s, Ctrl-q
setopt no_flow_control

#
# PROMPT settings
autoload -Uz colors
colors

PROMPT="%{$fg[green]%}%#%{$reset_color%} "
RPROMPT="%{$fg[cyan]%}%W %T %{$fg[red]%}%n@%m %{$fg[blue]%}%~%{$reset_color%}"
PROMPT2="%{$fg[cyan]%}%_%> %{$reset_color}"
SPROMPT="%{$fg[red]%}%r is correct? [n,y,a,e]: %{$reset_color}"
[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
    PROMPT="%{$fg[white]%}${HOST%%.*} ${PROMPT}"

# terminal title
case "${TERM}" in
kterm*|xterm)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac
