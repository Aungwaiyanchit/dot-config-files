-- ~/.config/sketchybar/items/volume.lua

local sbar = require("sketchybar")
local colors = require("colors")

local ICON = {
  mute = "\u{f0581}",  -- md-volume_off
  low  = "\u{f057f}",  -- md-volume_low
  med  = "\u{f0580}",  -- md-volume_medium
  high = "\u{f057e}",  -- md-volume_high
}

local volume = sbar.add("item", "volume", {
  position = "right",
  icon = {
    string = ICON.med,
    font = { family = "JetBrainsMono Nerd Font", style = "Regular", size = 15.0 },
    color = colors.white,
    padding_left = 7,
    padding_right = 7,
  },
  label = { drawing = false },
  update_freq = 30,
  click_script = "osascript -e 'set volume output muted not (output muted of (get volume settings))'",
})

local function update_volume()
  local h = io.popen("osascript -e 'get volume settings'")
  local out = h:read("*a")
  h:close()

  local vol = tonumber(out:match("output volume:%s*(%d+)"))
  local muted = out:match("output muted:%s*true") ~= nil
  local silent = muted or not vol or vol == 0

  local glyph
  if silent then glyph = ICON.mute
  elseif vol <= 33 then glyph = ICON.low
  elseif vol <= 66 then glyph = ICON.med
  else glyph = ICON.high end

  volume:set({
    icon = {
      string = glyph,
      color = silent and colors.dim or colors.white,
    },
  })
end

volume:subscribe({ "routine", "volume_change", "system_woke" }, update_volume)
update_volume()
