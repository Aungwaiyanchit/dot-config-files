return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- Must load at startup so `nvim .` and `:e <dir>` never fall through to netrw.
	lazy = false,
	---@type oil.SetupOpts
	opts = {
		default_file_explorer = true,
		-- Directory is a buffer: rename, move, and delete by editing, then :w.
		columns = { "icon", "permissions", "size", "mtime" },
		lsp_file_methods = {
			-- willRenameFiles asks the LSP to update imports; save those edits.
			enabled = true,
			autosave_changes = true,
		},
		keymaps = {
			["q"] = { "actions.close", mode = "n", nowait = true, desc = "Close oil" },
		},
		view_options = {
			show_hidden = true,
		},
		float = {
			-- Centered by oil's float layout. Cap includes the preview split.
			max_width = 200,
			border = "rounded",
			preview_split = "right",
		},
		preview_win = {
			-- Live preview: follow the cursor instead of a one-shot preview.
			update_on_cursor_moved = true,
		},
	},
	config = function()
		require("oil").setup()
		vim.keymap.set("n", "e", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	end,
}
