---@diagnostic disable: duplicate-doc-field, duplicate-doc-alias
local M = {}

---@alias configs_kind
---| "formatters"
---| "linters"

---@class settings
---@field default boolean
---@field options? table<string, any>

---@class tool_config
---@field name string
---@field kind configs_kind
---@field settings settings

---@class setup_config
---@field filetypes table<string, tool_config[]>

---@param tool_config tool_config
local function apply_config(tool_config)
	local settings = {}
	if tool_config.settings.default then
		settings = require("efmls-configs." .. tool_config.kind .. "." .. tool_config.name)
	end
	local options = tool_config.settings.options or {}
	vim.tbl_extend("force", settings, options)
	return settings
end
require("efmls-configs.formatters.taplo")

---@param languages table<string, tool_config[]>
---@param tool_config tool_config
local function alt_js_config(languages, tool_config)
	local alts = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	}
	for _, alt in ipairs(alts) do
		languages[alt] = {}
		for i, tool in ipairs(tool_config) do
			languages[alt][i] = apply_config(tool)
		end
	end
end

---@param config setup_config
function M.setup(config)
	local languages = {}
	for filetype, tools in pairs(config.filetypes) do
		if filetype == "alt_js" then
			alt_js_config(languages, tools)
			goto continue
		end
		languages[filetype] = {}
		for i, tool in ipairs(tools) do
			languages[filetype][i] = apply_config(tool)
		end
		::continue::
	end

	local efmls_config = {
		filetypes = vim.tbl_keys(languages),
		settings = {
			rootMarkers = { ".git/" },
			languages = languages,
		},
		init_options = {
			documentFormatting = true,
			rangeFormatting = true,
			hover = true,
			documentSymbol = true,
			codeAction = true,
			completion = false,
		},
	}
	return efmls_config
end

return M
