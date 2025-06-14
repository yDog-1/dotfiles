#!/bin/bash

# MCPHubのservers.jsonからClaude CodeにMCPサーバーを同期するスクリプト

set -e

SERVERS_JSON="dot_config/mcphub/servers.json"

if [[ ! -f "$SERVERS_JSON" ]]; then
    echo "Error: $SERVERS_JSON not found"
    exit 1
fi

echo "Syncing MCP servers from $SERVERS_JSON to Claude Code..."

# 既存のMCPサーバーをクリア（オプション）
read -p "Clear existing MCP servers? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Clearing existing MCP servers..."
    claude mcp list | grep -E "^  " | awk '{print $1}' | while read -r server; do
        if [[ -n "$server" ]]; then
            claude mcp remove -s user "$server" 2>/dev/null || true
        fi
    done
fi

# jqでJSONを解析してMCPサーバーを追加
jq -r '.mcpServers | to_entries[] | @json' "$SERVERS_JSON" | while IFS= read -r server_json; do
    name=$(echo "$server_json" | jq -r '.key')
    config=$(echo "$server_json" | jq -r '.value')
    
    command=$(echo "$config" | jq -r '.command')
    args=$(echo "$config" | jq -r '.args // [] | join(" ")')
    
    echo "Adding MCP server: $name"
    
    # 環境変数の処理
    env_vars=""
    if echo "$config" | jq -e '.env' > /dev/null 2>&1; then
        env_vars=$(echo "$config" | jq -r '.env | to_entries[] | "-e \(.key)=\(.value // "")"' | tr '\n' ' ')
    fi
    
    # コマンド構築と実行
    if [[ -n "$args" ]]; then
        if [[ -n "$env_vars" ]]; then
            eval "claude mcp add -s user \"$name\" \"$command\" -- $args $env_vars"
        else
            eval "claude mcp add -s user \"$name\" \"$command\" -- $args"
        fi
    else
        if [[ -n "$env_vars" ]]; then
            eval "claude mcp add -s user \"$name\" \"$command\" $env_vars"
        else
            claude mcp add -s user "$name" "$command"
        fi
    fi
    
    echo "✓ Added $name"
done

echo "MCP server sync completed!"
echo
echo "Current MCP servers:"
claude mcp list
