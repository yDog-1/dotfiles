require("plugins.which-key.spec").add({
	mode = "n",
	{ "<Leader>b", group = "buffer" },
})

return {
	{
		"akinsho/bufferline.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		lazy = false,
		keys = {
			{ "L", "<cmd>BufferLineCycleNext<cr>", desc = "next buffer" },
			{ "H", "<cmd>BufferLineCyclePrev<cr>", desc = "previous buffer" },
			{ "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "close other buffers" },
		},
		config = function()
			local bufferline = require("bufferline")
			bufferline.setup({
				options = {
					mode = "buffers",
					style_preset = bufferline.style_preset.no_italic,
					numbers = "buffer_id",
					diagnostics = "nvim_lsp",
					diagnostics_indicator = function(count, level)
						local icon = level:match("error") and " " or " "
						return " " .. icon .. count
					end,
					offsets = {
						filetype = "oil",
					},
					hover = {
						enabled = false,
					},
					show_buffer_close_icons = false,
					separator_style = "thin",
					auto_toggle_bufferline = true,
	},
	{
		"moll/vim-bbye",
		lazy = false,
		keys = {
			{ "<leader>bd", "<cmd>Bdelete<cr>", desc = "delete buffer" },
		},
	},
	{
		-- tabごとにbufferを表示してくれる
		"tiagovla/scope.nvim",
		lazy = false,
		opts = {},
	},
}
