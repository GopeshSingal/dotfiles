-- prefix passthrough
rex.bind("ctrl+b>ctrl+b", "pane.send_key", { key = "ctrl+b" })

-- pane navigation
rex.bind("ctrl+b>h", "pane.focus", { direction = "left" })
rex.bind("ctrl+b>j", "pane.focus", { direction = "down" })
rex.bind("ctrl+b>k", "pane.focus", { direction = "up" })
rex.bind("ctrl+b>l", "pane.focus", { direction = "right" })
rex.bind("ctrl+b>z", "pane.zoom")
rex.bind("ctrl+b>;", "pane.focus_previous")

-- pane resizing
rex.mode("repeat", { exclusive = true })
rex.bind("ctrl+b>ctrl+r", "client.mode.enter", { name = "repeat" }) -- ctrl+b ctrl+r enters repeat mode
rex.bind("repeat/enter", "client.mode.exit") -- enter to leave repeat mode
rex.bind("repeat/escape", "client.mode.exit") -- escape to leave repeat mode

rex.bind("repeat/shift+h", "pane.resize", { amount = 5, direction = "left" })
rex.bind("repeat/shift+j", "pane.resize", { amount = 5, direction = "down" })
rex.bind("repeat/shift+k", "pane.resize", { amount = 5, direction = "up" })
rex.bind("repeat/shift+l", "pane.resize", { amount = 5, direction = "right" })

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

-- session navigation
rex.bind("ctrl+b>s", "session.switch")

-- search
rex.bind("ctrl+b>/", "client.find.open")
