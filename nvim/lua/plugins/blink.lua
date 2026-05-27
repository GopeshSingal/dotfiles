local cmp = require('blink.cmp')
cmp.setup({
    keymap = {
        preset        = "none",
        ["<C-Space>"] = { "show", "hide" },
        ["<CR>"]      = { "accept", "fallback" },
        ["<C-j>"]     = { "select_next", "fallback" },
        ["<C-k>"]     = { "select_prev", "fallback" },
        ["<Tab>"]     = { "snippet_forward", "fallback" },
        ["<S-Tab>"]   = { "snippet_backward", "fallback" },
    },
    appearance = { nerd_font_variant = "mono" },
    completion = {
        list = {
            selection = {
                preselect   = false,
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
