local augroup = vim.api.nvim_create_augroup("ydog.colorscheme", { clear = true })

local post_colorscheme = function()
	-- TerminalとFloating Windowの背景色を不透明にする
	vim.api.nvim_clear_autocmds({ group = augroup })
	local terminal_bg = "#000000"
	local highlight_sets = {
		terminal = {
			prefix = "YDogTermOpaque",
			bases = {
				"Normal",
				"NormalNC",
				"SignColumn",
				"FoldColumn",
				"EndOfBuffer",
			},
			resolve_bg = function()
				return { bg = terminal_bg, ctermbg = 0 }
			end,
		},
		float = {
			prefix = "YDogFloatOpaque",
			bases = {
				"Normal",
				"NormalNC",
				"NormalFloat",
				"FloatBorder",
				"SignColumn",
				"FoldColumn",
				"EndOfBuffer",
			},
			-- フローティングウィンドウの背景色はPMenuから取得
			resolve_bg = function()
				local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = "PMenu", link = false })
				if ok then
					return {
						bg = hl.bg or terminal_bg,
						ctermbg = hl.ctermbg or 0,
					}
				end
				return { bg = terminal_bg, ctermbg = 0 }
			end,
		},
		float_terminal = {
			prefix = "YDogFloatTermOpaque",
			bases = {
				"Normal",
				"NormalNC",
				"NormalFloat",
				"FloatBorder",
				"SignColumn",
				"FoldColumn",
				"EndOfBuffer",
			},
			resolve_bg = function()
				return { bg = terminal_bg, ctermbg = 0 }
			end,
		},
	}

	local targets = {}
	for kind, set in pairs(highlight_sets) do
		targets[kind] = {}
		for _, base in ipairs(set.bases) do
			table.insert(targets[kind], { base = base, opaque = set.prefix .. base })
		end
	end

	-- 現在の配色をもとに不透明ハイライト群を生成
	local function sync_highlights()
		for kind, set in pairs(highlight_sets) do
			local bg_spec = set.resolve_bg()
			for _, def in ipairs(targets[kind]) do
				local definition = {}
				local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = def.base, link = false })
				if ok then
					---@diagnostic disable-next-line: assign-type-mismatch
					definition = hl
				end
				---@diagnostic disable-next-line: param-type-mismatch
				local merged = vim.tbl_extend("force", definition, bg_spec)
				if merged.ctermbg == nil then
					merged.ctermbg = 0
				end
				---@diagnostic disable-next-line: param-type-mismatch
				vim.api.nvim_set_hl(0, def.opaque, merged)
			end
		end
	end

	local is_setting_winhl = false

	-- 対象ウィンドウの winhighlight を不透明版に差し替え
	local function apply_winhighlight(winid)
		local cfg = vim.api.nvim_win_get_config(winid)
		local bufnr = vim.api.nvim_win_get_buf(winid)
		local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
		local target_kind
		---@diagnostic disable-next-line: unnecessary-if
		if cfg.relative ~= "" then
			if buftype == "terminal" then
				target_kind = "float_terminal"
			else
				target_kind = "float"
			end
		elseif buftype == "terminal" then
			target_kind = "terminal"
		else
			target_kind = nil
		end
		---@diagnostic disable-next-line: unnecessary-if
		-- is this window floating or terminal?
		if not target_kind then
			return
		end

		local current = vim.api.nvim_get_option_value("winhighlight", { win = winid }) or ""
		local order, map = {}, {}
		if current ~= "" then
			-- iterate existing winhighlight entries with `gmatch``
			for entry in current:gmatch("[^,]+") do
				local src, dst = entry:match("([^:]+):([^:]+)")
				if src and dst then
					if not map[src] then
						table.insert(order, src)
					end
					map[src] = dst
				end
			end
		end

		for _, def in ipairs(targets[target_kind]) do
			if not map[def.base] then
				table.insert(order, def.base)
			end
			map[def.base] = def.opaque
		end

		local assignments = {}
		for _, src in ipairs(order) do
			table.insert(assignments, string.format("%s:%s", src, map[src]))
		end
		is_setting_winhl = true
		vim.api.nvim_set_option_value("winhighlight", table.concat(assignments, ","), { win = winid })
		is_setting_winhl = false
	end

	-- すべてのウィンドウへ再適用
	local function refresh_all_windows()
		for _, winid in ipairs(vim.api.nvim_list_wins()) do
			apply_winhighlight(winid)
		end
	end

	sync_highlights()
	refresh_all_windows()

	-- 配色変更時に不透明定義と全ウィンドウを再適用
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = augroup,
		callback = function()
			sync_highlights()
			refresh_all_windows()
		end,
	})

	-- 新規/アクティブ化ウィンドウに即時反映
	vim.api.nvim_create_autocmd({ "WinEnter", "WinNew" }, {
		group = augroup,
		callback = function(ctx)
			apply_winhighlight(ctx.win or vim.api.nvim_get_current_win())
		end,
	})

	-- ターミナルバッファ生成時に反映
	vim.api.nvim_create_autocmd("TermOpen", {
		group = augroup,
		callback = function(ctx)
			local winid = vim.fn.bufwinid(ctx.buf)
			if winid ~= -1 then
				apply_winhighlight(winid)
			end
		end,
	})

	-- 他プラグインが winhighlight を書き換えた際に再適用
	vim.api.nvim_create_autocmd("OptionSet", {
		group = augroup,
		pattern = "winhighlight",
		callback = function(ctx)
			if is_setting_winhl then
				return
			end
			apply_winhighlight(ctx.win or vim.api.nvim_get_current_win())
		end,
	})
end

return {
	{
		-- カラースキーム
		"sainnhe/sonokai",
		lazy = false,
		priority = 1000,
		init = function()
			vim.g.sonokai_transparent_background = 1
		end,
		config = function()
			vim.cmd.colorscheme("sonokai")
			post_colorscheme()
		end,
	},
}
