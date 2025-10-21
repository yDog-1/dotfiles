return {
	-- 日本語ドキュメント
	{
		"vim-jp/vimdoc-ja",
		event = "VeryLazy",
	},
	{
		"vim-skk/skkeleton",
		dependencies = {
			"vim-denops/denops.vim",
		},
		keys = {
			-- <C-j>, <C-k>でskkeletonの切り替え
			{ "<C-j>", "<Plug>(skkeleton-enable)", mode = { "i", "c", "t" } },
			{ "<C-k>", "<Plug>(skkeleton-disable)", mode = { "i", "c", "t" } },
		},
		lazy = false,
		event = { "InsertEnter", "CmdlineEnter" },
		config = function()
			local skk_dict_path = os.getenv("SKK_DICT_PATH")
			local skk_dict_paths = os.getenv("SKK_DICT_PATHS")

			-- 文字列分割関数
			local function split_string(str, delimiter)
				local result = {}
				if str == nil or str == "" then
					return result
				end
				for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
					if match ~= "" then
						table.insert(result, match)
					end
				end
				return result
			end

			local skk_dicts = split_string(skk_dict_paths, ",")

			local skk_database_path = vim.fn.expand((os.getenv("XDG_STATE_HOME") or "~/.local/state") .. "/skk/deno_kv")

			-- skk_database_pathのディレクトリを自動作成
			local function ensure_directory(path)
				local dir = vim.fn.fnamemodify(path, ":h")
				if vim.fn.isdirectory(dir) == 0 then
					local success = vim.fn.mkdir(dir, "p")
					if success == 0 then
						vim.notify("Failed to create directory: " .. dir, vim.log.levels.ERROR)
						return false
					end
				end
				return true
			end

			if not ensure_directory(skk_database_path) then
				return
			end

			vim.fn["skkeleton#config"]({
        completionRankFile = skk_dict_path .. "/rank.json",
				globalDictionaries = skk_dicts,
				userDictionary = skk_dict_path .. "/SKK-JISYO.user",
				-- 候補選択メニューが出るまでの数
				showCandidatesCount = 2,
				-- Denoのインメモリキャッシュで高速化
				databasePath = skk_database_path,
				sources = { "deno_kv", "skk_dictionary" },
				-- キャンセルの挙動
				immediatelyCancel = false,
				-- 変換中の文字に空白を追加し、'ambiwidth' singleでも文字に重ならないようにする
				markerHenkan = "▽",
				markerHenkanSelect = "▼",
			})

			vim.fn["skkeleton#register_keymap"]("henkan", "<CR>", "kakutei")
			vim.fn["skkeleton#register_kanatable"]("rom", {
				jj = "escape",
			})

			-- Deno KVのデータベースを更新
			vim.fn["skkeleton#update_database"](skk_database_path)

			require("denops-lazy").load("skkeleton", { wait_load = false })
		end,
	},
	-- skkeletonの入力中、右下にインジケータを表示
	{
		"delphinus/skkeleton_indicator.nvim",
		lazy = true,
		event = "User DenopsReady",
		branch = "v2",
		config = function()
			require("skkeleton_indicator").setup({
				zindex = 150,
			})
		end,
	},
	-- 日本語をローマ字で検索
	{
		"lambdalisue/vim-kensaku",
		dependencies = {
			"vim-denops/denops.vim",
		},
		lazy = true,
		config = function()
			require("denops-lazy").load("vim-kensaku", { wait_load = false })
		end,
	},
	-- 日本語対応モーション
	{
		"atusy/jab.nvim",
		dependencies = {
			"lambdalisue/vim-kensaku",
		},
		lazy = true,
		keys = {
			{
				";",
				function()
					return require("jab").jab_win()
				end,
				mode = { "n", "x", "o" },
				expr = true,
			},
			{
				"f",
				function()
					return require("jab").f()
				end,
				mode = { "n", "x", "o" },
				expr = true,
			},
			{
				"F",
				function()
					return require("jab").F()
				end,
				mode = { "n", "x", "o" },
				expr = true,
			},
			{
				"t",
				function()
					return require("jab").t()
				end,
				mode = { "n", "x", "o" },
				expr = true,
			},
			{
				"T",
				function()
					return require("jab").T()
				end,
				mode = { "n", "x", "o" },
				expr = true,
			},
		},
	},
	-- W, E モーションを日本語対応

	{
		"atusy/budouxify.nvim",
		dependencies = {
			"atusy/budoux.lua",
		},
		keys = {
			{
				"W",
				function()
					local pos = require("budouxify.motion").find_forward({ head = true })
					if pos then
						vim.api.nvim_win_set_cursor(0, { pos.row, pos.col })
					end
				end,
				mode = { "n", "v" },
			},
			{
				"E",
				function()
					local pos = require("budouxify.motion").find_forward({ head = false })
					if pos then
						vim.api.nvim_win_set_cursor(0, { pos.row, pos.col })
					end
				end,
				mode = { "n", "v" },
			},
		},
	},
}
