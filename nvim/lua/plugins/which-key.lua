require("which-key").setup({
    spec = {
        { "<leader>f", group = "Find", icon = { icon = "", color = "green" } },
        { "<leader>h", group = "Git hunks" },
        { "<leader>b", group = "Buffers" },
        { "<leader>g", group = "Goto" },
        { "<leader>z", group = "Notes", mode = { "n", "x" } },
    }
})
