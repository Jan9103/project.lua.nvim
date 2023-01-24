-- luacheck: globals vim

local utils = require('project-lua.utils')

local M = {config = {}}

function M.setup(defaults)
	M.config = defaults or {}
	local config_file = utils.get_config_file()
	if config_file then
		M.config = utils.merge_tables(M.config, utils.sandbox_run_lua(config_file))
	end
end

return M
