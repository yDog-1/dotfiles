{
  _config,
  pkgs,
  ...
}: {
  imports = [
    ./modules/shell
    ./modules/tools.nix
    ./modules/development.nix
    ./modules/skk
  ];

  home.username = "ydog-1";
  home.homeDirectory = "/home/ydog-1";

  home.stateVersion = "25.05"; # Please read the comment before changing.

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # シェル・ターミナル
    zsh
    zellij

    # エディタ
    vim
    neovim
    tree-sitter

    # better man
    tldr

    # データ処理・解析
    jq
    yq

    # ネットワーク・通信
    curl
    wget

    # Git
    git
    gh
    lazygit
    delta

    # コンテナ
    podman

    # 画像・ドキュメント処理
    imagemagick
    ghostscript

    # 設定管理
    chezmoi

    # Go
    go

    # JavaScript
    nodejs
    deno
    bun

    # Python
    python3
    python3Packages.pip
    uv

    # Rust
    cargo
    rustc

    # クリップボード
    xclip # X11用
    wl-clipboard # Wayland用
  ];

  programs.zsh.shellAliases = {
    "docker" = "podman";
  };
}
