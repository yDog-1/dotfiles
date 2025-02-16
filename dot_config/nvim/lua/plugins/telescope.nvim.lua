require("plugins.which-key.spec").add({
	mode = "n",
	{ "<Leader>f", group = "find" },
})

return {
	{
		"nvim-telescope/telescope.nvim",
		lazy = true,
		version = "^0.1.8",
		keys = {
			-- ファイル検索
			{ "<Leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
			-- グレップ検索
			{ "<Leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
			-- バッファリスト
			{ "<Leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
			-- ヘルプタグ
			{ "<Leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
		},
		dependencies = {
			-- `vim.ui.select`を telescope で開く
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			local telescope = require("telescope")

			local actions = require("telescope.actions")
			local default_mappings = {
				n = {
					["q"] = actions.close,
				},
			}
			telescope.setup({
				defaults = {
					mappings = default_mappings,
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			telescope.load_extension("ui-select")
		end,
	},
}
