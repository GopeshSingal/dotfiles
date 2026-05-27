require("config.options")
require("config.keymaps")
require("config.autocmds")

vim.pack.add({
    "lewis6991/gitsigns.nvim",
    "ibhagwan/fzf-lua",
    "echasnovski/mini.nvim",
    "folke/which-key.nvim",
    "cocopon/iceberg.vim",
    "neovim/nvim-lspconfig",
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "saghen/blink.cmp",
    "L3MON4D3/LuaSnip",
    "nvim-treesitter/nvim-treesitter",
})

local plugins_path = vim.fn.stdpath("config") .. "/lua/plugins"
local files = vim.fn.globpath(plugins_path, "*.lua", false, true)

for _, file in ipairs(files) do
    local module_name = vim.fn.fnamemodify(file, ":t:r")

    local success, err = pcall(require, "plugins." .. module_name)
    if not success then
        vim.notify("Error loading plugins." .. module_name .. ": " .. err, vim.log.levels.ERROR)
    end
end
