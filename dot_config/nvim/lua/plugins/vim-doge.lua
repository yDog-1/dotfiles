return {
	"kkoomen/vim-doge",
	lazy = false,
	init = function()
		vim.g.doge_enable_mappings = 0
	end,
	config = function()
		vim.cmd("silent call doge#install()")
		vim.keymap.set("n", "<leader>cm", "<cmd>DogeGenerate<CR>", { desc = "Generate Documentation" })
	end,
}
