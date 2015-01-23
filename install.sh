#!/bin/bash

# Install rbenv + ruby-build
echo "Install rbenv + ruby-build."

if [ hash rbenv 2>/dev/null ]; then
    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

    echo "Finised!";
else
    echo "Already installed.";
fi

# Install nodebrew
echo "Install nodebrew."

if [ hash nodebrew 2>/dev/null ]; then
    curl -L git.io/nodebrew | perl - setup
    echo "Finished!"
else
    echo "Already installed. Update.";
    nodebrew selfupdate
fi

PWD=`pwd`
DOTS=".gitconfig .vimrc .gvimrc .zshrc .zshenv .zsh .gemrc .tmux.conf"

echo "Link dotfiles: $DOTS"

for dotfile in $DOTS
do
    ln -snf $PWD/$dotfile ~/$dotfile
done

# Install neobundle.vim
echo "Install neobundle.vim."
curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh

unamestr=`uname`
if [[ $unamestr == 'Darwin' ]]; then
    if [ hash brew 2>/dev/null ]; then
        # Install nodebrew
        echo "Install nodebrew."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
fi
