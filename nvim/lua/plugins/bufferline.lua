return {
	"akinsho/bufferline.nvim",
  enabled=false,
	version = "*",
	dependencies = "mini.icons",
	config = function()
		require("bufferline").setup({})
	end,
}
