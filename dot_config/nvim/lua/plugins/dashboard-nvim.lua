return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{ "<leader>.", "<cmd>Dashboard<CR>", desc = "Dashboard" },
	},
	opts = {
		theme = "hyper",
		config = {
			week_header = {
				enable = true,
			},
			shortcut = {
					{
						icon = " ",
						desc = "Find File",
						group = "DiagnosticInfo",
						action = "Telescope smart_open",
						key = "f",
					},
					{
						icon = " ",
						desc = "New File",
						group = "String",
						action = "ene | startinsert",
						key = "n",
					},
					{
						icon = " ",
						desc = "Live Grep",
						group = "DiagnosticWarn",
						action = "Telescope live_grep",
						key = "g",
					},
					{
						icon = " ",
						desc = "Recent Files",
						group = "Comment",
						action = "Telescope oldfiles",
						key = "r",
					},
					{
						icon = "󰒲 ",
						desc = "Lazy",
						group = "DiagnosticHint",
						action = "Lazy",
						key = "L",
					},
					{
						icon = " ",
						desc = "Browse Repo",
						group = "Function",
						action = "GinBrowse ++repository",
						key = "x",
					},
					{
						icon = " ",
						desc = "Git Status",
						group = "DiagnosticInfo",
						action = "GinStatus",
						key = "s",
					},
					{
						icon = " ",
						desc = "Quit",
						group = "DiagnosticError",
						action = "qa",
						key = "q",
					},
			},
			project = {
				enable = true,
				limit = 5,
				icon = " ",
				label = "Projects",
				action = "Telescope find_files cwd=",
			},
			mru = {
				enable = true,
				limit = 10,
				icon = " ",
				label = "Recent Files",
			},
		},
	},
}
