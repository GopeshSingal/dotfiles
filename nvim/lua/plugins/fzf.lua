local fzf = require("fzf-lua")
fzf.setup({})

vim.keymap.set("n", "<leader>ff", fzf.files,                 { desc = "FZF Files" })
vim.keymap.set("n", "<leader>fg", fzf.live_grep,             { desc = "FZF Live Grep" })
vim.keymap.set("n", "<leader>fb", fzf.buffers,               { desc = "FZF Buffers" })
vim.keymap.set("n", "<leader>fh", fzf.help_tags,             { desc = "FZF Help Tags" })
vim.keymap.set("n", "<leader>fx", fzf.diagnostics_document,  { desc = "FZF Diagnostics Document" })
vim.keymap.set("n", "<leader>fX", fzf.diagnostics_workspace, { desc = "FZF Diagnostics Workspace" })

require("which-key").setup({
    spec = {
        { "<leader>s", group = "[S]earch", icon = { icon = "", color = "green" } },
    }
})
