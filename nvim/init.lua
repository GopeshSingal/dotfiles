-----------------
-- Vim Options --
-----------------
vim.o.termguicolors = true
vim.o.winborder = "rounded"

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"

vim.o.cursorline = true

vim.o.wrap = false
vim.o.scrolloff = 12

-- Tabbing
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.smartindent = true

-- Searching
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.incsearch = true

-- Clipboard / Undo
vim.o.clipboard = "unnamedplus"
local undodir = vim.fn.stdpath("data") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
vim.o.undodir = undodir
vim.o.undofile = true

vim.opt.path:append("**")

----------------
-- Keymapping --
----------------
vim.g.mapleader = " "
vim.g.localleader = ","

vim.keymap.set("n", "<Leader>w", ":w<CR>", { desc = "Write buffer" })
vim.keymap.set("n", "<Leader>q", ":q<CR>", { desc = "Quit buffer" })

vim.keymap.set("n", "<Leader>c", ":nohlsearch<CR>", { desc = "Clear highlighted results" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

vim.keymap.set("n", "<leader>td", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

-------------------
-- Auto Commands --
-------------------
local cfggroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = cfggroup,
    desc = "Highlight text when yanking it",
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Automatically enable word wrapping in Markdown files
vim.api.nvim_create_autocmd("FileType", {
    group = cfggroup,
    pattern = "markdown",
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.spell = true
    end,
})

-- vim.api.nvim_create_autocmd("CursorHold", {
--     group = cfggroup,
--     callback = function()
--         vim.diagnostic.open_float(nil, {
--             focusable = false,
--             border = "rounded",
--             source = "always",
--         })
--     end,
-- })
-------------------------
-- Plugin Installation --
-------------------------
vim.pack.add({
    "https://www.github.com/lewis6991/gitsigns.nvim",
    "https://www.github.com/ibhagwan/fzf-lua",
    "https://www.github.com/echasnovski/mini.nvim",
    "https://www.github.com/folke/which-key.nvim",
    "https://www.github.com/cocopon/iceberg.vim"
})

-- Colorscheme
vim.cmd.colorscheme("iceberg")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NonText", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "none", fg = "#81a1c1" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })

-- GitSigns
require("gitsigns").setup({
	signs = {
		add = { text = "\u{2590}" }, -- ▏
		change = { text = "\u{2590}" }, -- ▐
		delete = { text = "\u{2590}" }, -- ◦
		topdelete = { text = "\u{25e6}" }, -- ◦
		changedelete = { text = "\u{25cf}" }, -- ●
		untracked = { text = "\u{25cb}" }, -- ○
	},
	signcolumn = true,
	current_line_blame = false,
})

vim.api.nvim_set_hl(0, "GitSignsAdd", { bg = "none", fg = "#a3be8c" })
vim.api.nvim_set_hl(0, "GitSignsChange", { bg = "none", fg = "#ebcb8b" })
vim.api.nvim_set_hl(0, "GitSignsDelete", { bg = "none", fg = "#bf616a" })

vim.keymap.set("n", "]h", function()
	require("gitsigns").nav_hunk('next')
end, { desc = "Next git hunk" })
vim.keymap.set("n", "[h", function()
	require("gitsigns").nav_hunt('prev')
end, { desc = "Previous git hunk" })
vim.keymap.set("n", "<leader>hs", function()
	require("gitsigns").stage_hunk()
end, { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>hr", function()
	require("gitsigns").reset_hunk()
end, { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>hp", function()
	require("gitsigns").preview_hunk()
end, { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>hb", function()
	require("gitsigns").blame_line({ full = true })
end, { desc = "Blame line" })
vim.keymap.set("n", "<leader>hB", function()
	require("gitsigns").toggle_current_line_blame()
end, { desc = "Toggle inline blame" })
vim.keymap.set("n", "<leader>hd", function()
	require("gitsigns").diffthis()
end, { desc = "Diff this" })

-- FZF
require("fzf-lua").setup({})

vim.keymap.set("n", "<leader>ff", function()
    require("fzf-lua").files()
end, { desc = "FZF Files" })
vim.keymap.set("n", "<leader>fg", function()
	require("fzf-lua").live_grep()
end, { desc = "FZF Live Grep" })
vim.keymap.set("n", "<leader>fb", function()
	require("fzf-lua").buffers()
end, { desc = "FZF Buffers" })
vim.keymap.set("n", "<leader>fh", function()
	require("fzf-lua").help_tags()
end, { desc = "FZF Help Tags" })
vim.keymap.set("n", "<leader>fx", function()
	require("fzf-lua").diagnostics_document()
end, { desc = "FZF Diagnostics Document" })
vim.keymap.set("n", "<leader>fX", function()
	require("fzf-lua").diagnostics_workspace()
end, { desc = "FZF Diagnostics Workspace" })

-- mini
require("mini.comment").setup({})
require("mini.indentscope").setup({})
require("mini.notify").setup({})
require("mini.pairs").setup({})
require("mini.surround").setup({})
require("mini.trailspace").setup({})

-- which-key
require("which-key").setup({
  spec = {
    { "<leader>s", group = "[S]earch", icon = { icon = "", color = "green", }, },
  }
})

-----------------------
-- LSP Configuration --
-----------------------
vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
    "https://github.com/saghen/blink.cmp",
    "https://github.com/L3MON4D3/LuaSnip",
    "https://github.com/nvim-treesitter/nvim-treesitter",
})

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
    ensure_installed = {
        -- LSPs
        "lua_ls",
        "rust_analyzer",
        -- Formatters / Linters
        "stylua",

    }
})


vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = {
					"vim",
					"require",
				},
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
})

vim.lsp.config("rust_analyzer", {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", "rust-project.json", ".git" },
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
            },
            checkOnSave = true,
            check = {
                command = "clippy",
            },
        },
    },
})

vim.lsp.config('hls', {
    cmd = { "haskell-language-server-wrapper", "--lsp" },
    filetypes = { 'haskell', 'lhaskell' },
    root_markers = { 'cabal.project', 'stack.yaml', 'package.yaml', '.git' },
    settings = {
        haskell = {
            formattingProvider = "ormolu",
        },
    },
})
vim.lsp.enable('hls')

local cmp = require('blink.cmp')
cmp.setup({
    keymap = {
        preset = "none",
        ["<C-Space>"] = { "show", "hide" },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
    },
    appearance = { nerd_font_variant = "mono" },
    completion = {
        list = {
            selection = {
                preselect = false,
                auto_insert = false
            },
        },
        menu = {
            auto_show = true,
        }
    },
    sources = { default = { "lsp", "path", "buffer", "snippets" } },
    snippets = {
        expand = function(snippet)
            require("luasnip").lsp_expand(snippet)
        end,
    },
    fuzzy = {
        implementation = "prefer_rust",
    },
})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        -- Ensure the module exists before trying to run setup
        local has_ts, ts = pcall(require, "nvim-treesitter.configs")
        if has_ts then
            ts.setup({
                ensure_installed = { "haskell" },
                highlight = {
                    enable = true,
                },
            })
        end
    end,
})

vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<Leader>k", vim.lsp.buf.hover, { desc = "Hover" })
vim.keymap.set("n", "<Leader>gd", vim.lsp.buf.definition, { desc = "Goto definition" })
vim.keymap.set("n", "<Leader>gr", vim.lsp.buf.references, { desc = "Goto references" })
vim.keymap.set("n", "<Leader>gD", vim.lsp.buf.declaration, { desc = "Goto declaration" })
vim.keymap.set("n", "<Leader>lf", vim.lsp.buf.format, { desc = "Language format" })
vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })
