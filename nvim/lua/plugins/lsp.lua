return {
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			-- list of servers for mason to install
			ensure_installed = {
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"svelte",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"prismals",
				"pyright",
				"eslint",
				"intelephense",
				"ruby_lsp",
				"gopls",
			},
			-- Intelephense owns PHP. An already-installed phpactor must not start.
			automatic_enable = {
				exclude = { "phpactor" },
			},
		},
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
			},
			"neovim/nvim-lspconfig",
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			-- Mason package names for the formatters Conform actually runs.
			-- oxfmt and prettierd stay project-local; the chain falls through to prettier.
			ensure_installed = {
				"prettier",
				"stylua",
				"clang-format",
				"erb-formatter",
				"rubocop",
				"php-cs-fixer",
				"blade-formatter",
			},
		},
		dependencies = {
			"williamboman/mason.nvim",
		},
	},
}
