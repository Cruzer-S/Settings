#/bin/bash
sed "/.*if .*vs/,/end/d" -i $HOME/.local/share/lunarvim/site/pack/lazy/opt/outline.nvim/lua/outline/config.lua
