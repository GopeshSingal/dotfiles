-- Select plain text, then create a note in the notebook's notes/ directory.
vim.keymap.set("x", "<leader>zn", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local client = vim.lsp.get_clients({ bufnr = bufnr, name = "zk" })[1]
    if not client then
        vim.notify("No zk language server attached to this buffer", vim.log.levels.WARN)
        return
    end
    if vim.fn.mode() ~= "v" then
        vim.notify("Select the note title using characterwise Visual mode", vim.log.levels.WARN)
        return
    end

    local anchor, cursor = vim.fn.getpos("v"), vim.fn.getpos(".")
    local first = { anchor[2] - 1, anchor[3] - 1 }
    local last = { cursor[2] - 1, cursor[3] - 1 }
    if first[1] > last[1] or (first[1] == last[1] and first[2] > last[2]) then
        first, last = last, first
    end
    local line = vim.api.nvim_buf_get_lines(bufnr, last[1], last[1] + 1, true)[1]
    if vim.o.selection ~= "exclusive" then
        last[2] = last[2] + #vim.fn.matchstr(line:sub(last[2] + 1), "^.")
    end
    local text = vim.api.nvim_buf_get_text(bufnr, first[1], first[2], last[1], last[2], {})
    local title = vim.trim(table.concat(text, " "))
    if title == "" then
        return
    end

    local function position(pos)
        return {
            line = pos[1],
            character = vim.lsp.util.character_offset(bufnr, pos[1], pos[2], client.offset_encoding),
        }
    end
    local location = {
        uri = vim.uri_from_bufnr(bufnr),
        range = { start = position(first), ["end"] = position(last) },
    }
    vim.cmd.normal({ vim.api.nvim_replace_termcodes("<Esc>", true, false, true), bang = true })
    client:exec_cmd({
        title = "Create linked zk note",
        command = "zk.new",
        arguments = {
            vim.api.nvim_buf_get_name(bufnr),
            {
                title = title,
                dir = vim.fs.joinpath(client.root_dir, "notes"),
                insertLinkAtLocation = location,
            },
        },
    }, { bufnr = bufnr }, function(err)
        if err then
            vim.notify("zk.new: " .. err.message, vim.log.levels.ERROR)
        end
    end)
end, { desc = "Create linked zk note in notes/" })
