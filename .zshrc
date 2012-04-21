#
# .zshrc
#
# maintained by pirosikick
#

# alias
alias ls="ls -ahGF"
alias ll="ls -lahGF"
alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim -u $HOME/.vimrc "$@"'

# global alias
alias -g G='| grep'
alias -g L='| vim -R -'
alias -g ID='`id -u`'

# prompt
autoload -Uz add-zsh-hook
autoload -Uz colors; colors
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true

autoload -Uz is-at-least
if is-at-least 4.3.10; then
    # この check-for-changes が今回の設定するところ
    zstyle ':vcs_info:git:*' check-for-changes true
    zstyle ':vcs_info:git:*' stagedstr "+"    # 適当な文字列に変更する
    zstyle ':vcs_info:git:*' unstagedstr "-"  # 適当の文字列に変更する
    zstyle ':vcs_info:git:*' formats '(%s)-[%b] %c%u'
    zstyle ':vcs_info:git:*' actionformats '(%s)-[%b|%a] %c%u'
fi

function _update_vcs_info_msg() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info_msg

PROMPT="%{$fg[green]%}%~ %#%{$reset_color%} "
RPROMPT="%{$fg[red]%}☁  %1(v|%F{red}%1v%f|) %{$fg[cyan]%}%* %{$fg[blue]%}%n@%m ☁%{$reset_color%}"
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
