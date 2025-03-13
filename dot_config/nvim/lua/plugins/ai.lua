local function get_current_os()
	local os = {
		"mac",
		"linux",
		"unix",
		"sun",
		"bsd",
		"win32",
		"win64",
		"wsl",
	}
	for _, v in ipairs(os) do
		if vim.fn.has(v) == 1 then
			return v
		end
	end
end

local avante_build = (function()
	local os = get_current_os()
	if os == "win32" or os == "win64" then
		return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
	else
		return "make"
	end
end)()

return {
	{
		"yetone/avante.nvim",
		lazy = false,
		version = false,
		build = avante_build,
		dependencies = {
			"stevearc/dressing.nvim",
		},
		---@module "avante"
		---@type avante.Config
		opts = {
			provider = "copilot",
			copilot = {
				endpoint = "https://api.githubcopilot.com",
				model = "claude-3.7-sonnet",
				timeout = 30000,
				temperature = 0,
				max_tokens = 4096,
			},
			behaviour = {
				auto_suggestions = false,
			},
		},
	},
	{
		-- nvim-cmp source
		"zbirenbaum/copilot-cmp",
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		event = { "InsertEnter", "CmdlineEnter" },
		config = function()
			require("copilot").setup({
				filetypes = {
					yaml = true,
					markdown = true,
					gitcommit = true,
				},
				suggestion = { enabled = false },
				pannel = { enabled = false },
			})
		end,
	},
}
