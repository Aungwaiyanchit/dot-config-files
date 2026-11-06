return {
	"nvim-lualine/lualine.nvim",
	config = function()
		local lualine = require("lualine")
		local lualine_utils = require("utils.lualine")
		local icons = require("utils.icons")
		lualine.setup({
			options = {
				theme = "auto",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = {
					lualine_utils.pretty_path({
						length = 0,
						relative = "cwd",
						modified_hl = "MatchParen",
						directory_hl = "",
						filename_hl = "Bold",
						modified_sign = "",
						readonly_icon = " 󰌾 ",
					}),
				},
				lualine_x = {
					lualine_utils.macro_recording(),
					{
						"diagnostics",
						symbols = {
							error = icons.diagnostics.Error,
							warn = icons.diagnostics.Warn,
							info = icons.diagnostics.Info,
							hint = icons.diagnostics.Hint,
						},
					},
					{
						"diff",
						symbols = {
							added = icons.git.added,
							modified = icons.git.modified,
							removed = icons.git.removed,
						},
						source = function()
							local gitsigns = vim.b.gitsigns_status_dict
							if gitsigns then
								return {
									added = gitsigns.added,
									modified = gitsigns.changed,
									removed = gitsigns.removed,
								}
							end
						end,
					},
				},
				lualine_y = {
					{ "progress", separator = " ", padding = { left = 1, right = 1 } },
				},
				lualine_z = {
					{ "location", padding = { left = 1, right = 1 } },
				},
			},
		})
	end,
}
