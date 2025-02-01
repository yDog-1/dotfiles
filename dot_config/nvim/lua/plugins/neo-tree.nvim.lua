return {
  {
    -- ファイルブラウザ
    'nvim-neo-tree/neo-tree.nvim',
    keys = {
      -- 設定ディレクトリ `~/.config/nvim`を開く
      { '<Leader>.', function() vim.cmd('cd ~/.config/nvim') vim.cmd('Neotree') end },
      -- ネオツリーを開く
      { '<Leader>e', function() vim.cmd('Neotree') end }
    },
    cmd = 'Neotree',
    branch = 'v3.x',
    dependencies = {
      -- ユーティリティライブラリ
      'nvim-lua/plenary.nvim',
      -- アイコンプラグイン
      'nvim-tree/nvim-web-devicons',
      -- UIコンポーネントライブラリ
      'MunifTanjim/nui.nvim',
    },
  },
}
