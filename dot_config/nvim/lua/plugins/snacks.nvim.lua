return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = {
		{ "<leader>.", "<cmd>lua Snacks.dashboard()<CR>", desc = "Dashboard" },
		{ "<leader>gB", "<cmd>lua Snacks.gitbrowse()<CR>", desc = "Browse git repository" },
		{ "<leader>fr", "<cmd>lua Snacks.dashboard.pick('oldfiles')<CR>", desc = "Recent files" },
	},
	opts = {
		dashboard = {
			enabled = true,
			sections = {
				{ section = "header" },
				{
					{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{
						icon = " ",
						key = "g",
						desc = "Find Text",
						action = ":lua Snacks.dashboard.pick('live_grep')",
					},
					{
						icon = " ",
						key = "r",
						desc = "Recent Files",
						action = ":lua Snacks.dashboard.pick('oldfiles')",
					},
					{
						icon = " ",
						key = "c",
						desc = "Config",
						action = function()
							require("telescope").extensions.chezmoi.find_files()
							vim.cmd("cd" .. vim.g.chezmoidir)
						end,
					},
					{ icon = " ", key = "s", desc = "Session", action = ":Autosession search" },
					{ icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
				{
					pane = 2,
					icon = " ",
					desc = "Browse Repo",
					padding = 1,
					key = "b",
					action = function()
						---@diagnostic disable-next-line: undefined-global
						Snacks.gitbrowse()
					end,
				},
				{ pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
				{ pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
				{
					pane = 2,
					icon = " ",
					title = "Git Status",
					section = "terminal",
					enabled = function()
						---@diagnostic disable-next-line: undefined-global
						return Snacks.git.get_root() ~= nil
					end,
					cmd = "git status --short --branch --renames",
					height = 5,
					padding = 1,
					ttl = 5 * 60,
					indent = 3,
				},
				{ section = "startup" },
			},
		},
	},
}
