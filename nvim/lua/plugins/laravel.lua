return {
	"adibhanna/laravel.nvim",
	-- dir = "~/Developer/opensource/laravel.nvim",
	ft = { "php", "blade" },
	dependencies = {
		"folke/snacks.nvim", -- Optional: for enhanced UI
	},
	config = function()
		require("laravel").setup({
			notifications = false,
			debug = false,
			keymaps = true,
		})

		local map = function(mode, key, fn)
			vim.keymap.set(mode, key, function()
				fn()
			end)
		end

		local navigate = require("laravel.navigate")

		map("n", "<leader>gc", navigate.goto_controller)
		map("n", "<leader>gm", navigate.goto_model)
		map("n", "<leader>gv", navigate.goto_view)
		map("n", "<leader>gr", navigate.goto_route_file)
		map("n", "<leader>sr", require("laravel.routes").show_routes)
		map("n", "<leader>mk", require("laravel.artisan").make_command)
		map("n", "<leader>sa", require("laravel.architecture").show_architecture_diagram)
	end,
}
