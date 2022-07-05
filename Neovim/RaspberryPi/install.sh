#!/bin/bash

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

mkdir -p $HOME/.config/nvim
cp ../init.vim $HOME/.config/nvim/init.vim

sudo apt install libstdc++-10-dev
curl -sL install-node.now.sh/lts | sudo $SHELL -s -- --yes

nvim +:PlugInstall +:qa
nvim +:CocInstall coc-clangd +:qa
nvim +:CocCommand clangd.install +:qa
