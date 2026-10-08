local ts = require("nvim-treesitter")

if vim.fn.executable("tree-sitter") == 1 then
    ts.install({ "go", "gomod", "haskell" })
end

vim.api.nvim_create_autocmd("FileType", {
    desc     = "Start treesitter highlighting when a parser is available",
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})
