sudo dnf install neovim

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

mkdir -p ~/.config/nvim
cp ../init.vim ~/.config/nvim/init.vim

curl -sL install-node.n ow.sh/lts | sudo $SHELL -s -- --yes
sudo dnf install gcc gcc-c++ -y

nvim "+:PlugInstall" "+:qa"
nvim "+:CocInstall -sync coc-clangd" "+:qa"
nvim "+:CocCommand clangd.install" dummy.c
