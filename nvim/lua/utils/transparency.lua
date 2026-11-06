local M = {}

local state_file = vim.fn.expand("~/.config/shared-theme/transparent.txt")

local clear_groups = {
	"Normal",
	"NormalNC",
	"NormalFloat",
	"SignColumn",
	"EndOfBuffer",
	"StatusLine",
	"StatusLineNC",
	"TabLineFill",
	"WinBar",
	"WinBarNC",
}

function M.enabled()
	if vim.g.transparent_background ~= nil then
		return vim.g.transparent_background == true
	end
	if vim.fn.filereadable(state_file) ~= 1 then
		return false
	end
	return vim.trim(vim.fn.readfile(state_file)[1] or "") == "1"
end

function M.set(on)
	vim.g.transparent_background = on
	local dir = vim.fn.fnamemodify(state_file, ":h")
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p")
	end
	vim.fn.writefile({ on and "1" or "0" }, state_file)
end

function M.apply()
	if not M.enabled() then
		return
	end
	for _, group in ipairs(clear_groups) do
		vim.api.nvim_set_hl(0, group, { bg = "NONE" })
	end
end

return M
