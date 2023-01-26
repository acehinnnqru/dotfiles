local config_path = vim.fn.stdpath("config") .. "/lua/"

local M = {}

local trim_slash = function(p)
    while string.sub(p, -1, -1) == "/" do
		p = string.sub(p, 1, -2)
	end

    while string.sub(p, 1, 1) == "/" do
		p = string.sub(p, 2, -1)
	end
    return p
end

function M.load_dir(path)
    path = trim_slash(path)

	local item_prefix = string.gsub(path, "/", ".") .. "."
	local dir_handle = vim.loop.fs_scandir(config_path .. path)
	local items = {}
	while true do
		local item, _ = vim.loop.fs_scandir_next(dir_handle)
		if not item then
			break
		end
		item = item:match("(.+)%..+")
		if not item then
			goto continue
		end
		if item:match("^%s*$") or item:match("init") then
			goto continue
		end
		table.insert(items, require(item_prefix .. item))

		::continue::
	end
    return items
end

return M
