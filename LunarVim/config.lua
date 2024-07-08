--------------------------------------------------------------
-- general settings
--------------------------------------------------------------
lvim.colorscheme = "slate"

lvim.keys.insert_mode["jk"] = "<ESC>"
lvim.keys.insert_mode["kj"] = "<ESC>"

lvim.keys.normal_mode["<S-x>"] = ":BufferKill<CR>"
lvim.keys.normal_mode["<S-h>"] = ":bprev<CR>"
lvim.keys.normal_mode["<S-l>"] = ":bnext<CR>"

-- vim settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.colorcolumn = '80'
vim.opt.mouse = ''

-- folding powered by treesitter
-- https://github.com/nvim-treesitter/nvim-treesitter#folding
-- look for foldenable: https://github.com/neovim/neovim/blob/master/src/nvim/options.lua
-- Vim cheatsheet, look for folds keys: https://devhints.io/vim
vim.opt.foldmethod = "expr" -- default is "normal"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- default is ""
vim.opt.foldenable = false -- if this option is true and fold method option is other than normal, every time a document is opened everything will be folded.

lvim.builtin.which_key.setup.plugins.presets.z = true

lvim.builtin.nvimtree.setup.view.width = 30

lvim.plugins = {
	{
		"hedyhli/outline.nvim",
		config = function()
			require("outline").setup {
				outline_window  = {
					split_command = 'split',
					relative_width = false,
					width = lvim.builtin.nvimtree.setup.view.width,
				},
				symbols = {
					icons = {
						String = { icon = 'S', hl = 'String' },
						Object = { icon = 'O', hl = 'Type' },
					}
				}
			}
	  end,
	},
}

lvim.keys.normal_mode["<Leader>r"] = "<Cmd>NvimTreeToggle<CR><Cmd>Outline<CR>"
--------------------------------------------------------------
-- telescope settings
--------------------------------------------------------------
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  -- for input mode
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
  },
  -- for normal mode
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
}
--------------------------------------------------------------
-- toggleterm settings
--------------------------------------------------------------
lvim.builtin.terminal.direction = "horizontal"
lvim.builtin.terminal.size = 10

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<ESC>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'kj', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')
