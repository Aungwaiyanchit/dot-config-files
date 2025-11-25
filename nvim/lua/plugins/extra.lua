local progress = require("noice.lsp.progress")
return {
	"nvim-lua/plenary.nvim", -- lua functions that many plugins use

	"christoomey/vim-tmux-navigator", -- tmux & split window navigation
	{

		"ibhagwan/fzf-lua",
		dependencies = { "nvim-mini/mini.icons" },
		opts = {},
	},
	{
		"MunifTanjim/nui.nvim",
	},
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
	},
	{
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

					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = false,
						["vim.lsp.util.stylize_markdown"] = false,
						["cmp.entry.get_documentation"] = true,
					},
				},
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		opts = {},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "snacks.nvim", words = { "Snacks" } },
			},
		},
	},
}
