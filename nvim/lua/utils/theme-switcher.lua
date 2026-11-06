-- Shared theme state file (Nvim + WezTerm)
local theme_state_file = vim.fn.expand("~/.config/shared-theme/current_theme.txt")

local theme_plugins = {
	{ prefix = "tokyonight", plugin = "tokyonight.nvim" },
	{ prefix = "catppuccin", plugin = "catppuccin" },
	{ prefix = "gruvbox-material", plugin = "gruvbox-material" },
	{ prefix = "solarized-osaka", plugin = "solarized-osaka.nvim" },
}

local function plugin_for(theme)
	for _, item in ipairs(theme_plugins) do
		if theme == item.prefix or vim.startswith(theme, item.prefix .. "-") then
			return item.plugin
		end
	end
end

local function load_plugin(name)
	local ok, lazy = pcall(require, "lazy")
	if ok then
		lazy.load({ plugins = { name } })
	end
end

local function ensure_theme(theme)
	local plugin = plugin_for(theme)
	if plugin then
		load_plugin(plugin)
	end
end

local transparency = require("utils.transparency")
local themes = require("utils.themes")

-- Load last saved theme on startup
local function load_last_theme()
	if vim.fn.filereadable(theme_state_file) == 1 then
		local lines = vim.fn.readfile(theme_state_file)
		local theme = lines[1] and vim.trim(lines[1]) or ""
		if theme ~= "" then
			ensure_theme(theme)
			themes.setup(theme)
			pcall(vim.cmd.colorscheme, theme)
		end
	end
end

local function trigger_wezterm_reload()
	-- Fire and forget: don't block Neovim
	-- This calls: `wezterm cli reload-configuration`
	pcall(function()
		vim.fn.jobstart({ "wezterm", "cli", "reload-configuration" }, {
			detach = true,
		})
	end)
end

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("transparent-background", { clear = true }),
	callback = function()
		transparency.apply()
	end,
})

load_last_theme()

local function open_theme_picker()
	for _, item in ipairs(theme_plugins) do
		load_plugin(item.plugin)
	end
	local choices = vim.fn.getcompletion("", "color")
	if not choices or #choices == 0 then
		vim.notify("No colorschemes found", vim.log.levels.WARN, { title = "Theme Picker" })
		return
	end

	table.sort(choices)

	vim.ui.select(choices, {
		prompt = "Select colorscheme",
		format_item = function(item)
			-- Mark current theme with ●
			local current = vim.g.colors_name or ""
			local icon = (item == current) and "●" or ""
			return string.format("%s  %s", icon, item)
		end,
	}, function(choice)
		if not choice then
			return
		end

		ensure_theme(choice)
		themes.setup(choice)
		-- apply colorscheme
		local ok, err = pcall(vim.cmd.colorscheme, choice)
		if not ok then
			vim.notify("Error loading " .. choice .. ": " .. err, vim.log.levels.ERROR, {
				title = "Theme Picker",
			})
			return
		end

		-- make sure directory exists
		local dir = vim.fn.fnamemodify(theme_state_file, ":h")
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end

		-- write theme so WezTerm can read it
		vim.fn.writefile({ choice }, theme_state_file)

		-- Ask WezTerm to reload its config now
		trigger_wezterm_reload()
	end)
end

local function toggle_transparent()
	local on = not transparency.enabled()
	transparency.set(on)
	local name = vim.g.colors_name
	if name and name ~= "" then
		ensure_theme(name)
		themes.setup(name)
		local ok, err = pcall(vim.cmd.colorscheme, name)
		if not ok then
			vim.notify("Error reloading " .. name .. ": " .. err, vim.log.levels.ERROR, { title = "Transparent" })
			return
		end
	end
	transparency.apply()
	vim.notify(on and "Transparent background on" or "Transparent background off", vim.log.levels.INFO, {
		title = "Transparent",
	})
end

vim.api.nvim_create_user_command("ThemeSelectSimple", open_theme_picker, {})
vim.api.nvim_create_user_command("TransparentToggle", toggle_transparent, {})
vim.keymap.set("n", "<leader>ut", open_theme_picker, { desc = "Theme picker (vim.ui.select)" })
vim.keymap.set("n", "<leader>ub", toggle_transparent, { desc = "Toggle transparent background" })
