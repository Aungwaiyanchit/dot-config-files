local theme_file = vim.fn.expand("~/.config/shared-theme/current_theme.txt")
local active = "tokyonight"
if vim.fn.filereadable(theme_file) == 1 then
	local saved = vim.fn.readfile(theme_file)[1]
	if saved and vim.trim(saved) ~= "" then
		active = vim.trim(saved)
	end
end

local function is_active(name)
	return active == name or vim.startswith(active, name .. "-")
end

return {
	{
		"sainnhe/gruvbox-material",
		lazy = not is_active("gruvbox-material"),
		priority = is_active("gruvbox-material") and 1000 or nil,
		config = function()
			require("utils.themes").setup_gruvbox()
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = not is_active("catppuccin"),
		priority = is_active("catppuccin") and 1000 or nil,
		config = function()
			require("utils.themes").setup_catppuccin()
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = not is_active("tokyonight"),
		priority = is_active("tokyonight") and 1000 or nil,
		config = function()
			require("utils.themes").setup_tokyonight()
		end,
	},
	{
		"craftzdog/solarized-osaka.nvim",
		name = "solarized-osaka.nvim",
		lazy = not is_active("solarized-osaka"),
		priority = is_active("solarized-osaka") and 1000 or nil,
		config = function()
			require("utils.themes").setup_solarized()
		end,
	},
}
