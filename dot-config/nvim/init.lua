-- Setup leader keys
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

require("config.lazy")

-- LSP
vim.lsp.enable("gopls")
vim.diagnostic.config({ virtual_text = true })

-- Keybindings
-- Normal mode
vim.keymap.set("n", "<leader>n", ":set invnumber<CR>")
vim.keymap.set("n", "<leader>bp", ":bp<CR>")
vim.keymap.set("n", "<leader>bn", ":bn<CR>")

-- Insert mode
vim.keymap.set("i", "jj", "<ESC>", { silent = true })

-- Visual mode

-- Setup
vim.opt.nu = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.colorcolumn = "80"
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"
