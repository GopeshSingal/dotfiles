local cfg_group = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    group    = cfg_group,
    desc     = "Highlight text when yanked",
    callback = function()
        vim.hl.on_yank(
            {
                higroup = "Visual",
                timeout = 300,
            }
        )
    end,
})

-- Enable word wrapping in Markdown files
vim.api.nvim_create_autocmd("FileType", {
    group    = cfg_group,
    pattern  = { "markdown", "mdx" },
    callback = function()
        vim.opt_local.wrap      = true
        vim.opt_local.linebreak = true
        -- prevent insertion of real line breaks while typing (caused by repo settings)
        vim.opt_local.formatoptions:remove("t")
        -- break only at whitespace
        vim.opt_local.breakat   = " \t"
        vim.opt_local.breakindent    = true
        -- put the showbreak marker at the left edge
        vim.opt_local.breakindentopt = "list:-1,sbr"
        vim.opt_local.showbreak      = "↪ "
        vim.opt_local.spell     = true
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group    = cfg_group,
    pattern  = "mdx",
    callback = function()
        vim.bo.commentstring = "{/* %s */}"
    end,
})
