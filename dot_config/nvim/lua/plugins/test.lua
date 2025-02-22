---@diagnostic disable: missing-fields
require("plugins.which-key.spec").add({
	mode = "n",
	{ "<Leader>t", group = "test", icon = { icon = " ", color = "cyan" } },
})

return {

	-- Neotest setup
	{
		"nvim-neotest/neotest",
		event = "VeryLazy",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			{
				"marilari88/neotest-vitest",
				branch = "main",
			},
			{
				"fredrikaverpil/neotest-golang",
				branch = "main",
			},
		},
		opts = {
			adapters = {
				["neotest-vitest"] = {},
				["neotest-golang"] = {
					go_test_args = {
						"-v",
						"-race",
					},
				},
			},
			output = { open_on_run = true },
			status = { virtual_text = true },
			summary = { open = "topleft vsplit | vertical resize 50" },
		},
		config = function(_, opts)
			-- adapters が設定されている場合は、その設定を読み込む
			if opts.adapters then
				local adapters = {}
				for name, config in pairs(opts.adapters or {}) do
					if type(name) == "number" then
						if type(config) == "string" then
							config = require(config)
						end
						adapters[#adapters + 1] = config
					elseif config ~= false then
						local adapter = require(name)
						if type(config) == "table" and not vim.tbl_isempty(config) then
							local meta = getmetatable(adapter)
							if adapter.setup then
								adapter.setup(config)
							elseif adapter.adapter then
								adapter.adapter(config)
								adapter = adapter.adapter
							elseif meta and meta.__call then
								adapter(config)
							else
								error("Adapter " .. name .. " does not support setup")
							end
						end
						adapters[#adapters + 1] = adapter
					end
				end
				opts.adapters = adapters
			end

			require("neotest").setup(opts)
		end,
		keys = {
			{
				"<leader>ta",
				function()
					require("neotest").run.attach()
				end,
				desc = "attach",
			},
			{
				"<leader>tf",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "run file",
			},
			{
				"<leader>tA",
				function()
					---@diagnostic disable-next-line: undefined-field
					require("neotest").run.run(vim.uv.cwd())
				end,
				desc = "all files",
			},
			{
				"<leader>tS",
				function()
					require("neotest").run.run({ suite = true })
				end,
				desc = "suite",
			},
			{
				"<leader>tn",
				function()
					require("neotest").run.run()
				end,
				desc = "nearest",
			},
			{
				"<leader>tl",
				function()
					require("neotest").run.run_last()
				end,
				desc = "last",
			},
			{
				"<leader>ts",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "summary",
			},
			{
				"<leader>to",
				function()
					require("neotest").output.open({ enter = true, auto_close = true })
				end,
				desc = "output",
			},
			{
				"<leader>tO",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "output panel",
			},
			{
				"<leader>tt",
				function()
					require("neotest").run.stop()
				end,
				desc = "terminate",
			},
		},
	},
}
