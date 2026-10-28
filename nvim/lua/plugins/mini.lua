local mini_plugins = { "comment", "indentscope", "notify", "pairs", "trailspace" }
for _, p in ipairs(mini_plugins) do
    require("mini." .. p).setup({})
end

require("mini.surround").setup({
    custom_surroundings = {
        -- Wikilinks: saiwW for a word, visual saW for selected text, sdW to unwrap.
        W = {
            input = { "%[%[().-()%]%]" },
            output = { left = "[[", right = "]]" },
        },
    },
})
