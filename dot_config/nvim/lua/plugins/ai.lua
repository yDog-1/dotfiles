for _, spec in ipairs({
	{ "AI", "<Leader>a", "󰧑 ", "red" },
}) do
	require("plugins.which-key.spec").add({
		mode = { "n", "v" },
		{ spec[2], group = spec[1], icon = { icon = spec[3], color = spec[4] } },
	})
end

-- Utils for toggleterm handling
local function with_toggleterm(fn)
	local ok, terms = pcall(require, "toggleterm.terminal")
	if not ok then
		vim.notify("toggleterm not available", vim.log.levels.ERROR, { title = "opencode" })
		return
	end
	fn(terms)
end

local function find_opencode_term(terms, direction)
	local all_terms = terms.get_all and terms.get_all(true) or {}
	for _, term in pairs(all_terms) do
		if term.cmd and string.find(term.cmd, "opencode") then
			-- Check if direction matches or if no direction specified
			if not direction or (term.direction and term.direction == direction) then
				return term
			end
		end
	end
end

local function create_opencode_term(terms, direction)
	local Terminal = terms.Terminal
	return Terminal:new({
		cmd = "opencode",
		direction = direction or "float",
		hidden = true,
		on_open = function()
			if direction == "vertical" then
				local width = math.floor(vim.o.columns * 0.4)
				vim.cmd("vertical resize " .. width)
			end
			vim.keymap.set("t", "<c-u>", "<c-m-u>", { buffer = true, desc = "Scroll up" })
			vim.keymap.set("t", "<c-d>", "<c-m-d>", { buffer = true, desc = "Scroll down" })
			vim.cmd("startinsert")
		end,
	})
end

local function is_valid_buffer(term)
	return term.bufnr and vim.api.nvim_buf_is_valid(term.bufnr) and vim.api.nvim_buf_is_loaded(term.bufnr)
end

-- Custom function to toggle opencode toggleterm terminal
local function toggle_opencode_terminal(direction)
	with_toggleterm(function(terms)
		local term = find_opencode_term(terms, direction)

		if term then
			if is_valid_buffer(term) then
				pcall(function()
					term:toggle()
				end)
			else
				pcall(function()
					term:shutdown()
				end)
				term = create_opencode_term(terms, direction)
				pcall(function()
					term:open()
				end)
			end
		else
			term = create_opencode_term(terms, direction)
			pcall(function()
				term:open()
			end)
		end
	end)
end

return {
	{
		"NickvanDyke/opencode.nvim",
		dependencies = {
			"akinsho/toggleterm.nvim",
		},
		config = function()
			require("opencode").setup({
				on_opencode_not_found = function()
					local term
					local success, err = pcall(function()
						with_toggleterm(function(terms)
							term = create_opencode_term(terms, "float")
							term:toggle()
						end)
					end)

					if not success then
						vim.notify(
							"Failed to open opencode terminal: " .. (err or "unknown error"),
							vim.log.levels.ERROR,
							{ title = "opencode" }
						)
						return false
					end

					return term and true or false
				end,
				on_send = function()
					with_toggleterm(function(terms)
						local term = find_opencode_term(terms)

						if term then
							if is_valid_buffer(term) then
								pcall(function()
									term:open()
								end)
							else
								toggle_opencode_terminal()
							end
						else
							toggle_opencode_terminal()
						end
					end)
				end,
			})
		end,
		keys = {
			-- Recommended keymaps
			{
				"<leader>aA",
				function()
					require("opencode").ask()
				end,
				desc = "Ask opencode",
			},
			{
				"<leader>aa",
				function()
					require("opencode").ask("@cursor: ")
				end,
				desc = "Ask opencode about this",
				mode = "n",
			},
			{
				"<leader>aa",
				function()
					require("opencode").ask("@selection: ")
				end,
				desc = "Ask opencode about selection",
				mode = "v",
			},
			{
				"<m-,>",
				function()
					toggle_opencode_terminal("float")
				end,
				desc = "Toggle embedded float opencode",
				mode = { "n", "t" },
			},
			{
				"<m-.>",
				function()
					toggle_opencode_terminal("vertical")
				end,
				desc = "Toggle embedded vsplit opencode",
				mode = { "n", "t" },
			},
			{
				"<leader>an",
				function()
					require("opencode").command("session_new")
				end,
				desc = "New session",
			},
			{
				"<leader>ay",
				function()
					require("opencode").command("messages_copy")
				end,
				desc = "Copy last message",
			},
			{
				"<leader>ap",
				function()
					require("opencode").select_prompt()
				end,
				desc = "Select prompt",
				mode = { "n", "v" },
			},
			{
				"<leader>ae",
				function()
					require("opencode").prompt("Explain @cursor and its context")
				end,
				desc = "Explain code near cursor",
			},
			{
				"<leader>ag",
				function()
					require("opencode").prompt(
						"/git_commit 現在のファイルの変更を元に、git add, commitを実行してください。"
					)
				end,
				desc = "Execute git add, commit",
			},
			{
				"<leader>ag",
				function()
					require("opencode").prompt(
						"/git_commit @selection この選択範囲を元に、git add, commitを実行してください。"
					)
				end,
				desc = "Execute git add, commit",
				mode = "v",
			},
		},
	},
	{
		"zbirenbaum/copilot.lua",
		event = { "InsertEnter", "CmdlineEnter" },
		config = function()
			require("copilot").setup({
				filetypes = {
					yaml = true,
					markdown = true,
					gitcommit = true,
					sh = function()
						if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "%.env") then
							-- disable for .env files
							return false
						end
						return true
					end,
				},
				suggestion = {
					auto_trigger = true,
				},
			})
		end,
	},
}
