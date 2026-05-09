return {
	{
		"vim-denops/denops.vim",
		lazy = false,
		init = function()
			vim.g["denops#server#deno_args"] = {
				"-q",
				"--no-lock",
				"-A",
				"--unstable-kv",
			}
		end,
		build = function()
			vim.fn["denops_shared_server#install"]()
		end,
		config = function()
			vim.api.nvim_create_user_command("DenopsFixCache", function()
				vim.fn["denops#cache#update"]({ reload = true })
			end, { desc = "Fix Denops cache" })
		end,
	},
	{
		"yuki-yano/denops-lazy.nvim",
		opts = {},
	},
}
