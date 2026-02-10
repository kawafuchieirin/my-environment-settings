#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

backup_and_link() {
    local src="$1"
    local dest="$2"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        local backup="${dest}.backup.$(date +%Y%m%d%H%M%S)"
        mv "$dest" "$backup"
        echo "バックアップ: $backup"
    fi

    ln -sf "$src" "$dest"
    echo "リンク: $dest -> $src"
}

echo "=== 環境セットアップ ==="

# zsh
echo ""
echo "--- zsh ---"
backup_and_link "$SCRIPT_DIR/zsh/.zshrc" ~/.zshrc

# Ghostty
echo ""
echo "--- Ghostty ---"
mkdir -p ~/.config/ghostty
backup_and_link "$SCRIPT_DIR/ghostty/config" ~/.config/ghostty/config

# Starship
echo ""
echo "--- Starship ---"
backup_and_link "$SCRIPT_DIR/starship/starship.toml" ~/.config/starship.toml

echo ""
echo "=== 完了 ==="
