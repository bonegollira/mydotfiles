#
# .zshrc
#
# maintained by hanai
#

umask 022

# export env
export EDITOR=vim
export PAGER=less
export GREP_OPTION='--color=auto'
export LANG=ja_JP.UTF-8
export LESS='--tabs=4 --no-init --LONG-PROMPT --ignore-case'

fpath=($fpath $HOME/.zfunc)
path=($path $HOME/.bin)

# alias
alias ls="ls -ahGF"
alias ll="ls -lahGF"
alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim -u $HOME/.vimrc "$@"'

# global alias
alias -g G='| grep'
alias -g L='| vim -R -'
alias -g ID='`id -u`'

# prompt

autoload -Uz colors
colors

PROMPT="%{$fg[green]%}%~ %#%{$reset_color%} "
RPROMPT="%{$fg[cyan]%}☁  %* %{$fg[red]%}%n@%m ☁%{$fg[blue]%}%{$reset_color%}"
PROMPT2="%{$fg[cyan]%}%_%> %{$reset_color}"
SPROMPT="%{$fg[red]%}%r is correct? [n,y,a,e]: %{$reset_color}"

# terminal title
case "${TERM}" in
kterm*|xterm)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac

# RVM
[ -s ${HOME}/.rvm/scripts/rvm ] && source ${HOME}/.rvm/scripts/rvm

autoload -U compinit && compinit

# history
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# options
setopt share_history
setopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_no_functions
setopt hist_no_store
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_expire_dups_first
setopt ignore_eof
setopt auto_pushd 
setopt auto_cd
setopt pushd_ignore_dups
setopt cdable_vars
setopt auto_menu
setopt auto_param_keys
setopt no_beep
setopt no_list_types
setopt magic_equal_subst
setopt no_flow_control
setopt prompt_subst
setopt list_packed
setopt complete_aliases
setopt list_types

# emacs like key bind
bindkey -e

# Ctrl+P, Ctrl+N
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

autoload smart-insert-last-word
zle -N insert-last-word smart-insert-last-word
zstyle :insert-last-word match \
      '*([^[:space:]][[:alpha:]/\\]|[[:alpha:]/\\][^[:space:]])*'
bindkey '^]' insert-last-word

# functions
function chpwd () { ls }

function zshrc () { source $HOME/.zshrc }
