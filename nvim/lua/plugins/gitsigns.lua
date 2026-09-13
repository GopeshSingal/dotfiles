local gs = require("gitsigns")

gs.setup({
    signs = {
        add          = { text = "▌" },
        change       = { text = "▐" },
        delete       = { text = "◦" },
        topdelete    = { text = "◦" },
        changedelete = { text = "●" },
        untracked    = { text = "○" },
    },
    signcolumn = true,
    numhl = true,
})

vim.api.nvim_set_hl(0, "GitSignsAdd",          { bg = "none", fg = "#a3be8c" })
vim.api.nvim_set_hl(0, "GitSignsChange",       { bg = "none", fg = "#ebcb8b" })
vim.api.nvim_set_hl(0, "GitSignsDelete",       { bg = "none", fg = "#e27878" })
vim.api.nvim_set_hl(0, "GitSignsUntracked",    { bg = "none", fg = "#88c0d0" })
vim.api.nvim_set_hl(0, "GitSignsChangedelete", { bg = "none", fg = "#d08770" })

vim.keymap.set("n", "]h",         function() gs.nav_hunk('next') end, { desc = "Next git hunk" })
vim.keymap.set("n", "[h",         function() gs.nav_hunk('prev') end, { desc = "Previous git hunk" })

vim.keymap.set("n", "<leader>hs", gs.stage_hunk,       { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>hr", gs.reset_hunk,       { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>hp", gs.preview_hunk,     { desc = "Preview hunk" })

vim.keymap.set("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "Blame line" })
vim.keymap.set("n", "<leader>hB", function() gs.toggle_current_line_blame() end, { desc = "Toggle inline blame"})
vim.keymap.set("n", "<leader>hd", function() gs.diffthis() end,                  { desc = "Diff this" })
