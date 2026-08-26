-- ~/.config/sketchybar/items/clock.lua

local sbar = require("sketchybar")
local colors = require("colors")

local clock = sbar.add("item", "clock", {
  position = "right",
  icon = { drawing = false },
  label = {
    string = os.date("%a %d %b %H:%M"),
    color = colors.white,
    padding_left = 10,
    padding_right = 10,
  },
  update_freq = 5,
})

clock:subscribe({ "routine", "system_woke" }, function()
  clock:set({ label = { string = os.date("%a %d %b %H:%M") } })
end)
