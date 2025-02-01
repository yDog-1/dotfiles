return {
  {
    "williamboman/mason.nvim",
    lazy = true,
    dependencies = {
      -- Neovim での LSP 設定APIを提供
      "neovim/nvim-lspconfig",
      -- mason.nvim と nvim-lspconfig の連携
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup()

      -- インストールされているLSをセットアップ
      require('mason-lspconfig').setup_handlers({
        function (server_name)
          require("lspconfig")[server_name].setup({
              -- 補完プラグインのセットアップ
            })
        end,
      })
    end,
  },
}
