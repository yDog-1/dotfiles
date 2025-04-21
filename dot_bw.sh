# bwコマンドの存在チェック
if ! command -v bw &> /dev/null; then
    echo "Warning: bw command not found. Skipping Bitwarden operations." >&2
    return 0 2>/dev/null || exit 0
fi

# BW_PASSWORD環境変数のチェック
if [ -z "$BW_PASSWORD" ]; then
    echo "Warning: BW_PASSWORD environment variable is not set. Skipping Bitwarden operations." >&2
    return 0 2>/dev/null || exit 0
fi

# 各キーを環境変数に代入
if ! bw login --check > /dev/null
then
    BW_SESSION="$(bw login --raw "$1" "$BW_PASSWORD")"
    export BW_SESSION
fi
if ! bw unlock --check > /dev/null
then
    BW_SESSION="$(bw unlock --raw "$BW_PASSWORD")"
    export BW_SESSION
    OPENROUTER_API_KEY=$(bw get notes OPENROUTER_API_KEY)
    export OPENROUTER_API_KEY
    BRAVE_API_KEY=$(bw get notes BRAVE_API_KEY)
    export BRAVE_API_KEY
fi
