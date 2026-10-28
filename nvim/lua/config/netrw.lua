local ns = vim.api.nvim_create_namespace("UserNetrwGit")
local group = vim.api.nvim_create_augroup("UserNetrwGit", { clear = true })

local function set_highlights()
    vim.api.nvim_set_hl(0, "NetrwGitUntracked", { fg = "#a093c7" })
end

set_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
    group    = group,
    desc     = "Reapply netrw git highlights",
    callback = set_highlights,
})

local priority = {
    NetrwGitUntracked = 1,
    GitSignsAdd       = 2,
    GitSignsChange    = 3,
}

local function status_hl(xy)
    if xy == "??" then return "NetrwGitUntracked" end
    if xy:find("A") then return "GitSignsAdd" end
    return "GitSignsChange"
end

local function parse_status(output, prefix)
    local entries = {}
    local records = vim.split(output, "\0", { trimempty = true })
    local i = 1
    while i <= #records do
        local record = records[i]
        local xy, path = record:sub(1, 2), record:sub(4)
        if xy:find("[RC]") then i = i + 1 end

        if path:sub(1, #prefix) == prefix then
            local name = path:sub(#prefix + 1):match("^[^/]+")
            local hl = status_hl(xy)
            if name and (not entries[name] or priority[hl] > priority[entries[name]]) then
                entries[name] = hl
            end
        end
        i = i + 1
    end
    return entries
end

local function apply(buf, entries)
    if not vim.api.nvim_buf_is_valid(buf) then return end
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    for lnum, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
        local hl = entries[line:gsub("[/*@=|]$", "")]
        if hl then
            vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, 0, {
                end_col  = #line,
                hl_group = hl,
                priority = 200,
            })
        end
    end
end

local function refresh(buf)
    local dir = vim.b[buf].netrw_curdir
    if not dir then return end

    vim.system({ "git", "-C", dir, "rev-parse", "--show-prefix" }, { text = true }, function(prefix_res)
        if prefix_res.code ~= 0 then return end
        local prefix = vim.trim(prefix_res.stdout)

        vim.system({ "git", "-C", dir, "status", "--porcelain", "-z", "--", "." }, { text = true }, function(res)
            if res.code ~= 0 then return end
            local entries = parse_status(res.stdout, prefix)
            vim.schedule(function() apply(buf, entries) end)
        end)
    end)
end


vim.api.nvim_create_autocmd("FileType", {
    group    = group,
    pattern  = "netrw",
    desc     = "Highlight netrw entries by git status",
    callback = function(args) refresh(args.buf) end,
})
