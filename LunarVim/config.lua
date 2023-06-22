lvim.keys.insert_mode["jk"] = "<ESC>"
lvim.keys.insert_mode["kj"] = "<ESC>"

vim.opt.tabstop = 8
vim.opt.shiftwidth = 8
vim.opt.expandtab = false

lvim.keys.normal_mode["<S-x>"] = ":BufferKill<CR>"

lvim.keys.normal_mode["<S-h>"] = ":bprev<CR>"
lvim.keys.normal_mode["<S-l>"] = ":bnext<CR>"
