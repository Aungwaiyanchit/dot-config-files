return {
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")

			local oxfmtFormatter = { "oxfmt", "prettierd", "prettier", stop_after_first = true }

			conform.setup({
				default_format_opts = {
					timeout_ms = 3000,
					async = false,
					quiet = false,
					lsp_format = "fallback",
				},
				formatters_by_ft = {
					javascript = oxfmtFormatter,
					typescript = oxfmtFormatter,
					javascriptreact = oxfmtFormatter,
					typescriptreact = oxfmtFormatter,
					json = oxfmtFormatter,
					css = oxfmtFormatter,
					html = oxfmtFormatter,
					markdown = oxfmtFormatter,
					yaml = oxfmtFormatter,
					less = oxfmtFormatter,
					scss = oxfmtFormatter,
					["markdown.mdx"] = oxfmtFormatter,
					lua = { "stylua" },
					python = { "black" },
					cpp = { "clang_format" },

					-- Ruby on Rail
					eruby = { "erb_format" },
					ruby = { "rubocop" },

					-- PHP/Laravel
					php = { "pint", "php_cs_fixer" },
					blade = { "blade-formatter" },
				},
				formatters = {
					oxfmt = {
						-- Treat oxfmt as available only when the project has an oxfmt config
						-- (.oxfmtrc.json / .oxfmtrc.jsonc). Without it, oxfmt is skipped and the
						-- formatter list falls back to prettier.
						require_cwd = true,
					},
				},
				format_on_save = function(bufnr)
					if vim.b[bufnr].disable_autoformat then
						return
					end
					return {
						timeout_ms = 500,
						lsp_fallback = true,
					}
				end,
			})

			vim.keymap.set({ "n", "v" }, "<leader>mp", function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				})
			end, { desc = "Format file or range (in visual mode)" })
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
}
