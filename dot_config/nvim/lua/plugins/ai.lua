for _, spec in ipairs({
	{ "AI", "<Leader>a", "󰧑 ", "red" },
	{ "Aider", "<Leader>a", "󰧑 ", "red" },
}) do
	require("plugins.which-key.spec").add({
		mode = { "n", "v" },
		{ spec[2], group = spec[1], icon = { icon = spec[3], color = spec[4] } },
	})
end

return {
	{
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
		},
		-- comment the following line to ensure hub will be ready at the earliest
		event = "BufEnter",
		cmd = "MCPHub", -- lazy load by default
		build = "bundled_build.lua",
		-- uncomment this if you don't want mcp-hub to be available globally or can't use -g
		-- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
		config = function()
			require("mcphub").setup({
				use_bundled_binary = true,
				auto_approve = false,
				extensions = {
					avante = {},
					codecompanion = {
						show_result_in_chat = true, -- Show tool results in chat
						make_vars = true, -- Create chat variables from resources
						make_slash_commands = true, -- make /slash_commands from MCP server prompts
					},
				},
			})
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
					sh = function()
						if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "%.env") then
							-- disable for .env files
							return false
						end
						return true
					end,
				},
				suggestion = {
					auto_trigger = true,
				},
			})
		end,
	},
	{
		"nekowasabi/aider.vim",
		dependencies = "vim-denops/denops.vim",
		keys = {
			{ "<leader>ao", "<cmd>AiderRun<CR>", desc = "Run" },
			{ "<leader>aa", "<cmd>AiderAddCurrentFile<CR>", desc = "Add current file" },
			{ "<leader>ar", "<cmd>AiderAddCurrentFileReadOnly<CR>", desc = "Add current file as read-only" },
			{
				"<leader>aw",
				function()
					local register_content = vim.fn.getreg("+")
					vim.cmd("AiderAddWeb " .. register_content)
				end,
				desc = "Add web reference from clipboard",
			},
			{ "<leader>ax", "<cmd>AiderExit<CR>", desc = "Exit" },
			{ "<leader>ai", "<cmd>AiderAddIgnoreCurrentFile<CR>", desc = "Add current file to ignore" },
			{ "<leader>aI", "<cmd>AiderOpenIgnore<CR>", desc = "Open ignore settings" },
			{ "<leader>ap", "<cmd>AiderPaste<CR>", desc = "Paste from clipboard into Aider" },
			{
				"<leader>ap",
				"<cmd>AiderVisualTextWithPrompt<CR>",
				mode = "v",
				desc = "Send prompt to Aider",
			},
			{
				"<leader>aa",
				"<cmd>AiderAddPartialReadonlyContext<CR>",
				mode = "v",
				desc = "Add selected text to Aider",
			},
		},
		config = function()
			-- Gitルートディレクトリで、Aiderを実行する
			vim.g.aider_command = "cd $(git rev-parse --show-toplevel) && aider --watch-files"
			vim.g.aider_buffer_open_type = "floating"
			vim.g.aider_floatwin_width = 200
			vim.g.aider_floatwin_height = 40

			vim.api.nvim_create_autocmd("User", {
				pattern = "AiderOpen",
				callback = function(args)
					local set = vim.keymap.set
					set("t", "<Esc>", "<C-\\><C-n>", { buffer = args.buf })
					set("t", "jj", "<Esc>", { buffer = args.buf })
					set("n", "q", "<cmd>AiderHide<CR>", { buffer = args.buf })

					-- バッファ名をaiderに変更
					-- プラグインは、`aider `と空白より左側に`aider`と付くかどうかで判定している。
					vim.cmd("file aider ")

					local optl = vim.opt_local
					optl.number = false
					optl.relativenumber = false
					optl.buflisted = false
					optl.filetype = "aider"
				end,
			})
			require("denops-lazy").load("aider.vim", { wait_load = true })
		end,
	},
}
