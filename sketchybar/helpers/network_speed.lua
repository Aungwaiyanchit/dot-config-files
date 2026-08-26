-- ~/.config/sketchybar/helpers/network_speed.lua

local M = {}

local interface = "en0"

local last_rx = nil
local last_tx = nil
local last_time = nil

local function format_speed(bytes_per_second)
	if bytes_per_second >= 1024 * 1024 then
		return string.format("%.1f MB/s", bytes_per_second / 1024 / 1024)
	elseif bytes_per_second >= 1024 then
		return string.format("%.0f KB/s", bytes_per_second / 1024)
	else
		return string.format("%.0f B/s", bytes_per_second)
	end
end

function M.get(callback)
	local command = string.format(
		"netstat -ib | awk '$1==\"%s\" {print $7, $10; exit}'",
		interface
	)

	local handle = io.popen(command)

	if not handle then
		callback("0 B/s", "0 B/s")
		return
	end

	local result = handle:read("*a")
	handle:close()

	local rx, tx = result:match("(%d+)%s+(%d+)")

	rx = tonumber(rx)
	tx = tonumber(tx)

	if not rx or not tx then
		callback("0 B/s", "0 B/s")
		return
	end

	local now = os.time()

	if last_rx == nil then
		last_rx = rx
		last_tx = tx
		last_time = now

		callback("0 B/s", "0 B/s")
		return
	end

	local elapsed = now - last_time

	if elapsed <= 0 then
		callback("0 B/s", "0 B/s")
		return
	end

	local download = math.max(
		(rx - last_rx) / elapsed,
		0
	)

	local upload = math.max(
		(tx - last_tx) / elapsed,
		0
	)

	last_rx = rx
	last_tx = tx
	last_time = now

	callback(
		format_speed(download),
		format_speed(upload)
	)
end

function M.set_interface(name)
	interface = name
end

return M
