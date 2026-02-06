#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== zsh環境セットアップ ==="

# .zshrcをシンボリックリンク
if [ -f ~/.zshrc ]; then
    backup=~/.zshrc.backup.$(date +%Y%m%d%H%M%S)
    mv ~/.zshrc "$backup"
    echo "既存の.zshrcをバックアップ: $backup"
fi
ln -sf "$SCRIPT_DIR/.zshrc" ~/.zshrc
echo ".zshrcをリンク"

# ローカル設定テンプレートをコピー
if [ ! -f "$SCRIPT_DIR/.zshrc.local" ] && [ -f "$SCRIPT_DIR/.zshrc.local.example" ]; then
    cp "$SCRIPT_DIR/.zshrc.local.example" "$SCRIPT_DIR/.zshrc.local"
    echo ".zshrc.localを作成"
fi

echo "=== 完了 ==="
