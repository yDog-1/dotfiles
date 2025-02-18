return {
	{
		-- ファイルブラウザ
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		keys = {
			-- ネオツリーを開く
			{ "<Leader>e", "<cmd>Neotree filesystem reveal_force_cwd left<CR>", desc = "Open Neo-tree" },
			{ "<Leader>E", "<cmd>Neotree filesystem reveal_force_cwd float<CR>", desc = "Open float Neo-tree" },
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

			-- オープン時に Neo-tree を自動で閉じる
			vim.list_extend(opts.event_handlers, {
				{
					event = events.FILE_OPEN_REQUESTED,
					handler = function()
						require("neo-tree.command").execute({ action = "close" })
					end,
				},
			})

			opts.filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_hidden = false,
				},
			}

			opts.window = {
				mappings = {
					["P"] = {
						"toggle_preview",
						config = {
							use_float = true,
						},
					},
				},
			}
		end,
	},
}
