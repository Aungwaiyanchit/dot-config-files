-- ~/.config/sketchybar/items/wifi.lua

local sbar = require("sketchybar")
local colors = require("colors")

local icons = require("icons") -- your icons table
local settings = require("settings")


local popup_width = 350

-- Main WiFi item (the one that appears in the bar)
local wifi = sbar.add("item", "widgets.wifi", {
	position = "right",
	icon = {
		string = icons.wifi.connected, -- or disconnected
		font = { style = settings.font.style_map["Regular"], size = 14.0 },
		color = colors.dim,
	},
	label = { drawing = false },
	popup = {
		align = "center",
		height = 30,
		background = {
			color = colors.bg,
			border_color = colors.accent,
			border_width = 2,
			corner_radius = 4,
			padding_left = 10,
			padding_right = 10,
		},
	},
})

-- Popup items (these only appear when the popup is open)
local ssid = sbar.add("item", {
	position = "popup." .. wifi.name,
	icon = {
		string = icons.wifi.router,
		font = { style = settings.font.style_map["Bold"] },
	},
	width = popup_width,
	align = "center",
	label = {
		string = "????????????",
		font = { size = 15, style = settings.font.style_map["Bold"] },
		max_chars = 18,
	},
	background = {
		height = 2,
		color = colors.grey,
		y_offset = -15,
	},
})

local hostname = sbar.add("item", {
	position = "popup." .. wifi.name,
	icon = {
		string = "Hostname:",
		width = popup_width / 2,
		align = "left",
	},
	label = {
		string = "????????????",
		width = popup_width / 2,
		align = "right",
		max_chars = 20,
	},
})

local ip = sbar.add("item", {
	position = "popup." .. wifi.name,
	icon = {
		string = "IP:",
		width = popup_width / 2,
		align = "left",
	},
	label = {
		string = "???.???.???.???",
		width = popup_width / 2,
		align = "right",
	},
})

local mask = sbar.add("item", {
	position = "popup." .. wifi.name,
	icon = {
		string = "Subnet mask:",
		width = popup_width / 2,
		align = "left",
	},
	label = {
		string = "???.???.???.???",
		width = popup_width / 2,
		align = "right",
	},
})

local router = sbar.add("item", {
	position = "popup." .. wifi.name,
	icon = {
		string = "Router:",
		width = popup_width / 2,
		align = "left",
	},
	label = {
		string = "???.???.???.???",
		width = popup_width / 2,
		align = "right",
	},
})

local wifi_controls = sbar.add("item", {
	position = "popup." .. wifi.name,

	icon = {
		string = "Wi-Fi",
		width = popup_width / 2,
		align = "left",
	},

	label = {
		string = "ON",
		width = popup_width / 2,
		align = "right",
	},
})

local wifi_settings = sbar.add("item", {
	position = "popup." .. wifi.name,
	width = popup_width,
	align = "center",
	icon = {
		string = icons.settings,
	},
	label = {
		string = "Wi-Fi Settings",
	},
	background = {
		height = 50,
	},
})

local function hide_details()
	wifi:set({ popup = { drawing = false } })
end

local function toggle_details()
	local drawing = wifi:query().popup.drawing == "off"
	if drawing then
		wifi:set({ popup = { drawing = true } })

		-- Fetch real data
		sbar.exec("networksetup -getcomputername", function(result)
			hostname:set({ label = { string = result } })
		end)

		sbar.exec("ipconfig getifaddr en0", function(result)
			ip:set({ label = { string = result } })
		end)

		-- SSID (works on recent macOS)
		sbar.exec("ipconfig getsummary en0 | awk -F ' SSID : ' '/ SSID : / {print $2}'", function(result)
			ssid:set({ label = { string = result } })
		end)

		sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Subnet mask: ' '/^Subnet mask: / {print $2}'", function(result)
			mask:set({ label = { string = result } })
		end)

		sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Router: ' '/^Router: / {print $2}'", function(result)
			router:set({ label = { string = result } })
		end)
	else
		hide_details()
	end
end


local function update_wifi_power()
	sbar.exec(
		"networksetup -getairportpower en0",
		function(result)

			local enabled = result:match("On") ~= nil

			wifi_controls:set({
				label = {
					string = enabled and "ON" or "OFF",
					color = enabled and colors.accent or colors.red,
				},
			})

		end
	)
end


local function toggle_wifi_power()
	sbar.exec(
		"networksetup -getairportpower en0",
		function(result)

			local enabled = result:match("On") ~= nil

			local state = enabled and "off" or "on"

			sbar.exec(
				"networksetup -setairportpower en0 " .. state,
				function()
					update_wifi_power()
				end
			)

		end
	)
end

-- Click to toggle
wifi:subscribe("mouse.clicked", toggle_details)

-- Hide when mouse leaves
wifi:subscribe("mouse.exited.global", hide_details)

wifi:subscribe({ "wifi_change", "system_woke", "forced" }, function()
	sbar.exec("ipconfig getifaddr en0", function(ip_addr)
		local connected = ip_addr ~= ""
		wifi:set({
			icon = {
				string = connected and icons.wifi.connected or icons.wifi.disconnected,
				color = connected and colors.accent or colors.red,
			},
		})
	end)
end)


wifi_settings:subscribe("mouse.clicked", function()
	sbar.exec("open 'x-apple.systempreferences:com.apple.wifi-settings'")
end)


wifi_controls:subscribe("mouse.clicked", toggle_wifi_power)
