#
# .zshrc
#
# maintained by pirosikick
#

OSTYPE=`uname`

# alias
alias ls="ls -ahGF"
alias ll="ls -lahGF"
alias bi="bundle install --path vendor/bundle"
alias be="bundle exec"
alias re="rbenv exec"
alias mvim="/Applications/MacVim.app/Contents/MacOS/mvim"
alias gitvdiff='git difftool --tool=vimdiff --no-prompt'
alias iojs='nodebrew exec io@v1.0.1 -- node'

# http://qiita.com/Kuniwak/items/b711d6c3e402dfd9356b
alias g='git'

alias -g B='`git branch -a | peco --prompt "GIT BRANCH>" | head -n 1 | sed -e "s/^\*\s*//g"`'
alias -g R='`git remote | peco --prompt "GIT REMOTE>" | head -n 1`'
alias -g H='`curl -sL https://api.github.com/users/pirosikick/repos | jq -r ".[].full_name" | peco --prompt "GITHUB REPOS>" | head -n 1`'
alias -g LR='`git branch -a | peco --query "remotes/ " --prompt "GIT REMOTE BRANCH>" | head -n 1 | sed "s/remotes\/[^\/]*\/\(\S*\)/\1 \0/"`'

# global alias
alias -g G='| grep'
alias -g L='| vim -R -'
alias -g ID='`id -u`'
alias -g HL='| pygments -f rtf "style=monokai,fontface=Ricty"'

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

PROMPT="%{$fg[blue]%}%n@%m %{$fg[green]%}%~ %{$fg[red]%}%1(v|%F{red}%1v%f|)%{$fg[green]%}%#%{$reset_color%} "
RPROMPT="%{$fg[cyan]%}%* $OSTYPE%{$reset_color%}"
PROMPT2="%{$fg[cyan]%}%_%> %{$reset_color}"
SPROMPT="%{$fg[red]%}%r is correct? [n,y,a,e]: %{$reset_color}"

if [ "x$VIM" != "x" ]; then
    PROMPT="%{$fg[red]%}[VIM] $PROMPT"
fi

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

compdef g=git

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
setopt transient_rprompt


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
function chpwd () {
  _cdd_chpwd
  ls
}


function zshrc () { source $HOME/.zshrc }

function macvim () {
  local mvim="/Applications/MacVim.app/Contents/MacOS/mvim"

  if [[ ${#@} = 0 ]]; then
    $mvim
  else
    $mvim --remote-tab-silent $@
  fi
}

eval "$(rbenv init -)"

if [ "$TMUX" = "" ]; then
    tmux attach;

    # no sessions
    if [ $? ]; then
        tmux;
    fi
fi

function light() {
    if [ -z "$2" ]; then
        src="pbpaste"
    else
        src="/bin/cat $2"
    fi

    ${=src} |  pygmentize -f rtf -l $1 -O "style=monokai,fontface=Ricty" | pbcopy
}

. ~/.zsh/peco.zsh
. ~/.zsh/cdd.zsh
. ~/.zsh/npm.zsh
