vim.cmd.colorscheme("iceberg")

local hl_groups = { "Normal", "NonText", "SignColumn", "LineNr", "CursorLine", "CursorLineNr" }
for _, group in ipairs(hl_groups) do
    local opts = { bg = "none" }
    if group == "CursorLineNr" then opts.fg = "#84a0c6" end
    vim.api.nvim_set_hl(0, group, opts)
end
