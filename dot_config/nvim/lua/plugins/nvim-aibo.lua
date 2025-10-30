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
		---@diagnostic disable-next-line: redundant-parameter
		require("aibo").setup({
			disable_startinsert_on_insert = false,
			disable_startinsert_on_startup = true,
			prompt = {
				on_attach = function(bufnr)
					vim.o.hidden = true
					vim.api.nvim_create_autocmd("VimLeavePre", {
						group = vim.api.nvim_create_augroup("AiboClose", { clear = true }),
						buffer = bufnr,
						callback = function()
							vim.cmd("bwipeout! " .. bufnr)
						end,
					})

					-- for ddc.vim
					vim.fn["ddc#custom#patch_buffer"]("specialBufferCompletion", true)
				end,
			},
			console = {
				on_attach = function(bufnr)
					vim.api.nvim_create_autocmd("VimLeavePre", {
						group = vim.api.nvim_create_augroup("AiboClose", { clear = true }),
						buffer = bufnr,
						callback = function()
							vim.o.hidden = true
							vim.cmd("bwipeout! " .. bufnr)
						end,
					})
				end,
			},
		})
	end,
}
