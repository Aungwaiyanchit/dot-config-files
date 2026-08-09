return {
	{
		"nvim-treesitter/nvim-treesitter",
		init = function()
			local ensureInstalled = {
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
				"blade",
				"cpp",
			}
			local alreadyInstalled = require("nvim-treesitter.config").get_installed()
			local parsersToInstall = vim.iter(ensureInstalled)
				:filter(function(parser)
					return not vim.tbl_contains(alreadyInstalled, parser)
				end)
				:totable()
			require("nvim-treesitter").install(parsersToInstall)
		end,
		opts = {
			indent = { enable = true },
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
		},
		config = function(_, opts)
			require("nvim-treesitter").setup(opts)
		end,
	},
}
