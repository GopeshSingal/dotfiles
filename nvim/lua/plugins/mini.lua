local mini_plugins = { "comment", "indentscope", "notify", "pairs", "surround", "trailspace" }
for _, p in ipairs(mini_plugins) do
    require("mini." .. p).setup({})
end
