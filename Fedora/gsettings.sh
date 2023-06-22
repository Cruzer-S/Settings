gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>d']"
gsettings set org.gnome.settings-daemon.plugins.media-keys www "['<Super>c']"

gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"

gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"

gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

gsettings set org.gnome.desktop.input-sources xkb-options "['caps:super']"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Super>t"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "gnome-terminal"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "open gnome-ternimal"

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"

gsettings set org.gnome.desktop.input-sources mru-sources "[('ibus', 'hangul'), ('xkb', 'kr')]"
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'kr'), ('ibus', 'hangul')]"
gsettings set org.gnome.desktop.input-sources xkb-options "['lv3:ralt_switch', 'caps:super']"
