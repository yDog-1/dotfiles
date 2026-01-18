require("plugins.which-key.spec").add({
	mode = "n",
	{ "<c-t>", group = "tab" },
})

vim.keymap.set("n", "<c-t>n", "<cmd>tabnew<cr>", { desc = "new tab" })
vim.keymap.set("n", "<c-t>q", "<cmd>tabclose<cr>", { desc = "close tab" })
vim.keymap.set("n", "<c-t>o", "<cmd>tabonly<cr>", { desc = "close other tabs" })
vim.keymap.set("n", "<c-t>l", "<cmd>tabnext<cr>", { desc = "next tab" })
vim.keymap.set("n", "<c-t><c-t>", "<cmd>tabnext<cr>", { desc = "next tab" })
vim.keymap.set("n", "<c-t>h", "<cmd>tabprevious<cr>", { desc = "previous tab" })

return {
	{
		-- tabごとにbufferを表示してくれる
		"tiagovla/scope.nvim",
		lazy = false,
		opts = {},
	},
}
