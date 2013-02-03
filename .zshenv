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
export LANG=en_US.UTF-8
export LESS='--tabs=4 --no-init --LONG-PROMPT --ignore-case'

path=(
$HOME/.rbenv/bin
$HOME/bin
$HOME/.nodebrew/current/bin
/Applications/MacVim.app/Contents/MacOS/
/usr/local/php5/bin
$path
)

fpath=($fpath $HOME/.zfunc)

which rbenv > /dev/null
if [ $? = 0 ]; then
    eval "$(rbenv init -)"
fi
