{
  pkgs,
  _config,
  ...
}: {
  home.packages = with pkgs; [
    # LSP Servers
    efm-langserver
    lua-language-server
    typescript-language-server
    gopls
    golangci-lint-langserver
    sqls
    graphql-language-service-cli
    vscode-langservers-extracted
    yaml-language-server
    terraform-ls
    taplo
    astro-language-server
    tailwindcss-language-server
    nixd

    # Linters
    gitlint
    hadolint
    tflint
    eslint
    sqlfluff
    yamllint
    markdownlint-cli
    golangci-lint

    # Formatters
    stylua
    biome
    dprint
    prettier
    gotools
    alejandra

    # Tools
    gomodifytags
  ];
}
