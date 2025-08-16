#!/bin/bash

# fcitx5-skk インストールスクリプト
# 対応ディストリビューション: Ubuntu/Debian, Fedora, Arch Linux

set -e

# 色付きメッセージ用の関数
print_info() {
    echo -e "\033[1;34m[INFO]\033[0m $1"
}

print_success() {
    echo -e "\033[1;32m[SUCCESS]\033[0m $1"
}

print_error() {
    echo -e "\033[1;31m[ERROR]\033[0m $1"
}

print_warning() {
    echo -e "\033[1;33m[WARNING]\033[0m $1"
}

# パッケージマネージャー検出
detect_package_manager() {
    if command -v apt >/dev/null 2>&1; then
        echo "apt"
    elif command -v dnf >/dev/null 2>&1; then
        echo "dnf"
    elif command -v yum >/dev/null 2>&1; then
        echo "yum"
    elif command -v pacman >/dev/null 2>&1; then
        echo "pacman"
    elif command -v zypper >/dev/null 2>&1; then
        echo "zypper"
    else
        print_error "サポートされているパッケージマネージャーが見つかりませんでした"
        exit 1
    fi
}

# apt系（Ubuntu, Debian, Pop!OS等）用インストール
install_apt() {
    print_info "apt系ディストリビューション向けにfcitx5-skkをインストールします..."
    
    # パッケージリストを更新
    sudo apt update
    
    # fcitx5とfcitx5-skkをインストール
    sudo apt install -y fcitx5 fcitx5-skk fcitx5-config-qt fcitx5-frontend-gtk2 fcitx5-frontend-gtk3 fcitx5-frontend-qt5
    
    # SKK辞書をインストール
    sudo apt install -y skkdic skkdic-extra
    
    print_success "パッケージのインストールが完了しました"
}

# dnf系（Fedora等）用インストール
install_dnf() {
    print_info "dnf系ディストリビューション向けにfcitx5-skkをインストールします..."
    
    # fcitx5とfcitx5-skkをインストール
    sudo dnf install -y fcitx5 fcitx5-skk fcitx5-configtool fcitx5-gtk fcitx5-qt
    
    # SKK辞書をインストール
    sudo dnf install -y skk-jisyo
    
    print_success "パッケージのインストールが完了しました"
}

# yum系（RHEL, CentOS等）用インストール
install_yum() {
    print_info "yum系ディストリビューション向けにfcitx5-skkをインストールします..."
    
    # EPELリポジトリを有効化（必要に応じて）
    sudo yum install -y epel-release
    
    # fcitx5とfcitx5-skkをインストール
    sudo yum install -y fcitx5 fcitx5-skk fcitx5-configtool fcitx5-gtk fcitx5-qt
    
    # SKK辞書をインストール
    sudo yum install -y skk-jisyo
    
    print_success "パッケージのインストールが完了しました"
}

# pacman系（Arch Linux等）用インストール
install_pacman() {
    print_info "pacman系ディストリビューション向けにfcitx5-skkをインストールします..."
    
    # fcitx5とfcitx5-skkをインストール
    sudo pacman -S --noconfirm fcitx5-im fcitx5-skk fcitx5-configtool
    
    # SKK辞書をインストール
    sudo pacman -S --noconfirm skk-jisyo
    
    print_success "パッケージのインストールが完了しました"
}

# zypper系（openSUSE等）用インストール
install_zypper() {
    print_info "zypper系ディストリビューション向けにfcitx5-skkをインストールします..."
    
    # fcitx5とfcitx5-skkをインストール
    sudo zypper install -y fcitx5 fcitx5-skk fcitx5-configtool fcitx5-gtk fcitx5-qt
    
    # SKK辞書をインストール（パッケージ名が異なる場合があります）
    sudo zypper install -y skk-jisyo || print_warning "SKK辞書のパッケージが見つかりませんでした。手動でインストールしてください。"
    
    print_success "パッケージのインストールが完了しました"
}

# 環境変数設定
setup_environment() {
    print_info "環境変数を設定します..."
    
    ENV_FILE="$HOME/.xprofile"
    
    # .xprofileファイルにfcitx5の環境変数を追加
    cat >> "$ENV_FILE" << EOF

# fcitx5設定
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
EOF
    
    # .bashrcにも追加（ターミナルアプリケーション用）
    if [ -f "$HOME/.bashrc" ]; then
        grep -q "export GTK_IM_MODULE=fcitx" "$HOME/.bashrc" || {
            cat >> "$HOME/.bashrc" << EOF

# fcitx5設定
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
EOF
        }
    fi
    
    print_success "環境変数の設定が完了しました"
}

# fcitx5の自動起動設定
setup_autostart() {
    print_info "fcitx5の自動起動を設定します..."
    
    # autostartディレクトリを作成
    mkdir -p "$HOME/.config/autostart"
    
    # fcitx5のデスクトップファイルを作成
    cat > "$HOME/.config/autostart/fcitx5.desktop" << EOF
[Desktop Entry]
Type=Application
Exec=fcitx5
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Fcitx 5
Comment=Start Fcitx 5
EOF
    
    print_success "自動起動の設定が完了しました"
}

# SKK設定のセットアップ
setup_skk_config() {
    print_info "SKKの基本設定を行います..."
    
    # fcitx5設定ディレクトリを作成
    mkdir -p "$HOME/.config/fcitx5/conf"
    
    # SKKの基本設定ファイルを作成
    cat > "$HOME/.config/fcitx5/conf/skk.conf" << EOF
# SKK設定ファイル
[UserDict]
Path=~/.skk-jisyo

[Dictionary1]
Path=/usr/share/skk/SKK-JISYO.L
Mode=readonly

[PunctuationStyle]
0=Japanese

[InitialInputMode]
0=Hiragana
EOF
    
    # ユーザー辞書ファイルを作成
    touch "$HOME/.skk-jisyo"
    
    print_success "SKKの基本設定が完了しました"
}

# メイン実行部分
main() {
    print_info "fcitx5-skkインストールスクリプトを開始します"
    
    # ルート権限チェック
    if [ "$EUID" -eq 0 ]; then
        print_error "このスクリプトはroot権限で実行しないでください"
        exit 1
    fi
    
    # パッケージマネージャー検出とインストール
    PACKAGE_MANAGER=$(detect_package_manager)
    print_info "検出されたパッケージマネージャー: $PACKAGE_MANAGER"
    
    case $PACKAGE_MANAGER in
        apt)
            install_apt
            ;;
        dnf)
            install_dnf
            ;;
        yum)
            install_yum
            ;;
        pacman)
            install_pacman
            ;;
        zypper)
            install_zypper
            ;;
        *)
            print_error "サポートされていないパッケージマネージャーです: $PACKAGE_MANAGER"
            print_info "手動でfcitx5-skkをインストールしてください"
            exit 1
            ;;
    esac
    
    # 環境設定
    setup_environment
    setup_autostart
    setup_skk_config
    
    print_success "インストールが完了しました！"
    print_warning "設定を有効にするため、一度ログアウトして再ログインしてください"
    print_info "再ログイン後、fcitx5-configtoolを実行してSKKを有効にしてください"
}

# スクリプト実行
main "$@"
