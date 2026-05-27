vim.keymap.set("n", "<Leader>w", ":w<CR>", { desc = "Write buffer" })
vim.keymap.set("n", "<Leader>q", ":q<CR>", { desc = "Quit buffer" })

vim.keymap.set("n", "<Leader>c", ":nohlsearch<CR>", { desc = "Clear highlighted results" })
vim.keymap.set("n", "n",         "nzzzv",           { desc = "Next search result (centered)" })
vim.keymap.set("n", "N",         "Nzzzv",           { desc = "Previous search result (centered)" })

vim.keymap.set("n", "<leader>bn", ":bnext<CR>",     { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

vim.keymap.set("n", "<leader>td", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })
