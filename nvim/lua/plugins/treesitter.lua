return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		-- The rewrite does not support lazy-loading, and setup() no longer accepts
		-- highlight/indent. Those are enabled from the FileType autocmd.
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local ensure_installed = {
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
				"php",
				"ruby",
				"go",
				"python",
			}
			local installed = require("nvim-treesitter.config").get_installed("parsers")
			local missing = vim.tbl_filter(function(lang)
				return not vim.tbl_contains(installed, lang)
			end, ensure_installed)
			if #missing > 0 then
				require("nvim-treesitter").install(missing)
			end
		end,
	},
}
