{
  _config,
  pkgs,
  ...
}: {
  imports = [
    ./modules/shell/shell-common.nix
    ./modules/shell/zsh-config.nix
    ./modules/skk/jisyo.nix
  ];

  home.username = "ydog-1";
  home.homeDirectory = "/home/ydog-1";

  home.stateVersion = "25.05"; # Please read the comment before changing.

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # シェル・ターミナル
    zsh
    zellij
    sheldon # Zshプラグインマネージャ

    # エディタ
    vim
    neovim
    tree-sitter

    # ファイル操作・検索
    fzf
    ripgrep
    fd
    bat
    eza
    zoxide

    # データ処理・解析
    jq
    yq

    # ネットワーク・通信
    curl
    wget

    # 開発支援
    claude-code
    direnv
    ghq

    # Git
    git
    gh
    lazygit
    delta

    # コンテナ
    docker

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
}
