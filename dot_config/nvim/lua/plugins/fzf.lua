return {
	"junegunn/fzf",
	lazy = true,
	event = "VeryLazy",
	build = vim.fn["fzf#install"],
}
