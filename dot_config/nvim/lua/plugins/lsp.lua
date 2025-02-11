local set = vim.keymap.set
-- カーソル下のシンボの情報をホバー表示
set("n", "K", vim.lsp.buf.hover)
-- カーソル下のシンボルの参照を一覧表示
set("n", "<Leader>cr", vim.lsp.buf.references)
-- 定義ジャンプ
set("n", "<Leader>cd", vim.lsp.buf.definition)
-- 型定義にジャンプ
set("n", "<Leader>ct", vim.lsp.buf.type_definition)
-- 宣言にジャンプ
set("n", "<Leader>cD", vim.lsp.buf.declaration)
-- カーソル下のシンボルの実装をクイックフィックスウィンドウにリスト...できてる？
set("n", "<Leader>ci", vim.lsp.buf.implementation)
-- 変数のリネーム
set("n", "<Leader>cR", vim.lsp.buf.rename)
-- VSCodeの電球的な
set("n", "<Leader>ca", vim.lsp.buf.code_action)
-- 電球箇所にジャンプ
set("n", "<Leader>cn", vim.diagnostic.goto_next)
set("n", "<Leader>cp", vim.diagnostic.goto_prev)
