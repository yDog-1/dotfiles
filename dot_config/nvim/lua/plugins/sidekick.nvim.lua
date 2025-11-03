local default_tool = {
	name = "codex",
	focus = true,
}

local user_sidekick_autocmd = vim.api.nvim_create_augroup("UserSidekick", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = user_sidekick_autocmd,
	pattern = "sidekick_terminal",
	callback = function()
		vim.keymap.set({ "n", "t" }, "<c-q>", "<cmd>wincmd q<cr>", { buffer = true, desc = "Close window" })
	end,
})

return {
	"folke/sidekick.nvim",
  event = "BufReadPost",
	opts = {
	},
	keys = {
		{
			"<tab>",
			function()
				if not require("sidekick").nes_jump_or_apply() then
					return "<Tab>" -- fallback to normal tab
				end
			end,
			expr = true,
			desc = "Goto/Apply Next Edit Suggestion",
		},
	},
}
