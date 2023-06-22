#/bin/bash
sudo dnf install -y gh bat google-chrome-stable
sudo dnf install -y gnome-extensions gnome-tweaks
sudo dnf remove -y gnome-tour

echo "alias cat='bat'" >> ~/.bashrc

source ~/.bashrc

./gsettings.sh
