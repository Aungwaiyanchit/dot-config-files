-- ~/.config/sketchybar/init.lua

local CONFIG_DIR = os.getenv("HOME") .. "/.config/sketchybar"

package.path = CONFIG_DIR .. "/?.lua;" .. package.path
package.cpath = package.cpath .. ";" .. os.getenv("HOME") .. "/.local/share/sketchybar_lua/?.so"

local sbar = require("sketchybar")
local colors = require("colors")

-- Floating-pill bar: fully transparent strip sized to the native
-- (notched) macOS menu bar. Nothing is placed in the center, so the
-- notch area stays empty.
sbar.bar({
  height = 32,
  color = colors.bar,
  blur_radius = 0,
  shadow = false,
  padding_left = 12,
  padding_right = 12,
  position = "top",
  sticky = true,
  topmost = "window",
})

-- Default pill style
sbar.default({
  icon = {
    font = { family = "JetBrainsMono Nerd Font", style = "Regular", size = 14.0 },
    color = colors.white,
    padding_left = 10,
    padding_right = 10,
  },
  label = {
    font = { family = "JetBrainsMono Nerd Font", style = "Medium", size = 13.0 },
    color = colors.white,
    padding_left = 2,
    padding_right = 6,
  },
  background = {
    color = colors.bg,
    height = 26,
    corner_radius = 13,
    border_width = 0,
  },
  padding_left = 3,
  padding_right = 3,
})

-- Start the workspace-change and theme watchers.
-- Managed via launchctl so reloads can't leave duplicates or race with cleanup.
sbar.exec("launchctl remove com.user.omniwm-watch 2>/dev/null; "
  .. "launchctl submit -l com.user.omniwm-watch -- /bin/bash "
  .. CONFIG_DIR .. "/plugins/omniwm_watch.sh")
sbar.exec("launchctl remove com.user.theme-watch 2>/dev/null; "
  .. "launchctl submit -l com.user.theme-watch -- /bin/bash "
  .. CONFIG_DIR .. "/plugins/theme_watch.sh")

-- Load items (creation order == display order per side)
require("items.apple")       -- left:    (logo)
require("items.workspaces")  -- left:    1..9 pills
require("items.clock")       -- right:   date/time (rightmost)
require("items.battery")     -- right:   battery + %
require("items.wifi")        -- right:   wifi (+ popup menu)
require("items.volume")      -- right:   volume


sbar.hotload(true) -- optional, useful while developing
sbar.exec("sketchybar --update")

-- Keep this process alive to service event subscriptions and exec callbacks
sbar.event_loop()
