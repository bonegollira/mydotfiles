alias ls="ls -ahGF"
alias ll="ls -lahGF"
alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim -u $HOME/.vimrc "$@"'
alias -g G='| grep'
alias -g L='| vim -R -'

export LANG=ja_JP.UTF-8
export PATH=$PATH:$HOME/bin

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

#
# PROMPT settings

# colors
local    gray=$'%{\e[0;30m%}'
local     red=$'%{\e[0;31m%}'
local   green=$'%{\e[0;32m%}'
local  yellow=$'%{\e[0;33m%}'
local    blue=$'%{\e[0;34m%}'
local  purple=$'%{\e[0;35m%}'
local skyblue=$'%{\e[0;36m%}'
local   white=$'%{\e[0;37m%}'

# bold colors
local    GRAY=$'%{\e[1;30m%}'
local     RED=$'%{\e[1;31m%}'
local   GREEN=$'%{\e[1;32m%}'
local  YELLOW=$'%{\e[1;33m%}'
local    BLUE=$'%{\e[1;34m%}'
local  PURPLE=$'%{\e[1;35m%}'
local SKYBLUE=$'%{\e[1;36m%}'
local   WHITE=$'%{\e[1;37m%}'
local DEFAULT=$'%{\e[m%}'

case ${UID} in
0)
    # for root
    PROMPT="$RED%n@%m %/#$DEFAULT "
    PROMPT2="$RED%_#$DEFAULT "
    RPROMPT="[%~]"
    SPROMPT="$RED%r is correct? [n,y,a,e]:$DEFAULT "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="${HOST%%.*} ${PROMPT}"
    ;;
*)
    PROMPT="$green%#$DEFAULT "
    RPROMPT="$gray%W %T $red%n@%m$DEFAULT $blue%~$DEFAULT"
    PROMPT2="$GREEN%_%%$DEFAULT "
    SPROMPT="$GREEN%r is correct? [n,y,a,e]:$DEFAULT "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="$WHITE${HOST%%.*} ${PROMPT}"
    ;;
esac

# terminal title
case "${TERM}" in
kterm*|xterm)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac
