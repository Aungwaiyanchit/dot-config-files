-- Shared theme state file (Nvim + WezTerm)
local theme_state_file = vim.fn.expand("~/.config/shared-theme/current_theme.txt")

-- Load last saved theme on startup
local function load_last_theme()
	if vim.fn.filereadable(theme_state_file) == 1 then
		local lines = vim.fn.readfile(theme_state_file)
		local theme = lines[1]
		if theme and theme ~= "" then
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

load_last_theme()

local function open_theme_picker()
	local themes = vim.fn.getcompletion("", "color")
	if not themes or #themes == 0 then
		vim.notify("No colorschemes found", vim.log.levels.WARN, { title = "Theme Picker" })
		return
	end

	table.sort(themes)

	vim.ui.select(themes, {
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

vim.api.nvim_create_user_command("ThemeSelectSimple", open_theme_picker, {})
vim.keymap.set("n", "<leader>ut", open_theme_picker, { desc = "Theme picker (vim.ui.select)" })
