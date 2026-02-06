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
echo ""
echo "1) zsh"
echo "2) Nushell"
echo "3) 両方"
echo ""
read -p "選択 [1-3]: " shell_choice

# zsh
if [ "$shell_choice" = "1" ] || [ "$shell_choice" = "3" ]; then
    echo ""
    echo "--- zsh ---"
    backup_and_link "$SCRIPT_DIR/zsh/.zshrc" ~/.zshrc
fi

# Nushell
if [ "$shell_choice" = "2" ] || [ "$shell_choice" = "3" ]; then
    echo ""
    echo "--- Nushell ---"
    NUSHELL_DIR=~/Library/Application\ Support/nushell
    mkdir -p "$NUSHELL_DIR"
    backup_and_link "$SCRIPT_DIR/nushell/env.nu" "$NUSHELL_DIR/env.nu"
    backup_and_link "$SCRIPT_DIR/nushell/config.nu" "$NUSHELL_DIR/config.nu"
fi

# WezTerm
echo ""
echo "--- WezTerm ---"
mkdir -p ~/.config/wezterm
backup_and_link "$SCRIPT_DIR/wezterm/wezterm.lua" ~/.config/wezterm/wezterm.lua

# Starship
echo ""
echo "--- Starship ---"
backup_and_link "$SCRIPT_DIR/starship/starship.toml" ~/.config/starship.toml

echo ""
echo "=== 完了 ==="
