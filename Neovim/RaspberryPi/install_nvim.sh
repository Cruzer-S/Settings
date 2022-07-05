#!/bin/bash
sudo apt install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
git clone https://github.com/neovim/neovim $HOME/neovim
cd $HOME/neovim
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo #  -j$(nproc) <- Ninja 가 설치되어 있다면 필요 없음
sudo make install
cd $HOME
sudo rm -rf $HOME/neovim
