#!/bin/bash

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

mkdir -p $HOME/.config/nvim
cp ../init.vim $HOME/.config/nvim/init.vim

sudo apt install -y libstdc++-10-dev
sudo apt install -y clangd
curl -sL install-node.now.sh/lts | sudo $SHELL -s -- --yes

nvim "+:PlugInstall" "+:qa"
nvim "+:CocInstall -sync coc-clangd" "+:qa"
nvim "+:CocInstall -sync coc-json" "+:qa"
nvim "+:CocInstall -sync coc-pyright" "+:qa"
# nvim "+:CocCommand clangd.install" "+:qa" dummy.c
nvim "+:TSUpdateSync" "+:qa"
