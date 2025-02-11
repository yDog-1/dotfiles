return {
  {
    -- ファイルブラウザ
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    keys = {
      -- 設定ディレクトリ `~/.config/nvim`を開く
      { "<Leader>.", ":Neotree filesystem left dir=~/.config/nvim<CR>" },
      -- ネオツリーを開く
      { "<Leader>e", ":Neotree filesystem reveal left<CR>" },
    },
    cmd = "Neotree",
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
        },
      },
    },
  },
}
