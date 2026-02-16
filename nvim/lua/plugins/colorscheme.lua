return {
	{
		"sainnhe/gruvbox-material",
		enabled = true,
		priority = 1000,
		config = function()
			-- vim.g.gruvbox_material_transparent_background = 1
			vim.g.gruvbox_material_foreground = "mix"
			vim.g.gruvbox_material_background = "hard"
			vim.g.gruvbox_material_ui_contrast = "high"
			vim.g.gruvbox_material_float_style = "bright"
			vim.g.gruvbox_material_statusline_style = "material" -- Options: "original", "material", "mix", "afterglow"
			vim.g.gruvbox_material_cursor = "auto"
			-- vim.cmd.colorscheme("gruvbox-material")
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				custom_highlights = function(colors)
					return {
						LineNr = { fg = colors.lavender },
						CursorLineNr = { fg = colors.green, bold = true }, -- e.g., colors.text, colors.yellow
					}
				end,
				flavour = "macchiato",
				transparent_background = true,
				dim_inactive = {
					enabled = false, -- dims the background color of inactive window
					shade = "dark",
					percentage = 0.85, -- percentage of the shade to apply to the inactive window
				},
				float = {
					transparent = true, -- enable transparent floating windows
					solid = true, -- use solid styling for floating windows, see |winborder|
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
		end,
		opts = {},
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
			on_colors = function(c)
				-- Because lualine broke stuff with the latest commit
				c.bg_statusline = c.none
			end,
			on_highlights = function(hl, c)
				hl.LineNr = { fg = '#6ab8ff', bg = "NONE" }
				hl.CursorLineNr = { fg = c.red, bg = "NONE" }
				hl.TabLineFill = {
					bg = c.none,
				}
			end,
		},
	},
}
