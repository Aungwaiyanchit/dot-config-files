return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-mini/mini.icons" },
	opts = {},
	config = function()
		local keymap = vim.keymap
    local fzf = require("fzf-lua");
    keymap.set("n", "<leader>ff", fzf.files, { desc = "find files"})
    keymap.set("n", "<leader>fs", fzf.live_grep_native, { desc = "live grep"})
    keymap.set("n", "<leader>lr", fzf.lsp_references, { desc = "lsp references"})
    keymap.set("n", "<leader>km", fzf.keymaps, { desc = "view all keymaps"})
	end,
}
