{_pkgs, ...}: {
  # 共通環境変数
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "\${BROWSER:-\"firefox\"}";
    LANG = "ja_JP.UTF-8";
    LANGUAGE = "ja_JP:ja";

    # Node.js Management
    NVM_DIR = "$HOME/.nvm";

    # Python Management
    PYENV_ROOT = "$HOME/.pyenv";

    # Other Tools
    DPRINT_INSTALL = "$HOME/.dprint";
  };

  # 共通パス設定
  home.sessionPath = [
    "$HOME/.local/bin"
    "/opt/nvim-linux64/bin"
    "$PYENV_ROOT/bin"
    "$DPRINT_INSTALL/bin"
  ];
}
