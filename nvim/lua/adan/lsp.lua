vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),

	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		local fzf = require("fzf-lua")

		map("gd", fzf.lsp_definitions, "Goto Definition")
		map("gD", vim.lsp.buf.declaration, "Goto Declaration")
		map("gr", fzf.lsp_references, "Goto References")
		map("gI", fzf.lsp_implementations, "Goto Implementation")
		map("<leader>D", fzf.lsp_typedefs	, "Type Definition")
		map("<leader>ds", fzf.lsp_document_symbols, "Document Symbols")
		map("<leader>ws", fzf.lsp_workspace_symbols, "Workspace Symbols")
		map("<leader>rn", vim.lsp.buf.rename, "Rename")
    map("<leader>ca", fzf.lsp_code_actions, "Code Action")
    map("<leader>sg", fzf.spell_suggest, "Spelling Suggestions")
	end,
})

vim.diagnostic.config({
	-- virtual_lines = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚",
			[vim.diagnostic.severity.WARN] = "󰀪",
			[vim.diagnostic.severity.INFO] = "󰋽",
			[vim.diagnostic.severity.HINT] = "󰌶",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
})
