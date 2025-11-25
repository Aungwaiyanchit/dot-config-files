return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-mini/mini.icons",
	},
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status")
		lualine.setup({
			sections = {
				lualine_x = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
					},
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					{ "encoding" },
					{ "fileformat", symbols = { unix = "" } },
					{ "filetype" },
				},
			},
		})
	end,
}
