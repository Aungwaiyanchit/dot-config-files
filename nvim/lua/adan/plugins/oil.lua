local M = {
	"stevearc/oil.nvim",
	enabled = true,
	dependencies = {
		{
			"nvim-mini/mini.icons",
			opts = {},
			config = function()
				require("mini.icons").setup()
			end,
		},
		{
			"refractalize/oil-git-status.nvim",
		},
	},

	keys = {
		{ "-", "<cmd>Oil<cr>", desc = "Oil" },
	},
}

function M.config()
	require("oil").setup({
		default_file_explorer = true,
		win_options = {
			signcolumn = "yes:1",
		},
		keymaps = {
			["g?"] = "actions.show_help",
			["<CR>"] = "actions.select",
			["l"] = "actions.select",
			["<C-k>"] = "actions.select_vsplit",
			["<C-j>"] = "actions.select_split",
			["<C-t>"] = "actions.select_tab",
			["<C-p>"] = "actions.preview",
			["<C-c>"] = "actions.close",
			["q"] = "actions.close",
			["esc"] = "actions.close",
			["r"] = "actions.refresh",
			["h"] = "actions.parent",
			["_"] = "actions.open_cwd",
			["`"] = "actions.cd",
			["~"] = "actions.tcd",
			["gs"] = "actions.change_sort",
			["gx"] = "actions.open_external",
			["."] = "actions.toggle_hidden",
			["g\\"] = "actions.toggle_trash",
		},
		view_options = {
			show_hidden = true,
			natural_order = true,
			is_always_hidden = function(name, _)
				return name == ".." or name == ".git"
			end,
		},
	})

	require("oil-git-status").setup({
		show_ignored = true, -- show files that match gitignore with !!
		symbols = { -- customize the symbols that appear in the git status columns
			index = {
				["!"] = "!",
				["?"] = "?",
				["A"] = "",
				["C"] = "󰆏",
				["D"] = "",
				["M"] = "",
				["R"] = "",
				["T"] = "󰉺",
				["U"] = "",
				[" "] = " ",
			},
			working_tree = {
				["!"] = "!",
				["?"] = "?",
				["A"] = "",
				["C"] = "󰆏",
				["D"] = "",
				["M"] = "",
				["R"] = "",
				["T"] = "󰉺",
				["U"] = "",
				[" "] = " ",
			},
		},
	})
end

return M
