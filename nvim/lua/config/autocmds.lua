-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- nvim-treesitter rewrite does not enable highlight or indent from setup().
local treesitter_group = vim.api.nvim_create_augroup("treesitter-features", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = treesitter_group,
	callback = function(args)
		local bufnr = args.buf
		if vim.bo[bufnr].buftype ~= "" then
			return
		end
		local filetype = vim.bo[bufnr].filetype
		if filetype == "" or filetype == "oil" then
			return
		end

		-- language.add returns nil (it does not throw) when no parser exists.
		-- pcall alone is not a valid check: it is true whenever add does not error.
		local lang = vim.treesitter.language.get_lang(filetype) or filetype
		local ok, loaded = pcall(vim.treesitter.language.add, lang)
		if not ok or not loaded then
			return
		end
		if not pcall(vim.treesitter.start, bufnr, lang) then
			return
		end
		vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
