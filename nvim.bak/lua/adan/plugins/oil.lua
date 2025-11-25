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
			["g?"] = { "actions.show_help", mode = "n" },
			["<CR>"] = "actions.select",
			["<C-s>"] = { "actions.select", opts = { vertical = true } },
			["<C-u>"] = { "actions.select", opts = { horizontal = true } },
			["<C-t>"] = { "actions.select", opts = { tab = true } },
			["<C-p>"] = "actions.preview",
			["<C-c>"] = { "actions.close", mode = "n" },
			["<C-r>"] = "actions.refresh",
			["-"] = { "actions.parent", mode = "n" },
			["_"] = { "actions.open_cwd", mode = "n" },
			["`"] = { "actions.cd", mode = "n" },
			["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
			["gs"] = { "actions.change_sort", mode = "n" },
			["gx"] = "actions.open_external",
			["g."] = { "actions.toggle_hidden", mode = "n" },
			["g\\"] = { "actions.toggle_trash", mode = "n" },
		},
    use_default_keymaps = false,
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
