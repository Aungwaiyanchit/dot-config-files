return {
	"folke/snacks.nvim",
	dependencies = {
		"echasnovski/mini.icons",
		opts = {},
		config = function()
			require("mini.icons").setup()
		end,
	},
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		dashboard = { enabled = true },
		explorer = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		picker = {
			enabled = true,
			sources = {
				explorer = {
					ignored = true,
					exclude = { "**/.git", "**/.DS_Store" },
					layout = {
						preset = "left",
					},
					icons = {
						git = {
							staged = "●",
							added = "",
							deleted = "",
							ignored = "◌",
							modified = "",
							renamed = "󰑕",
							untracked = "",
						},
					},
				},
			},
		},
		notifier = { enabled = true },
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
	},
	keys = {
		{
			"<leader>e",
			function()
				Snacks.explorer({
					auto_close = true,
				})
			end,
			desc = "File Explorer",
		},
	},
}
