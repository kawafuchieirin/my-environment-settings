#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== 環境セットアップ ==="
echo ""
echo "どの環境をセットアップしますか？"
echo "1) zsh (terminal/)"
echo "2) Nushell (rust-shell/)"
echo "3) 両方"
echo ""
read -p "選択 [1-3]: " choice

case $choice in
    1)
        bash "$SCRIPT_DIR/terminal/setup.sh"
        ;;
    2)
        bash "$SCRIPT_DIR/rust-shell/setup.sh"
        ;;
    3)
        bash "$SCRIPT_DIR/terminal/setup.sh"
        bash "$SCRIPT_DIR/rust-shell/setup.sh"
        ;;
    *)
        echo "無効な選択です"
        exit 1
        ;;
esac

echo ""
echo "=== セットアップ完了 ==="
