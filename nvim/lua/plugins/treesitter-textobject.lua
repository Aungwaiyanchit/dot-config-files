return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	init = function()
		vim.g.no_plugin_maps = true
	end,
	config = function()
		require("nvim-treesitter-textobjects").setup({
			select = {
				-- Automatically jump forward to textobj, similar to targets.vim
				lookahead = true,

				selection_modes = {
					["@function.inner"] = "V", -- linewise
					["@function.outer"] = "V", -- linewise
					["@class.outer"] = "V", -- linewise
					["@class.inner"] = "V", -- linewise
					["@parameter.outer"] = "v", -- charwise
				},

				include_surrounding_whitespace = false,
			},
		})

		-- Keymaps are now set using Neovim's native API
		local ts_select = require("nvim-treesitter-textobjects.select")

		local function map(lhs, query, desc)
			vim.keymap.set({ "x", "o" }, lhs, function()
				ts_select.select_textobject(query, "textobjects")
			end, { desc = desc })
		end

		map("a=", "@assignment.outer", "Select outer part of an assignment")
		map("i=", "@assignment.inner", "Select inner part of an assignment")
		map("l=", "@assignment.lhs", "Select left hand side of an assignment")
		map("r=", "@assignment.rhs", "Select right hand side of an assignment")

		-- works for javascript/typescript files (custom capture in after/queries/ecma/textobjects.scm)
		map("a:", "@property.outer", "Select outer part of an object property")
		map("i:", "@property.inner", "Select inner part of an object property")
		map("l:", "@property.lhs", "Select left part of an object property")
		map("r:", "@property.rhs", "Select right part of an object property")

		map("ap", "@parameter.outer", "Select outer part of a parameter/argument")
		map("ip", "@parameter.inner", "Select inner part of a parameter/argument")

		map("ai", "@conditional.outer", "Select outer part of a conditional")
		map("ii", "@conditional.inner", "Select inner part of a conditional")

		map("al", "@loop.outer", "Select outer part of a loop")
		map("il", "@loop.inner", "Select inner part of a loop")

		map("af", "@call.outer", "Select outer part of a function call")
		map("if", "@call.inner", "Select inner part of a function call")

		map("am", "@function.outer", "Select outer part of a method/function definition")
		map("im", "@function.inner", "Select inner part of a method/function definition")

		map("ac", "@class.outer", "Select outer part of a class")
		map("ic", "@class.inner", "Select inner part of a class")
	end,
}
