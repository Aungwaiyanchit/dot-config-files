return {
	"refractalize/oil-git-status.nvim",
	dependencies = { "stevearc/oil.nvim" },
	-- Load with Oil so the first directory listing already has git signs.
	lazy = false,
	opts = {
		show_ignored = true,
	},
}
