-- prefix passthrough
rex.bind("ctrl+b>ctrl+b", "pane.send_key", { key = "ctrl+b" })

-- pane navigation
rex.bind("ctrl+b>h", "pane.focus", { direction = "left" })
rex.bind("ctrl+b>j", "pane.focus", { direction = "down" })
rex.bind("ctrl+b>k", "pane.focus", { direction = "up" })
rex.bind("ctrl+b>l", "pane.focus", { direction = "right" })
rex.bind("ctrl+b>z", "pane.zoom")
rex.bind("ctrl+b>;", "pane.focus_previous")

-- pane ordering
rex.bind("ctrl+b>alt+h", "pane.move", { direction = "left" })
rex.bind("ctrl+b>alt+j", "pane.move", { direction = "down" })
rex.bind("ctrl+b>alt+k", "pane.move", { direction = "up" })
rex.bind("ctrl+b>alt+l", "pane.move", { direction = "right" })

rex.bind("ctrl+b>shift+1", "pane.move_to_new_tab")

-- pane resizing (ctrl+b ctrl+r enters resize mode; escape, enter, or q leaves it)
rex.mode("resize", { exclusive = true })
rex.bind("ctrl+b>ctrl+r", "client.mode.enter", { name = "resize" })
rex.bind("resize/enter", "client.mode.exit")
rex.bind("resize/q", "client.mode.exit")

rex.bind("resize/shift+h", "pane.resize", { amount = 5, direction = "left" })
rex.bind("resize/shift+j", "pane.resize", { amount = 5, direction = "down" })
rex.bind("resize/shift+k", "pane.resize", { amount = 5, direction = "up" })
rex.bind("resize/shift+l", "pane.resize", { amount = 5, direction = "right" })
rex.bind("resize/=", "pane.balance")

rex.bind("resize/h", "pane.focus", { direction = "left" })
rex.bind("resize/j", "pane.focus", { direction = "down" })
rex.bind("resize/k", "pane.focus", { direction = "up" })
rex.bind("resize/l", "pane.focus", { direction = "right" })

-- pane creation & deletion
rex.bind("ctrl+b>shift+5", "pane.split", { direction = "right" })
rex.bind("ctrl+b>shift+'", "pane.split", { direction = "down" })
rex.bind("ctrl+b>alt+x", "pane.close")

-- tab navigation
rex.bind("ctrl+b>n", "client.tab.next")
rex.bind("ctrl+b>p", "client.tab.previous")
for i = 1, 9 do
    rex.bind("ctrl+b>" .. i, "client.tab.goto", { index = i })
end

-- tab creation and deletion
rex.bind("ctrl+b>c", "client.tab.new")
rex.bind("ctrl+b>alt+shift+x", "client.tab.close")
rex.bind("ctrl+b>,", "client.tab.rename")

-- session navigation
rex.bind("ctrl+b>s", "session.switch")
rex.bind("ctrl+b>shift+9", "session.previous")
rex.bind("ctrl+b>shift+0", "session.next")

-- session creation & deletion
rex.bind("ctrl+b>shift+c", "session.new")
rex.mode("kill-session", { exclusive = true })
rex.bind("ctrl+b>shift+x", "client.mode.enter", { name = "kill-session" })
rex.bind("kill-session/y", "session.close")
rex.bind("kill-session/n", "client.mode.exit")
rex.bind("ctrl+b>shift+4", "session.rename")

-- toggle sidebar
rex.bind("ctrl+b>b", "client.sidebar.toggle")

-- search & copy
rex.bind("ctrl+b>/", "client.find.open")
rex.bind("ctrl+b>[", "copy_mode") -- defined in actions.lua
rex.bind("ctrl+b>tab", "extract") -- defined in actions.lua

-- popups
rex.bind("ctrl+b>t", "popup") -- defined in actions.lua
