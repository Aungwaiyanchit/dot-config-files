-- ~/.config/sketchybar/colors.lua
-- Picks a light or dark palette by analyzing the current wallpaper
-- (plugins/detect_theme.sh). theme_watch.sh reloads the bar when it changes.

local colors = {}

local function current_theme()
  local h = io.popen(os.getenv("HOME")
    .. "/.config/sketchybar/plugins/detect_theme.sh 2>/dev/null")
  local out = h and h:read("*a") or ""
  if h then h:close() end

  local t = out:match("^%s*(%a+)")
  if t ~= "light" and t ~= "dark" then t = "dark" end

  -- Publish the result so theme_watch.sh doesn't double-reload at startup
  local f = io.open((os.getenv("TMPDIR") or "/tmp") .. "sketchybar_theme", "w")
  if f then f:write(t); f:close() end

  return t
end

local palette = {
  dark = {
    white  = 0xffffffff,  -- primary text
    dim    = 0x88ffffff,  -- secondary text / inactive icons
    bg     = 0xff2a2937,  -- pill background (solid)
    bar    = 0xff1c1b26,  -- bar background (solid)
    accent = 0xff7aa2f7,
    red    = 0xffff5c57,
    green  = 0xff9ece6a,
  },
  light = {
    white  = 0xff1c1b26,  -- primary text (dark ink)
    dim    = 0x991c1b26,  -- secondary text
    bg     = 0xfff5f5f7,  -- pill background (solid)
    bar    = 0xffececf0,  -- bar background (solid)
    accent = 0xff3b6fd8,
    red    = 0xffd64545,
    green  = 0xff2f9e44,
  },
}

colors.theme = current_theme()
local p = palette[colors.theme]
for k, v in pairs(p) do colors[k] = v end

return colors
