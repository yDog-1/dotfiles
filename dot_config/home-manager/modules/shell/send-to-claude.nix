{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellScriptBin "send-to-claude" ''
      #!/bin/bash

      # Claude用プロンプト送信スクリプト
      # フォーカス循環によりClaudeペインを動的検出

      # 開始ペインIDを記録
      START_PANE_ID="$ZELLIJ_PANE_ID"

      # 一時ファイルを作成
      TEMP_FILE="/tmp/claude_prompt_$$"

      # 一時ファイルが既に存在する場合は削除
      [ -f "$TEMP_FILE" ] && rm "$TEMP_FILE"

      # nvimで一時ファイルを編集
      nvim "$TEMP_FILE"

      # 編集が完了したかチェック（ファイルが存在し、空でない場合）
      if [ -f "$TEMP_FILE" ] && [ -s "$TEMP_FILE" ]; then
          # ファイルの内容を読み取り
          PROMPT_CONTENT=$(cat "$TEMP_FILE")

          # 浮動ペインを閉じて通常のペインに戻る
          zellij action toggle-floating-panes 2>/dev/null
          sleep 0.5

          # フォーカス循環によるClaudeペイン検出
          CLAUDE_PANE_FOUND=false
          MAX_ATTEMPTS=10
          ATTEMPT=1

          while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
              # 現在のペインでlist-clientsを実行してClaudeプロセスをチェック
              CURRENT_CLIENTS=$(zellij action list-clients 2>/dev/null)

              # Claudeプロセスが現在のペインにあるかチェック（大文字小文字を区別しない）
              GREP_RESULT=$(echo "$CURRENT_CLIENTS" | grep -i "claude")
              if [ -n "$GREP_RESULT" ]; then
                  CLAUDE_PANE_FOUND=true
                  CLAUDE_PANE_ID="$ZELLIJ_PANE_ID"
                  break
              fi

              # 最大試行回数チェック
              if [ $ATTEMPT -gt $MAX_ATTEMPTS ]; then
                  break
              fi

              # 次のペインに移動
              if ! zellij action focus-next-pane 2>/dev/null; then
                  break
              fi

              # 少し待機
              sleep 0.1

              ATTEMPT=$((ATTEMPT + 1))
          done

          if [ "$CLAUDE_PANE_FOUND" = true ]; then
              # プロンプト内容をClaudeプロセスに送信
              if zellij action write-chars "$PROMPT_CONTENT"; then
                  # Enterキーを送信
                  if zellij action write-chars $'\n'; then
                      echo "✓ プロンプトをClaudeに送信しました"
                  else
                      echo "✗ Enterキーの送信に失敗しました"
                      exit 1
                  fi
              else
                  echo "✗ プロンプト内容の送信に失敗しました"
                  exit 1
              fi

          else
              echo "✗ Claudeプロセスが見つかりませんでした"
              exit 1
          fi

      else
          echo "プロンプトが空か、編集がキャンセルされました"
      fi

      # 一時ファイルを削除
      if [ -f "$TEMP_FILE" ]; then
          rm "$TEMP_FILE"
      fi
    '')
  ];
}

