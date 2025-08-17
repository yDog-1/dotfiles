{
  _pkgs,
  _config,
  ...
}: {
  programs.zsh = {
    shellAliases = {
      # ファイル操作
      "ls" = "eza";
      "ll" = "eza -alF";
      "la" = "eza -A";
      "l" = "eza -F";
      "tree" = "eza --tree";

      # catの代替
      "cat" = "bat";

      # findの代替
      "find" = "fd";

      # 便利コマンド
      "reload" = "source ~/.zshrc";
      "path" = "echo $PATH | tr ':' '\n'";
    };
  };
}
