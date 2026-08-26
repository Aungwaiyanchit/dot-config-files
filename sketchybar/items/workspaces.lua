-- ~/.config/sketchybar/items/workspaces.lua

local sbar = require("sketchybar")
local colors = require("colors")

-- Create a custom event
sbar.add("event", "omniwm_workspace_change")

local workspaces = {}
local MAX_WORKSPACES = 9

-- Helper: get current focused workspace number from OmniWM.
-- NOTE: sbar.exec callbacks are unreliable here (Lua 5.5 + SbarLua ABI
-- mismatch), so we read the output synchronously via io.popen.
-- JSON structure: result.payload.workspace.number
local function get_focused_workspace()
  local handle = io.popen("omniwmctl query active-workspace --format json")
  local result = handle:read("*a")
  handle:close()

  local num = result:match('"workspace".-"number"%s*:%s*(%d+)')
  return num and tonumber(num) or nil
end

-- Helper: numbers of workspaces that currently exist in OmniWM
local function get_existing_workspaces()
  local handle = io.popen("omniwmctl query workspaces --format json")
  local result = handle:read("*a")
  handle:close()

  local existing = {}
  for num in result:gmatch('"number"%s*:%s*(%d+)') do
    existing[tonumber(num)] = true
  end
  return existing
end

-- One query per event updates every item
local function update_workspaces()
  local focused = get_focused_workspace()
  local existing = get_existing_workspaces()
  for i = 1, MAX_WORKSPACES do
    local selected = (focused == i)
    workspaces[i]:set({
      drawing = existing[i] and true or false,
      icon = { highlight = selected },
      background = {
        drawing = true,
        color = selected and colors.accent or colors.bg,
      },
    })
  end
end

-- Create workspace items
for i = 1, MAX_WORKSPACES do
  workspaces[i] = sbar.add("item", "workspace." .. i, {
    position = "left",
    icon = {
      string = tostring(i),
      font = { family = "JetBrainsMono Nerd Font", style = "SemiBold", size = 13.0 },
      padding_left = 10,
      padding_right = 3,
      color = colors.dim,
      highlight_color = colors.white,
    },
    background = {
      color = colors.bg,
      corner_radius = 13,
      height = 26,
      drawing = true,
    },
    click_script = "omniwmctl command switch-workspace " .. i,
  })

  workspaces[i]:subscribe("omniwm_workspace_change", update_workspaces)
end

-- Initial highlight on load
update_workspaces()
