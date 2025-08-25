local M = {}

--- Get the current Nix system architecture
--- @return string The system architecture (e.g., "x86_64-linux", "aarch64-darwin")
--- @usage
---   local system = require("utils.nix").get_system()
---   print(system) -- "x86_64-linux"
function M.get_system()
	-- デフォルト値を定数として定義
	local DEFAULT_SYSTEM = "x86_64-linux"

	-- nixコマンドを実行してシステムアーキテクチャを取得
	local handle = io.popen("nix eval --expr 'builtins.currentSystem' --impure 2>/dev/null")
	if not handle then
		return DEFAULT_SYSTEM
	end

	local result = handle:read("*a")
	handle:close()

	-- 結果が空の場合は早期リターン
	if not result or result == "" then
		return DEFAULT_SYSTEM
	end

	-- 引用符と改行を削除
	local system = result:gsub('"', ""):gsub("\n", "")

	-- クリーンアップ後の結果が空の場合は早期リターン
	if system == "" then
		return DEFAULT_SYSTEM
	end

	return system
end

return M
