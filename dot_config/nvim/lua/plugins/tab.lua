require("plugins.which-key.spec").add({
	mode = "n",
	{ "<Leader>b", group = "buffer" },
})
require("plugins.which-key.spec").add({
	mode = "n",
	{ "<c-p>", group = "tab" },
})

vim.keymap.set("n", "<c-p>n", "<cmd>tabnew<cr>", { desc = "new tab" })
vim.keymap.set("n", "<c-p>d", "<cmd>tabclose<cr>", { desc = "close tab" })
vim.keymap.set("n", "<c-p>o", "<cmd>tabonly<cr>", { desc = "close other tabs" })
vim.keymap.set("n", "<c-p>p", "<cmd>tabnext<cr>", { desc = "next tab" })
vim.keymap.set("n", "<c-p><c-p>", "<cmd>tabprevious<cr>", { desc = "previous tab" })

return {
	{
		"akinsho/bufferline.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		lazy = false,
		keys = {
			{ "L", "<cmd>BufferLineCycleNext<cr>", desc = "next buffer" },
			{ "H", "<cmd>BufferLineCyclePrev<cr>", desc = "previous buffer" },
			{ "<leader>p", "<cmd>BufferLinePick<cr>", desc = "pick buffer" },
			{ "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "close other buffers" },
			{ "<leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>", desc = "open buffer 1" },
			{ "<leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>", desc = "open buffer 2" },
			{ "<leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>", desc = "open buffer 3" },
			{ "<leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>", desc = "open buffer 4" },
			{ "<leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>", desc = "open buffer 5" },
			{ "<leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>", desc = "open buffer 6" },
			{ "<leader>7", "<Cmd>BufferLineGoToBuffer 7<CR>", desc = "open buffer 7" },
			{ "<leader>8", "<Cmd>BufferLineGoToBuffer 8<CR>", desc = "open buffer 8" },
			{ "<leader>9", "<Cmd>BufferLineGoToBuffer 9<CR>", desc = "open buffer 9" },
			{ "<leader>$", "<Cmd>BufferLineGoToBuffer -1<CR>", desc = "open last buffer" },
			{ "<c-p>r", ":BufferLineTabRename ", desc = "rename tab" },
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
					pick = {
						alphabet = "asdfjklcvnmewqiop",
					},
				},
			})
		end,
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
