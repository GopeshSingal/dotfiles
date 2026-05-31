vim.o.title = true
local mode_prefix = {
    n = "nvim-n",
    i = "nvim-i",
    v = "nvim-v",
    V = "nvim-V",
    ["\22"] = "nvim-V", -- Ctrl-V block visual
    c = "nvim-c",
    s = "nvim-s",
    S = "nvim-S",
    R = "nvim-R",
}

local function update_title()
    local mode = vim.api.nvim_get_mode().mode
    local prefix = mode_prefix[mode] or ("nvim-" .. mode)
    vim.o.titlestring = prefix .. " %f"
end

vim.api.nvim_create_autocmd({ "ModeChanged", "VimEnter", "BufEnter" }, {
    callback = update_title,
})
