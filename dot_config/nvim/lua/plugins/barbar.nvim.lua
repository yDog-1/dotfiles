require("plugins.which-key.spec").add({
	mode = "n",
	{ "<Leader>b", group = "buffer" },
})

return {
	"romgrk/barbar.nvim",
	dependencies = {
		"lewis6991/gitsigns.nvim",
	},
	version = "^1.0.0",
	init = function()
		vim.g.barbar_auto_setup = false
	end,
	event = "BufEnter",
	keys = {
		{ "H", ":BufferPrevious<CR>", desc = "switch prev tab", silent = true },
		{ "L", ":BufferNext<CR>", desc = "switch next tab", silent = true },
		{ "<Leader>b<", ":BufferMovePrevious<CR>", desc = "move tab left", silent = true },
		{ "<Leader>b>", ":BufferMoveNext<CR>", desc = "move tab right", silent = true },
		{ "<Leader>bp", ":BufferPin<CR>", desc = "pin tab", silent = true },
		{ "<Leader>bc", ":BufferClose<CR>", desc = "close tab", silent = true },
		{ "<Leader>bo", ":BufferCloseAllButCurrentOrPinned<CR>", desc = "close other tabs", silent = true },
	},
	opts = {
		animation = false,
		auto_hide = 1,
		clickable = false,
		icons = {
			button = false,
		},
	},
}
