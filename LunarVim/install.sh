#!/bin/bash

# Install prerequisites
sudo dnf install -y neovim git make python npm nodejs cargo
sudo dnf install -y gcc g++

# Install LunarVim
echo -e "\n\n\n" | LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)

cp ./config.lua ~/.config/lvim/config.lua

# Add shortcut
echo "alias vi='lvim'" >> ~/.bashrc
echo "alias vim='lvim'" >> ~/.bashrc

source ~/.bashrc

# Install Nerd Font ( In this case, Noto (40) will installed )
git clone https://github.com/ronniedroid/getnf.git
./getnf/install.sh
echo -e "40\n" | ./getnf/getnf
rm -rf ./getnf
fc-cache -f -v

# FTPlugin Settings
mkdir -p ~/.config/lvim/
cp -r ./ftplugin/ ~/.config/lvim

# Additional configuration
rm -rf ~/.local/share/lunarvim/site/pack/lazy/opt/nvim-treesitter/queries/make
