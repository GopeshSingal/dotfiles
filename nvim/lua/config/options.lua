-- Window Aesthetics -- 
vim.o.termguicolors  = true
vim.o.winborder      = "rounded"
vim.o.number         = true
vim.o.relativenumber = true
vim.o.signcolumn     = "yes"
vim.o.cursorline     = true
vim.o.wrap           = false
vim.o.scrolloff      = 12

-- Tabbing --
vim.o.expandtab   = true
vim.o.shiftwidth  = 4
vim.o.tabstop     = 4
vim.o.softtabstop = 4
vim.o.smartindent = true

-- Searching --
vim.o.ignorecase = true
vim.o.smartcase  = true
vim.o.hlsearch   = true
vim.o.incsearch  = true

-- Clipboard / Undo
vim.o.clipboard = "unnamedplus"

local undodir = vim.fn.stdpath("data") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end

vim.o.undodir  = undodir
vim.o.undofile = true

vim.opt.path:append('**')

-- Map Leaders --
vim.g.mapleader   = " "
vim.g.localleader = ","
