local recording_status = function()
	local reg = vim.fn.reg_recording()
	if reg ~= "" then
		return "Recording @" .. reg
	else
		return ""
	end
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-mini/mini.icons",
	},
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status")
		lualine.setup({
			sections = {
				lualine_a = { "mode", recording_status },
				lualine_c = {
					{ "filename", path = 1 },
				},
				lualine_x = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
					},
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					{ "encoding" },
					{ "fileformat", symbols = { unix = "" } },
					{ "filetype" },
				},
			},
		})
	end,
}
