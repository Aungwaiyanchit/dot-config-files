vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),

	callback = function(event)

    -- Get the client that just attached
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    -- Decide which LSP does what
    if client.name == "intelephense" then
      -- Turn OFF rename + codeAction here → Phpactor will own them
      client.server_capabilities.renameProvider = false
      client.server_capabilities.codeActionProvider = false
    elseif client.name == "phpactor" then
      -- Optional: disable overlaps that Intelephense already does well
      client.server_capabilities.signatureHelpProvider = nil
      client.server_capabilities.documentFormattingProvider = false

      client.handlers["textDocument/publishDiagnostics"] = function() end
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
