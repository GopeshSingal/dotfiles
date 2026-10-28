require("mason").setup()
-- Servers are enabled explicitly in lspconfig.lua, not by what Mason installed
require("mason-lspconfig").setup({ automatic_enable = false })
require("mason-tool-installer").setup({
    ensure_installed = {
        "gopls",
        "lua_ls",
        "mdx_analyzer",
        "rust_analyzer",
        "zls",
    }
})
