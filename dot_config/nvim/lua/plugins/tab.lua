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
		-- tabごとにbufferを表示してくれる
		"tiagovla/scope.nvim",
		lazy = false,
		opts = {},
	},
}
