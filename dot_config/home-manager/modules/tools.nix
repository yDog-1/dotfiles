{
  pkgs,
  _config,
  ...
}: {
  home.packages = with pkgs; [
    ghq
    fd
    bat
    tree
  ];

  # fzf - ファジーファインダー
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--preview 'bat --color=always --style=numbers --line-range=:50 {}'"
    ];
  };

  # bat - catの代替
  programs.bat = {
    enable = true;
  };

  # eza - lsの代替
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };

  # zoxide - スマートディレクトリジャンプ
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = ["--cmd zo"];
  };

  # ripgrep - grepの代替
  programs.ripgrep = {
    enable = true;
    arguments = [
      "--max-columns=150"
      "--max-columns-preview"
      "--smart-case"
    ];
  };

  # fd - findの代替
  programs.fd = {
    enable = true;
    hidden = true;
    ignores = [
      ".git/"
      "node_modules/"
      "*.pyc"
    ];
  };

  # direnv - 環境変数の自動ロード
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Zsh関数とキーバインドの追加
  programs.zsh = {
    enableCompletion = false;

    initContent = ''
      # ghq + fzf でリポジトリ選択
      function ghq-fzf() {
        local selected_dir=$(ghq list | fzf --query="$LBUFFER" --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.md 2>/dev/null || echo 'No README found'")
        if [ -n "$selected_dir" ]; then
          BUFFER="cd $(ghq root)/$selected_dir"
          zle accept-line
        fi
        zle clear-screen
      }
      zle -N ghq-fzf
      bindkey '^G' ghq-fzf
    '';
  };
}
