vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local has_ts, ts = pcall(require, "nvim-treesitter.configs")
        if has_ts then
            ts.setup({
                ensure_installed = { "go", "gomod", "haskell" },
                highlight = {
                    enable = true,
                },
            })
        end
    end,
})
