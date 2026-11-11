-- find a block's on-screen rect and window
local function block_rect(block_id)
  if not block_id then return nil end
  local view = rex.session.view{}
  if not view then return nil end
  -- search layout tree for the block's rect
  local function find(node)
    if node == nil then return nil end
    if node.block_id == block_id then return node.rect end
    if node.split then return find(node.split.before) or find(node.split.after) end
  end
  for _, win in ipairs(view.windows or {}) do
    if win.zoomed_block_id == block_id then return { 0, 0, 1, 1 }, win.window_id end
    for _, layer in ipairs(win.layers or {}) do
      local rect = find(layer.layout)
      if rect then
        if layer.state == "minimized" or (layer.kind == "tiled" and win.zoomed_block_id) then
          return nil, win.window_id
        end
        return rect, win.window_id
      end
    end
  end
end

local MARGIN = 0.015  -- gap kept around the pane, as a fraction of the window
local MIN_SIZE = 0.4  -- smallest width and height, as a fraction of the window

-- inset a rect by MARGIN, grow it to MIN_SIZE, keep it inside the window
local function fit(rect)
  local function axis(pos, len)
    local size = math.max(len - 2 * MARGIN, MIN_SIZE)
    local start = math.max(0, math.min(pos + (len - size) / 2, 1 - size))
    return start, math.min(size, 1 - start)
  end
  local x, w = axis(rect[1], rect[3])
  local y, h = axis(rect[2], rect[4])
  return { x, y, w, h }
end

local TERMINAL = "com.superlogical.terminal"
local POPUP_LABEL = "popup"

-- working directory of a block's foreground program, falling back to its shell
local function block_cwd(block_id)
  local proc = rex.block.call(TERMINAL, "process", { block_id = block_id })
  if not proc then return nil end
  if proc.foreground and proc.foreground.cwd then return proc.foreground.cwd end
  for _, p in ipairs(proc.ancestors or {}) do
    if p.cwd then return p.cwd end
  end
end

-- a block's label, looked up in the session view
local function block_label(block_id)
  local view = rex.session.view{}
  for _, win in ipairs(view and view.windows or {}) do
    for _, layer in ipairs(win.layers or {}) do
      for _, b in ipairs(layer.blocks or {}) do
        if b.block_id == block_id then return b.label end
      end
    end
  end
end

-- run a shell script in a floating pane over a block; the script gets the block id as $1
local function float_over(block_id, script, opts)
  opts = opts or {}
  local rect, window_id = block_rect(block_id)
  local _, err = rex.session.new_layer{
    window_id = window_id,
    focus  = true,
    bounds = rect and fit(rect) or { 0.05, 0.05, 0.9, 0.9 },
    layout = rex.layout.block{
      flavor = TERMINAL .. ".shell",
      label = opts.label,
      options = { command = { "sh", "-c", script, "sh", block_id }, cwd = opts.cwd },
    },
  }
  if err ~= nil then error(err, 0) end
end

-- close a popup by ending its shell, so the popup script refocuses the pane it opened over
local function close_popup(ctx)
  local proc = rex.block.call(TERMINAL, "process", { block_id = ctx.block_id })
  local r = proc and proc.child and rex.exec{ "pkill", "-HUP", "-P", tostring(proc.child.pid) }
  if r and r.ok then return end
  local _, err = rex.call("block.close", { session_id = ctx.session_id, block_id = ctx.block_id })
  if err ~= nil then error(err, 0) end
end

-- copy mode
rex.action{
  name = "copy_mode", title = "Copy Mode (nvim)",
  run = function(ctx)
    float_over(ctx.block_id, [[
      f=$(mktemp -t rexcopy)
      rex capture -b "$1" --unwrap --trim > "$f"
      nvim -M -c 'set clipboard=unnamedplus nonumber nowrap' -c 'nnoremap q <cmd>q!<cr>' -c 'xnoremap <cr> y<cmd>q!<cr>' -c 'normal! G' "$f"
      rm -f "$f"
      rex focus "$1"
    ]])
  end,
}

-- popup shell in the pane's working directory; run from inside a popup, it closes it
rex.action{
  name = "popup", title = "Toggle Popup Shell",
  run = function(ctx)
    if block_label(ctx.block_id) == POPUP_LABEL then return close_popup(ctx) end
    float_over(ctx.block_id, [[
      "${SHELL:-/bin/zsh}" -l
      rex focus "$1"
    ]], { cwd = block_cwd(ctx.block_id), label = POPUP_LABEL })
  end,
}

-- pick a word, path or URL from the pane with fzf; enter types it, ctrl-y copies it
rex.action{
  name = "extract", title = "Extract Token (fzf)",
  run = function(ctx)
    float_over(ctx.block_id, [==[
      out=$(rex capture -b "$1" --unwrap --trim | awk '
        { lines[NR] = $0 }
        END {
          for (i = NR; i > 0; i--) {
            n = split(lines[i], words, /[ \t]+/)
            for (j = n; j > 0; j--) {
              w = words[j]
              c = w
              gsub(/^[("'"'"'`<\[{]+|[)"'"'"'`>\]},.:;]+$/, "", c)
              if (length(c) >= 3 && c ~ /[[:alnum:]]/ && !seen[c]++) print c
              if (length(w) >= 3 && w ~ /[[:alnum:]]/ && !seen[w]++) print w
            }
          }
        }' | fzf --no-sort --layout=reverse --prompt='extract> ' --header='enter: insert  ctrl-y: copy' --expect=ctrl-y)
      key=$(printf '%s\n' "$out" | sed -n 1p)
      pick=$(printf '%s\n' "$out" | sed -n 2p)
      rex focus "$1"
      [ -z "$pick" ] && exit 0
      if [ "$key" = ctrl-y ]; then
        printf '%s' "$pick" | pbcopy
      else
        printf '%s' "$pick" | rex send -b "$1"
      fi
    ]==])
  end,
}
