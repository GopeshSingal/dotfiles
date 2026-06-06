local lsp = vim.lsp

lsp.config("lua_ls", {
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

lsp.config("rust_analyzer", {
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

lsp.config('hls', {
    cmd = { "haskell-language-server-wrapper", "--lsp" },
    filetypes = { 'haskell', 'lhaskell' },
    root_markers = { 'cabal.project', 'stack.yaml', 'package.yaml', '.git' },
    settings = {
        haskell = {
            formattingProvider = "ormolu",
        },
    },
})

lsp.config("gopls", {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git" },
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
        },
    },
})

lsp.enable({'gopls', 'lua_ls', 'rust_analyzer', 'hls'})

-- Keymaps --
vim.keymap.set("n", "<Leader>rn", lsp.buf.rename,            { desc = "Rename" })
vim.keymap.set("n", "<Leader>ca", lsp.buf.code_action,       { desc = "Code action" })
vim.keymap.set("n", "<Leader>k",  lsp.buf.hover,             { desc = "Hover" })
vim.keymap.set("n", "<Leader>gd", lsp.buf.definition,        { desc = "Goto definition" })
vim.keymap.set("n", "<Leader>gr", lsp.buf.references,        { desc = "Goto references" })
vim.keymap.set("n", "<Leader>gD", lsp.buf.declaration,       { desc = "Goto declaration" })
vim.keymap.set("n", "<Leader>lf", lsp.buf.format,            { desc = "Language format" })
vim.keymap.set("n", "<Leader>e",  vim.diagnostic.open_float, { desc = "Show diagnostic" })
