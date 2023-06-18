#/bin/bash
sudo dnf install -y gh bat google-chrome-stable

echo "alias cat='bat'" >> ~/.bashrc

source ~/.bashrc
