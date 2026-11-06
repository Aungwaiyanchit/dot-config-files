local transparency = require("utils.transparency")

local M = {}

function M.setup_gruvbox()
	vim.g.gruvbox_material_enable_italic = true
	vim.g.gruvbox_material_transparent_background = transparency.enabled() and 2 or 0
end

function M.setup_catppuccin()
	local on = transparency.enabled()
	require("catppuccin").setup({
		custom_highlights = function(colors)
			return {
				LineNr = { fg = colors.lavender },
				CursorLineNr = { fg = colors.green, bold = true },
			}
		end,
		flavour = "macchiato",
		transparent_background = on,
		dim_inactive = {
			enabled = false,
			shade = "dark",
			percentage = 0.85,
		},
		float = {
			transparent = on,
			solid = not on,
		},
		lsp_styles = {
			underlines = {
				errors = { "undercurl" },
				hints = { "undercurl" },
				warnings = { "undercurl" },
				information = { "undercurl" },
			},
		},
		auto_integrations = true,
	})
end

function M.setup_tokyonight()
	local on = transparency.enabled()
	require("tokyonight").setup({
		transparent = on,
		styles = {
			sidebars = on and "transparent" or "dark",
			floats = on and "transparent" or "dark",
		},
		on_colors = function(c)
			-- Because lualine broke stuff with the latest commit
			c.bg_statusline = c.none
		end,
		on_highlights = function(hl, c)
			hl.LineNr = { fg = "#6ab8ff", bg = "NONE" }
			hl.CursorLineNr = { fg = c.red, bg = "NONE" }
			hl.TabLineFill = { bg = c.none }
		end,
	})
end

function M.setup_solarized()
	local on = transparency.enabled()
	require("solarized-osaka").setup({
		transparent = on,
		styles = {
			comments = { italic = true },
			keywords = { italic = true },
			sidebars = on and "transparent" or "dark",
			floats = on and "transparent" or "dark",
		},
		on_colors = function(c)
			c.bg_statusline = c.none
		end,
		on_highlights = function(hl, c)
			hl.TabLineFill = { bg = c.none }
		end,
	})
end

function M.setup(name)
	if name:find("^catppuccin") then
		M.setup_catppuccin()
	elseif name:find("^tokyonight") then
		M.setup_tokyonight()
	elseif name:find("^solarized%-osaka") then
		M.setup_solarized()
	elseif name:find("^gruvbox%-material") then
		M.setup_gruvbox()
	end
end

return M
