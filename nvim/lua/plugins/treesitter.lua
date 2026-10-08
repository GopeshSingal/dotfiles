local ts = require("nvim-treesitter")

if vim.fn.executable("tree-sitter") == 1 then
    ts.install({ "go", "gomod", "haskell", "html", "tsx" })
end

-- MDX has no parser of its own, so parse it as markdown
vim.treesitter.language.register("markdown", "mdx")

vim.api.nvim_create_autocmd("FileType", {
    desc     = "Start treesitter highlighting when a parser is available",
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})
