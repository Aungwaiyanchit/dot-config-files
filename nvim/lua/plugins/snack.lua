return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		dashboard = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		picker = {
			enabled = true,
			sources = {
				explorer = {
					hidden = true,
					ignored = true,
					exclude = { "**/.git", "**/.DS_Store" },
					layout = {
						preset = "right",
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
		scroll = { enabled = false },
		statuscolumn = { enabled = true },
		words = { enabled = true },
	},
	keys = {
		-- {
		-- 	"<leader>e",
		-- 	function()
		-- 		Snacks.explorer({
		-- 			auto_close = true,
		-- 		})
		-- 	end,
		-- 	desc = "File Explorer",
		-- },
	},
}
