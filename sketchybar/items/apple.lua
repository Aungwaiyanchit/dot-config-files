-- ~/.config/sketchybar/items/apple.lua

local sbar = require("sketchybar")
local colors = require("colors")

-- Apple logo (private-use glyph in Apple's system fonts)
sbar.add("item", "apple", {
  position = "left",
  icon = {
    string = "\u{F8FF}",
    font = { family = "SF Pro", style = "Bold", size = 17.0 },
    color = colors.dim,
    padding_left = 4,
    padding_right = 12,
  },
  label = { drawing = false },
  background = { drawing = false },
})
