return {
	"kkoomen/vim-doge",
	lazy = false,
	build = function()
		vim.cmd("silent call doge#install()")
	end,
	init = function()
		vim.g.doge_enable_mappings = 0
	end,
	config = function()
		vim.keymap.set("n", "<leader>cm", "<cmd>DogeGenerate<CR>", { desc = "Generate Documentation" })
	end,
}
