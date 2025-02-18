return {
	{
		-- ファイルブラウザ
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		keys = {
			-- ネオツリーを開く
			{ "<Leader>e", ":Neotree filesystem reveal left<CR>", desc = "Open neotree" },
		},
		cmd = "Neotree",
		opts = function(_, opts)
			local events = require("neo-tree.events")
			opts.event_handlers = opts.event_handlers or {}

			-- ファイルの移動時に呼び出し元のリネーム処理を行う
			local function on_move(data)
				---@diagnostic disable-next-line: undefined-global
				require("snacks.rename").on_rename_file(data.source, data.destination)
			end
			vim.list_extend(opts.event_handlers, {
				{ event = events.FILE_MOVED, handler = on_move },
				{ event = events.FILE_RENAMED, handler = on_move },
			})

			opts.filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_hidden = false,
				},
		end,
	},
}
