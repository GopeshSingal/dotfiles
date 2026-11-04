-- copy mode
rex.action{
  name = "copy_mode", title = "Copy Mode (nvim)",
  run = function(ctx)
    local sh = [[f=$(mktemp -t rexcopy); rex capture -b "$1" --unwrap --trim > "$f"; nvim -R -c 'set clipboard=unnamedplus nonumber' -c 'nnoremap q <cmd>q!<cr>' -c 'normal! G' "$f"; rm -f "$f"; rex focus "$1"]]
    local _, err = rex.session.new_layer{
      focus  = true,
      bounds = { 0.05, 0.05, 0.9, 0.9 },
      layout = rex.layout.block{
        flavor = "com.superlogical.terminal.shell",
        options = { command = { "sh", "-c", sh, "sh", ctx.block_id } },
      },
    }
    if err ~= nil then error(err, 0) end
  end,
}
rex.bind("ctrl+b>[", "copy_mode")
