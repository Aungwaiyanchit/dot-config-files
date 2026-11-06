-- Hide ts_ls diagnostics on a buffer ESLint already owns, so each warning is reported once.
local function silence_ts_ls(bufnr)
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr, name = "ts_ls" })) do
		client.server_capabilities.diagnosticProvider = nil
		local prefix = "nvim.lsp.ts_ls." .. client.id
		for name, ns in pairs(vim.api.nvim_get_namespaces()) do
			if name == prefix or vim.startswith(name, prefix .. ".") then
				vim.diagnostic.enable(false, { bufnr = bufnr, ns_id = ns })
				vim.diagnostic.reset(ns, bufnr)
			end
		end
		local push_ns = vim.lsp.diagnostic.get_namespace(client.id)
		vim.diagnostic.enable(false, { bufnr = bufnr, ns_id = push_ns })
		vim.diagnostic.reset(push_ns, bufnr)
	end
end

local function eslint_owns(bufnr)
	return #vim.lsp.get_clients({ bufnr = bufnr, name = "eslint" }) > 0
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),

	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if not client then
			return
		end

		if client.name == "eslint" or (client.name == "ts_ls" and eslint_owns(event.buf)) then
			silence_ts_ls(event.buf)
			-- A pull may already be in flight. Hide whatever lands in this tick.
			vim.schedule(function()
				if vim.api.nvim_buf_is_valid(event.buf) and eslint_owns(event.buf) then
					silence_ts_ls(event.buf)
				end
			end)
		end

		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		local fzf = require("fzf-lua")
		local hover = function()
			vim.lsp.buf.hover({ border = "rounded", max_height = 25, max_width = 120 })
		end

		map("gd", fzf.lsp_definitions, "Goto Definition")
		map("gD", vim.lsp.buf.declaration, "Goto Declaration")
		map("gr", fzf.lsp_references, "Goto References")
		map("gI", fzf.lsp_implementations, "Goto Implementation")
		map("<leader>D", fzf.lsp_typedefs, "Type Definition")
		map("<leader>ds", fzf.lsp_document_symbols, "Document Symbols")
		map("<leader>ws", fzf.lsp_workspace_symbols, "Workspace Symbols")
		map("<leader>rn", vim.lsp.buf.rename, "Rename")
		map("<leader>ca", fzf.lsp_code_actions, "Code Action")
		map("<leader>sg", fzf.spell_suggest, "Spelling Suggestions")
		map("K", hover, "Show documentation for what is under cursor")
	end,
})

-- Stop phpactor if a previous config already enabled it. Intelephense owns PHP.
pcall(vim.lsp.enable, "phpactor", false)

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
