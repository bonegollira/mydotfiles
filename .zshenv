#
# .zshenv
#
# maintained by pirosikick
#

umask 022

# export env
export EDITOR=vim
export SVN_EDITOR=vim
export PAGER=less
export GREP_OPTION='--color=auto'
export LANG=ja_JP.UTF-8
export LESS='--tabs=4 --no-init --LONG-PROMPT --ignore-case'

path=(
$HOME/.bin
$path
)

fpath=($fpath $HOME/.zfunc)
