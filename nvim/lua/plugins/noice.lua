return {
	"folke/noice.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	event = "VeryLazy",
	config = function()
		require("noice").setup({
			lsp = {
				progress = { enabled = false },
				signature = { enabled = false },
				message = { enabled = false },

				hover = {
					enabled = false,
					silent = false,
					enter = false,
					anchor = "auto",
					position = { row = 1, col = 2 },
					opts = {
						border = {
							style = "rounded",
						},
					},
				},
			},
		})
	end,
}
