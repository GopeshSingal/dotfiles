require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
    ensure_installed = {
        "gopls",
        "lua_ls",
        "mdx_analyzer",
        "rust_analyzer",
        "stylua",
    }
})
