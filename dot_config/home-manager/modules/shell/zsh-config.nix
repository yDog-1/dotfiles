{
  _pkgs,
  _config,
  ...
}: {
  programs.zsh = {
    enable = true;

    # 履歴設定
    history = {
      size = 1000;
      save = 1000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      ignoreAllDups = true;
      share = true;
    };

    # Zshオプション
    defaultKeymap = "viins"; # viキーバインディング

    # Zsh初期化スクリプト（すべてを一つのinitExtraにまとめる）
    initContent = ''
      # Enable Powerlevel10k instant prompt (must be at the top)
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # Secrets
      if [ -f ~/.secrets.env ]; then
        source ~/.secrets.env
      fi

      # Homebrew
      if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
        export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      elif [ -f "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      elif command -v brew >/dev/null 2>&1; then
        eval "$(brew shellenv)"
      fi

      # Node.js Management
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
      command -v nodenv >/dev/null 2>&1 && eval "$(nodenv init - zsh)"

      # Python Management
      command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init - zsh)"

      # Terraform completion
      [ -f "/usr/bin/terraform" ] && complete -C /usr/bin/terraform terraform

      # Deno environment
      [ -f "$HOME/.deno/env" ] && . "$HOME/.deno/env"
      [ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

      # Sheldon初期化（条件付き）
      command -v sheldon >/dev/null 2>&1 && eval "$(sheldon source)"

      # Keybindings
      # jjでノーマルモードに移行
      bindkey -M viins 'jj' vi-cmd-mode
      # j で 履歴を進む
      bindkey -M vicmd 'j' down-line-or-history
      # Ctrl - p で 履歴,メニューを遡る
      bindkey -M viins '^P' up-line-or-search
      # Ctrl - o でNeovimでコマンドを編集
      autoload -Uz edit-command-line
      zle -N edit-command-line
      bindkey "^O" edit-command-line

      # ghq
      function ghq-fzf() {
        local src=$(ghq list | fzf --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.*")
        if [ -n "$src" ]; then
          BUFFER="cd $(ghq root)/$src"
          zle accept-line
        fi
        zle -R -c
      }
      zle -N ghq-fzf
      bindkey '^G' ghq-fzf

      # Powerlevel10k configuration
      [[ ! -f "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"
    '';
  };
}
