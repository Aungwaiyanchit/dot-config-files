return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			opts = function(_, opts)
				vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
					pattern = { "*.component.html", "*.container.html" },
					callback = function()
						vim.treesitter.start(nil, "angular")
					end,
				})
			end
			local config = require("nvim-treesitter.configs")
			config.setup({
				sync_install = true,
				ignore_install = {},
				modules = {},
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				ensure_installed = {
					"json",
					"javascript",
					"typescript",
					"tsx",
					"yaml",
					"html",
					"css",
					"prisma",
					"markdown",
					"markdown_inline",
					"svelte",
					"graphql",
					"bash",
					"lua",
					"vim",
					"dockerfile",
					"gitignore",
					"query",
					"vimdoc",
					"c",
					"vue",
					"ruby",
					"angular",
					"scss",
				},
			})
		end,
	},
}
