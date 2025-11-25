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
	end,
}
