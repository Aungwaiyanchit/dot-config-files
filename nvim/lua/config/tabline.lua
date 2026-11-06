--- Tabline labels.
--- An oil tab shows its directory (`~/foo`) with no icon.
--- Paths longer than 20 characters are cut from the left to `…` plus the last 17.
local M = {}

local function is_oil(bufnr)
	if vim.bo[bufnr].filetype == "oil" then
		return true
	end
	return vim.api.nvim_buf_get_name(bufnr):match("^oil.*://") ~= nil
end

--- Shorten a directory for an oil tab label.
---@param dir string
---@return string
function M.format_dir(dir)
	dir = vim.fn.fnamemodify(dir, ":~")
	dir = dir:gsub("/+$", "")
	if dir == "" then
		dir = "/"
	end
	if vim.fn.strchars(dir) > 20 then
		dir = "…" .. vim.fn.strcharpart(dir, vim.fn.strchars(dir) - 17, 17)
	end
	return dir
end

--- Oil tab label: directory only, never a file icon.
---@param bufnr integer
---@return string
function M.oil_label(bufnr)
	local dir
	local ok, oil = pcall(require, "oil")
	if ok then
		dir = oil.get_current_dir(bufnr)
	end
	if not dir or dir == "" then
		dir = vim.api.nvim_buf_get_name(bufnr):gsub("^oil.*://", "")
	end
	return M.format_dir(dir)
end

---@param bufnr integer
---@return string
function M.label(bufnr)
	if is_oil(bufnr) then
		return M.oil_label(bufnr)
	end

	local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
	if name == "" then
		name = "[No Name]"
	end
	if vim.bo[bufnr].modified then
		name = name .. " +"
	end
	return name
end

local function escape(text)
	return (text:gsub("%%", "%%%%"))
end

function M.render()
	local ok, line = pcall(function()
		local parts = {}
		local current = vim.fn.tabpagenr()
		for i = 1, vim.fn.tabpagenr("$") do
			local hl = i == current and "%#TabLineSel#" or "%#TabLine#"
			local buflist = vim.fn.tabpagebuflist(i)
			local winnr = vim.fn.tabpagewinnr(i)
			local bufnr = buflist and buflist[winnr]
			local label = bufnr and escape(M.label(bufnr)) or "[No Name]"
			parts[#parts + 1] = hl .. "%" .. i .. "T " .. i .. " " .. label .. " %T"
		end
		parts[#parts + 1] = "%#TabLineFill#"
		return table.concat(parts)
	end)
	if not ok then
		return "%#TabLineFill#"
	end
	return line
end

vim.o.tabline = "%!v:lua.require('config.tabline').render()"

return M
