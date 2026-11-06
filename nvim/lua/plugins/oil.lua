return {
	"stevearc/oil.nvim",
	lazy = false,
	---@type oil.SetupOpts
	opts = {
		columns = {
			"icon",
			{ "permissions", highlight = "Type" },
			{ "size", highlight = "String" },
			{ "mtime", highlight = "Keyword" },
		},
		lsp_file_methods = {
			-- willRenameFiles asks the LSP to update imports; save those edits.
			timeout_ms = 1000,
			enabled = true,
			autosave_changes = true,
		},
		keymaps = {
			["q"] = { "actions.close", mode = "n" },
			["<C-r>"] = "actions.refresh",
		},
		view_options = {
			show_hidden = true,
		},
		float = {
			padding = 2,
			-- 0.8 = 80% of total screen width/height so it stays visibly centered
			max_width = 0.8,
			max_height = 0.8,
			preview_split = "right",
			border = "rounded",
			win_options = {
				winblend = 0,
			},
		},
		preview_win = {
			-- Live preview: follow the cursor instead of a one-shot preview.
			update_on_cursor_moved = true,
		},
	},
	config = function(_, opts)
		require("oil").setup(opts)
		vim.keymap.set("n", "e", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	end,
}
