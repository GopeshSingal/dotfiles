require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
    ensure_installed = {
        "gopls",
        "lua_ls",
        "rust_analyzer",
        "stylua",
    }
})
