-- ~/.config/sketchybar/items/battery.lua

local sbar = require("sketchybar")
local colors = require("colors")

-- Vertical (MDI) battery glyphs from Nerd Fonts
local ICON = {
  unknown   = "\u{f0091}",
  full      = "\u{f0079}",
  alert     = "\u{f0083}",
  chg_full  = "\u{f0085}",
  level     = {  -- 10% .. 90%
    [1] = "\u{f007a}", [2] = "\u{f007b}", [3] = "\u{f007c}",
    [4] = "\u{f007d}", [5] = "\u{f007e}", [6] = "\u{f007f}",
    [7] = "\u{f0080}", [8] = "\u{f0081}", [9] = "\u{f0082}",
  },
  charging  = {  -- 10% .. 90%
    [1] = "\u{f089c}", [2] = "\u{f0086}", [3] = "\u{f0087}",
    [4] = "\u{f0088}", [5] = "\u{f089d}", [6] = "\u{f0089}",
    [7] = "\u{f089e}", [8] = "\u{f008a}", [9] = "\u{f008b}",
  },
}

local function battery_glyph(pct, charging)
  if not pct then return ICON.unknown end
  if charging then
    if pct >= 95 then return ICON.chg_full end
    if pct < 10 then return ICON.charging[1] end
    return ICON.charging[math.floor(pct / 10)]
  end
  if pct >= 95 then return ICON.full end
  if pct < 10 then return ICON.alert end
  return ICON.level[math.floor(pct / 10)]
end

local battery = sbar.add("item", "battery", {
  position = "right",
  icon = {
    string = ICON.unknown,
    font = { family = "JetBrainsMono Nerd Font", style = "Regular", size = 16.0 },
    color = colors.dim,
    padding_left = 8,
  },
  label = {
    string = "",
    color = colors.white,
    padding_right = 8,
  },
  update_freq = 30,
})

local function update_battery()
  local handle = io.popen("pmset -g batt")
  local out = handle:read("*a")
  handle:close()

  local pct = tonumber(out:match("(%d+)%%"))
  if not pct then
    battery:set({ drawing = false })
    return
  end

  local charging = out:match("AC Power") ~= nil

  battery:set({
    drawing = true,
    icon = {
      string = battery_glyph(pct, charging),
      color = charging and colors.accent
        or (pct <= 20 and colors.red or colors.dim),
    },
    label = {
      string = pct .. "%",
      color = (pct <= 20 and not charging) and colors.red or colors.white,
    },
  })
end

battery:subscribe({ "routine", "power_source_change", "system_woke" }, update_battery)
update_battery()
