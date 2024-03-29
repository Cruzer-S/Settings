#!/bin/bash
sudo dnf install -y zsh
sudo dnf install -y util-linux-user # for chsh
echo "Y
" | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
rm $HOME/.zshrc
cp zshrc $HOME/.zshrc
sudo chsh -s $(which zsh) $USER
