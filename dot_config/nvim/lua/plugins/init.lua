return {
  {
    -- カラースキーム
    'sainnhe/sonokai',
    lazy = false,
    priority = 1000,
    config = function()
     vim.cmd.colorscheme('sonokai')
    end,
    init = function()
      vim.g.sonokai_transparent_background = 1
    end,
  },
  {
    -- syntax highlightをいい感じにするプラグイン
    'nvim-treesitter/nvim-treesitter',
    build = function()
        -- 全ての言語をインストール
        require('nvim-treesitter.install').setup({ ensure_installed = 'all' })()
    end,
  },
  {
    -- Vimの対応言語を増やし、ハイライト・インデント・ファイルタイプの検出機能を拡張するプラグイン
    'sheerun/vim-polyglot',
  },
    -- ファイルブラウザ
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      -- ユーティリティライブラリ
      "nvim-lua/plenary.nvim",
      -- アイコンプラグイン
      "nvim-tree/nvim-web-devicons",
      -- UIコンポーネントライブラリ
      "MunifTanjim/nui.nvim",
    }
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("hlchunk").setup({
        chunk = {
          enable = true,
          duration = 0,
          delay = 0,
        },
        indent = {
          enable = true,
          delay = 0,
        },
      })
    end
  },
}

