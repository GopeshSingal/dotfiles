require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.titles")

local gh = function(x) return "https://github.com/" .. x end

vim.pack.add({
    gh("lewis6991/gitsigns.nvim"),
    gh("ibhagwan/fzf-lua"),
    gh("echasnovski/mini.nvim"),
    gh("folke/which-key.nvim"),
    gh("cocopon/iceberg.vim"),
    gh("neovim/nvim-lspconfig"),
    gh("mason-org/mason.nvim"),
    gh("mason-org/mason-lspconfig.nvim"),
    gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
    gh("saghen/blink.cmp"),
    gh("L3MON4D3/LuaSnip"),
    gh("nvim-treesitter/nvim-treesitter"),
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
