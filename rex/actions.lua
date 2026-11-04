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

-- copy mode
rex.action{
  name = "copy_mode", title = "Copy Mode (nvim)",
  run = function(ctx)
    local sh = [[f=$(mktemp -t rexcopy); rex capture -b "$1" --unwrap --trim > "$f"; nvim -R -c 'set clipboard=unnamedplus nonumber nowrap' -c 'nnoremap q <cmd>q!<cr>' -c 'xnoremap <cr> y<cmd>q!<cr>' -c 'normal! G' "$f"; rm -f "$f"; rex focus "$1"]]
    local rect, window_id = block_rect(ctx.block_id)
    local _, err = rex.session.new_layer{
      window_id = window_id,
      focus  = true,
      bounds = rect and fit(rect) or { 0.05, 0.05, 0.9, 0.9 },
      layout = rex.layout.block{
        flavor = "com.superlogical.terminal.shell",
        options = { command = { "sh", "-c", sh, "sh", ctx.block_id } },
      },
    }
    if err ~= nil then error(err, 0) end
  end,
}
