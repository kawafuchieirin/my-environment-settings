#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
NUSHELL_CONFIG_DIR=~/Library/Application\ Support/nushell

echo "=== Nushell環境セットアップ ==="

# Nushell設定ディレクトリ作成
mkdir -p "$NUSHELL_CONFIG_DIR"

# 設定ファイルをシンボリックリンク
for file in env.nu config.nu; do
    target="$NUSHELL_CONFIG_DIR/$file"
    if [ -f "$target" ]; then
        backup="$target.backup.$(date +%Y%m%d%H%M%S)"
        mv "$target" "$backup"
        echo "既存の$fileをバックアップ: $backup"
    fi
    ln -sf "$SCRIPT_DIR/nushell/$file" "$target"
    echo "$fileをリンク"
done

echo "=== 完了 ==="
