-- luacheck: globals vim

local path_separator = vim.loop.os_uname().version:match("Windows") and "\\" or "/"

local M = {}

-- merge 2 tables into 1 (with the second one beeing the dominant one)
function M.merge_tables(a, b)
	for k,v in pairs(b) do
		-- we only want to merge string-key based tables
		-- if a[k] is empty we can just copy to speed it up
		if type(k) == "string" and type(v) == "table" and a[k] then
			a[k] = M.merge_tables(a[k], v)
		else a[k] = v end
	end
	return a
end

-- get path to the config file (or nil)
function M.get_config_file()
	local cwd = vim.api.nvim_buf_get_name(0)
	for i in vim.fs.parents(cwd) do
		-- add `/.project.lua` to the path
		local cfg = (i .. path_separator .. '.project.lua'):gsub(path_separator .. "+", path_separator)
		-- check if file exists
		if vim.loop.fs_stat(cfg) then return cfg end
	end
end

-- get the result of a lua-file, which is executed without access to `require`, `vim`, etc
-- http://lua-users.org/wiki/DofileNamespaceProposal
function M.sandbox_run_lua(file)
	local env = {}
	local f, e = loadfile(file)
	if not f then error(e, 2) end
	setfenv(f, env)
	return f()
end

return M
