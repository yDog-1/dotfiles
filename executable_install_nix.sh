#!/bin/bash
# Nix, Home-Manager, Chezmoi インストールスクリプト
set -e

echo "Nixをインストールしています..."
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate

echo "環境設定を読み込んでいます..."
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

echo "Home Managerをインストールしています..."
nix run home-manager/master -- init --switch

echo ""
echo "=== Chezmoi セットアップ ==="
echo "dotfilesリポジトリからChezmoiを初期化しますか？ (y/N)"
read -r setup_chezmoi

if [[ "$setup_chezmoi" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "GitHubユーザー名を入力してください:"
    read -r github_user
    
    if [ -z "$github_user" ]; then
        echo "ユーザー名が入力されませんでした。Chezmoiのセットアップをスキップします。"
    else
        echo "リポジトリ名を入力してください (デフォルト: dotfiles):"
        read -r repo_name
        repo_name=${repo_name:-dotfiles}
        
        echo "Chezmoiを一時的にインストールして初期化中..."
        echo "対象リポジトリ: https://github.com/$github_user/$repo_name"
        
        # nix-shellを使ってChezmoiを一時的にインストールし、初期化
        nix-shell -p chezmoi --run "
            echo 'Chezmoiでdotfilesを初期化しています...'
            chezmoi init --apply https://github.com/$github_user/$repo_name.git
            
            echo 'Chezmoiの状態を確認中...'
            chezmoi status

        "
        echo "Chezmoiのセットアップが完了しました！"
    fi
else
    echo "Chezmoiのセットアップをスキップしました。"
    echo "後でセットアップする場合は以下のコマンドを実行してください:"
    echo "  nix-shell -p chezmoi --run 'chezmoi init --apply https://github.com/YOUR_USER/YOUR_REPO.git'"
fi

echo ""
echo "=== インストール完了！ ==="
echo "新しいターミナルを開いて以下を確認してください:"
echo "1. 'nix --version' でNixが動作することを確認"
echo "2. 'home-manager --version' でHome Managerが動作することを確認"
if [[ "$setup_chezmoi" =~ ^([yY][eE][sS]|[yY])$ ]] && [ ! -z "$github_user" ]; then
    echo "3. 'chezmoi status' でChezmoiの状態を確認"
fi
