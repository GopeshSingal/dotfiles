local cfg_group = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    group    = cfg_group,
    desc     = "Highlight text when yanked",
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Enable word wrapping in Markdown files
vim.api.nvim_create_autocmd("FileType", {
    group    = cfg_group,
    pattern  = "markdown",
    callback = function()
        vim.opt_local.wrap      = true
        vim.opt_local.linebreak = true
        vim.opt_local.spell     = true
    end,
})
