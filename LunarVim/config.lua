lvim.keys.insert_mode["jk"] = "<ESC>"
lvim.keys.insert_mode["kj"] = "<ESC>"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false

lvim.keys.normal_mode["<S-x>"] = ":BufferKill<CR>"

lvim.keys.normal_mode["<S-h>"] = ":bprev<CR>"
lvim.keys.normal_mode["<S-l>"] = ":bnext<CR>"

lvim.builtin.terminal.direction = "horizontal"
lvim.builtin.terminal.size = 10
