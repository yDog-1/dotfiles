-- vim-jetpack
-- 自動でプラグインマネージャをインストールする設定
local jetpackfile = vim.fn.stdpath('data') .. '~/.local/share/nvim/site/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim'
local jetpackurl = "https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim"
if vim.fn.filereadable(jetpackfile) == 0 then
  vim.fn.system(string.format('curl -fsSLo %s --create-dirs %s', jetpackfile, jetpackurl))
end

-- プラグイン
-- Packer.nvim v2 スタイル
vim.cmd('packadd vim-jetpack')
require('jetpack.packer').add {
  {'tani/vim-jetpack'}, -- bootstrap
  {'sainnhe/sonokai'},  -- カラースキーム
  {'nvim-treesitter/nvim-treesitter'}, -- シンタックスハイライトをより良くする
}

-- 自動でプラグインをインストールする設定
local jetpack = require('jetpack')
for _, name in ipairs(jetpack.names()) do
  if not jetpack.tap(name) then
    jetpack.sync()
    break
  end
end
