#/bin/bash
sudo dnf install -y gh bat google-chrome-stable
sudo dnf install -y gnome-extensions gnome-tweaks
sudo dnf remove -y gnome-tour
sudo dnf install -y trash-cli

cat bashrc >> ~/.bashrc
source ~/.bashrc

cp aercbook ~/.local/bin/aercbook

./gsettings.sh
