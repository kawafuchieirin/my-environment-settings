#!/bin/bash
set -e

echo "=== VS Code セットアップ ==="
echo ""

# VS Codeがインストールされているか確認
if ! command -v code &> /dev/null; then
    echo "VS Codeがインストールされていません"
    echo "https://code.visualstudio.com/ からダウンロードしてください"
    echo ""
    echo "または Homebrew でインストール:"
    echo "  brew install --cask visual-studio-code"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"

# 設定ディレクトリが存在するか確認
if [ ! -d "$VSCODE_USER_DIR" ]; then
    echo "VS Code設定ディレクトリが見つかりません"
    echo "VS Codeを一度起動してから再実行してください"
    exit 1
fi

# ==========================================================================
# 設定ファイルのバックアップとコピー
# ==========================================================================

echo "=== 設定ファイルを配置中 ==="

# settings.json
if [ -f "$VSCODE_USER_DIR/settings.json" ]; then
    cp "$VSCODE_USER_DIR/settings.json" "$VSCODE_USER_DIR/settings.json.backup.$(date +%Y%m%d%H%M%S)"
    echo "settings.json をバックアップしました"
fi
cp "$SCRIPT_DIR/settings.json" "$VSCODE_USER_DIR/settings.json"
echo "settings.json を配置しました"

# keybindings.json
if [ -f "$VSCODE_USER_DIR/keybindings.json" ]; then
    cp "$VSCODE_USER_DIR/keybindings.json" "$VSCODE_USER_DIR/keybindings.json.backup.$(date +%Y%m%d%H%M%S)"
    echo "keybindings.json をバックアップしました"
fi
cp "$SCRIPT_DIR/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
echo "keybindings.json を配置しました"

# ==========================================================================
# 拡張機能のインストール
# ==========================================================================

echo ""
echo "=== 拡張機能をインストール中 ==="

# extensions.txtから拡張機能をインストール
while IFS= read -r line || [[ -n "$line" ]]; do
    # コメントと空行をスキップ
    [[ "$line" =~ ^#.*$ ]] && continue
    [[ -z "$line" ]] && continue

    echo "インストール中: $line"
    code --install-extension "$line" --force 2>/dev/null || echo "  スキップ: $line"
done < "$SCRIPT_DIR/extensions.txt"

echo ""
echo "=== セットアップ完了 ==="
echo ""
echo "VS Codeを再起動して設定を反映してください"
echo ""
echo "=== 便利なショートカット ==="
echo ""
echo "ファイル操作:"
echo "  Cmd + P          : ファイル検索"
echo "  Cmd + Shift + P  : コマンドパレット"
echo "  Cmd + B          : サイドバー表示/非表示"
echo "  Cmd + J          : パネル表示/非表示"
echo ""
echo "編集:"
echo "  Cmd + D          : 次の同じ単語を選択"
echo "  Cmd + Shift + L  : 同じ単語を全て選択"
echo "  Alt + ↑/↓        : 行を移動"
echo "  Cmd + Shift + D  : 行を複製"
echo "  Cmd + Shift + K  : 行を削除"
echo ""
echo "コード:"
echo "  F2               : 名前変更（リファクタリング）"
echo "  F12              : 定義に移動"
echo "  Cmd + /          : コメント切り替え"
echo "  Shift + Alt + F  : フォーマット"
