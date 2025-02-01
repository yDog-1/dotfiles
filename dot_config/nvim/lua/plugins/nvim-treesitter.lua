return {
  {
    -- syntax highlightをいい感じにするプラグイン
    'nvim-treesitter/nvim-treesitter',
    build = function()
        -- 全ての言語をインストール
        require('nvim-treesitter.install').setup({ ensure_installed = 'all' })
    end
  },
}
