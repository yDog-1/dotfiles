return {
	"lambdalisue/nvim-aibo",
	lazy = false,
	dependencies = {
		"https://github.com/Shougo/ddc.vim",
	},
	keys = {
		{
			"<leader>aa",
			function()
				vim.api.nvim_command("Aibo -opener=botright\\ vsplit -toggle codex resume")
			end,
			desc = "Aibo Codex",
		},
	},
	config = function()
		require("aibo").setup({
			disable_startinsert_on_insert = false,
			disable_startinsert_on_startup = true,
			prompt = {
				no_default_mappings = true,
				on_attach = function(bufnr)
					vim.o.hidden = true
					vim.api.nvim_create_autocmd("VimLeavePre", {
						group = vim.api.nvim_create_augroup("AiboClose", { clear = true }),
						buffer = bufnr,
						callback = function()
							vim.cmd("bwipeout! " .. bufnr)
						end,
					})

					vim.keymap.set("n", "q", "<cmd>q<cr><cmd>q<cr>", { buffer = bufnr, desc = "Close Aibo" })
					vim.keymap.set("n", "<C-q>", "<cmd>q<cr><cmd>bw!<cr>", { buffer = bufnr, desc = "Wipeout Aibo" })
					vim.keymap.set("n", "<C-c>", "<cmd>q<cr><cmd>bw!<cr>", { buffer = bufnr, desc = "Wipeout Aibo" })
					vim.keymap.set(
						{ "n", "i" },
						"<C-i>",
						"<plug>(aibo-submit)<esc><cmd>wincmd k<cr>",
						{ buffer = bufnr, desc = "Submit prompt" }
					)
					vim.keymap.set("n", "K", "<plug>(aibo-send)<up>", { buffer = bufnr, desc = "Up arrow" })
					vim.keymap.set("n", "J", "<plug>(aibo-send)<down>", { buffer = bufnr, desc = "Down arrow" })
					vim.keymap.set("n", "<Enter>", "<plug>(aibo-send)<Enter>", { buffer = bufnr, desc = "Enter" })
					vim.keymap.set("n", "<Esc>", "<plug>(aibo-send)<Esc>", { buffer = bufnr, desc = "Escape" })

          -- for ddc.vim
          vim.fn["ddc#custom#patch_buffer"]("specialBufferCompletion", true)
				end,
			},
			console = {
				no_default_mappings = true,
				on_attach = function(bufnr)
					vim.api.nvim_create_autocmd("VimLeavePre", {
						group = vim.api.nvim_create_augroup("AiboClose", { clear = true }),
						buffer = bufnr,
						callback = function()
							vim.cmd("bwipeout! " .. bufnr)
						end,
					})

					vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = bufnr, desc = "Close Aibo console" })
					vim.keymap.set("n", "<C-c>", "<cmd>bw!<cr>", { buffer = bufnr, desc = "Wipeout Aibo console" })
					vim.keymap.set("n", "<C-q>", "<cmd>bw!<cr>", { buffer = bufnr, desc = "Wipeout Aibo console" })
					vim.keymap.set("n", "K", "<plug>(aibo-send)<up>", { buffer = bufnr, desc = "Up arrow" })
					vim.keymap.set("n", "J", "<plug>(aibo-send)<down>", { buffer = bufnr, desc = "Down arrow" })
					vim.keymap.set("n", "<Enter>", "<plug>(aibo-send)<Enter>", { buffer = bufnr, desc = "Enter" })
					vim.keymap.set("n", "<Esc>", "<plug>(aibo-send)<Esc>", { buffer = bufnr, desc = "Escape" })
				end,
			},
		})
	end,
}
