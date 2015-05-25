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
export GOPATH=$HOME
export DOCKER_HOST=tcp://127.0.0.1:4243

eval "$(go env)"

path=(
./node_modules/.bin
$GOPATH/bin
$HOME/.rbenv/bin
$HOME/.phpenv/bin
$HOME/.nodebrew/current/bin
/Applications/MacVim.app/Contents/MacOS/
/usr/local/bin
/usr/local/php5/bin
/usr/sbin
$path
)

fpath=(
$HOME/.zfunc
$fpath
)

which rbenv > /dev/null
if [ $? = 0 ]; then
    eval "$(rbenv init -)"
fi

which phpenv > /dev/null
if [ $? = 0 ]; then
    eval "$(phpenv init -)"
fi
