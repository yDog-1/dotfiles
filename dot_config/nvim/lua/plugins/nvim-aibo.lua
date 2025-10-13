return {
	"lambdalisue/nvim-aibo",
	lazy = false,
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
				on_attach = function(bufnr)
          vim.o.hidden = true
					vim.api.nvim_create_autocmd("VimLeavePre", {
						group = vim.api.nvim_create_augroup("AiboClose", { clear = true }),
						buffer = bufnr,
						callback = function()
							vim.cmd("bwipeout! " .. bufnr)
						end,
					})
				end,
			},
      console = {
        on_attach = function(bufnr)
          vim.api.nvim_create_autocmd("VimLeavePre", {
            group = vim.api.nvim_create_augroup("AiboClose", { clear = true }),
            buffer = bufnr,
            callback = function()
              vim.cmd("bwipeout! " .. bufnr)
            end,
          })
        end,
      }
		})
	end,
}
