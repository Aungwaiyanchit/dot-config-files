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

		if filetype == "oil" then
			return
		end
		local filetype = vim.bo[bufnr].filetype
		local lang = vim.treesitter.language.get_lang(filetype) or filetype
		if lang == "" or not pcall(vim.treesitter.language.add, lang) then
			return
		end
		vim.treesitter.start(bufnr, lang)
		vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
