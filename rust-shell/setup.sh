#!/bin/bash
# =============================================================================
# rust-shell/setup.sh - Nushell環境セットアップスクリプト
# =============================================================================
#
# 概要:
#   Rust製ツールで統一されたモダンなシェル環境をセットアップ。
#   Nushellをデフォルトシェルとして設定し、関連ツールをインストール。
#
# インストールされるツール:
#   シェル・ターミナル:
#     - nushell   : モダンなシェル
#     - wezterm   : GPU加速ターミナル
#     - starship  : カスタマイズ可能なプロンプト
#
#   エディタ:
#     - helix     : LSP自動有効のモダンエディタ
#
#   ファイル操作:
#     - zoxide    : 履歴ベースのスマートcd
#     - ripgrep   : 高速grep
#     - fd        : 高速find
#     - skim      : ファジーファインダー
#     - bat       : シンタックスハイライト付きcat
#
#   システム:
#     - btop      : リソースモニター
#
# 配置される設定ファイル:
#   ~/Library/Application Support/nushell/  <- nushell/（シンボリックリンク）
#   ~/.config/wezterm/wezterm.lua           <- wezterm/wezterm.lua
#   ~/.config/helix/                        <- helix/（シンボリックリンク）
#   ~/.config/starship.toml                 <- starship/starship.toml
#
# 使用方法:
#   cd rust-shell && ./setup.sh
#
# 注意:
#   - デフォルトシェルがNushellに変更されます
#   - /etc/shellsへの追加でsudoが必要になります
#   - 既存の設定ファイルは自動でバックアップされます
#
# =============================================================================
set -e

echo "=== Rust Shell セットアップ ==="
echo ""

# Homebrewのインストール確認
if ! command -v brew &> /dev/null; then
    echo "Homebrewをインストール中..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Apple Silicon対応
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "Homebrew: インストール済み"
fi

# Nerd Fontのインストール
echo ""
echo "=== Nerd Fontをインストール中 ==="
brew tap homebrew/cask-fonts 2>/dev/null || true
brew install --cask font-jetbrains-mono-nerd-font font-hack-nerd-font

# CLIツールのインストール
echo ""
echo "=== Rust製ツールをインストール中 ==="
brew install nushell wezterm helix starship zoxide ripgrep fd skim bat btop

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ==========================================================================
# 設定ファイルのバックアップとコピー
# ==========================================================================

echo ""
echo "=== 設定ファイルを配置中 ==="

# Nushell (macOSでは ~/Library/Application Support/nushell/ を使用)
echo "Nushell設定を配置中..."
NU_CONFIG_DIR="$HOME/Library/Application Support/nushell"
mkdir -p "$NU_CONFIG_DIR"

# 設定ファイル一覧（機能別に分割）
NU_FILES=("env.nu" "config.nu" "aliases.nu" "functions.nu" "help.nu")

for file in "${NU_FILES[@]}"; do
    if [ -f "$NU_CONFIG_DIR/$file" ] && [ ! -L "$NU_CONFIG_DIR/$file" ]; then
        mv "$NU_CONFIG_DIR/$file" "$NU_CONFIG_DIR/$file.backup.$(date +%Y%m%d%H%M%S)"
        echo "  $file をバックアップしました"
    fi
    ln -sf "$SCRIPT_DIR/nushell/$file" "$NU_CONFIG_DIR/$file"
done
echo "  Nushell設定をシンボリックリンクで配置しました"
echo "    - config.nu (メイン設定)"
echo "    - env.nu (環境変数・PATH)"
echo "    - aliases.nu (エイリアス)"
echo "    - functions.nu (カスタム関数)"
echo "    - help.nu (ヘルプコマンド)"

# ローカル設定ファイル（存在しない場合のみ作成）
if [ ! -f "$NU_CONFIG_DIR/local.nu" ]; then
    cat > "$NU_CONFIG_DIR/local.nu" << 'EOF'
# =============================================================================
# local.nu - ローカル専用設定
# =============================================================================
# このファイルはコミットされません。
# 会社用の環境変数やAPIキーなどを記載してください。
# テンプレート: rust-shell/nushell/local.nu.example
# =============================================================================

# 例:
# $env.COMPANY_API_KEY = "your-api-key"
# alias vpn = sudo openconnect vpn.company.com
EOF
    echo "  local.nu を作成しました（機密情報用）"
fi

# WezTerm
echo "WezTerm設定を配置中..."
mkdir -p ~/.config/wezterm
if [ -f ~/.config/wezterm/wezterm.lua ] && [ ! -L ~/.config/wezterm/wezterm.lua ]; then
    mv ~/.config/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua.backup.$(date +%Y%m%d%H%M%S)
    echo "  wezterm.lua をバックアップしました"
fi
ln -sf "$SCRIPT_DIR/wezterm/wezterm.lua" ~/.config/wezterm/wezterm.lua
echo "  WezTerm設定をシンボリックリンクで配置しました"

# Helix
echo "Helix設定を配置中..."
mkdir -p ~/.config/helix
if [ -f ~/.config/helix/config.toml ] && [ ! -L ~/.config/helix/config.toml ]; then
    mv ~/.config/helix/config.toml ~/.config/helix/config.toml.backup.$(date +%Y%m%d%H%M%S)
    echo "  config.toml をバックアップしました"
fi
if [ -f ~/.config/helix/languages.toml ] && [ ! -L ~/.config/helix/languages.toml ]; then
    mv ~/.config/helix/languages.toml ~/.config/helix/languages.toml.backup.$(date +%Y%m%d%H%M%S)
    echo "  languages.toml をバックアップしました"
fi
ln -sf "$SCRIPT_DIR/helix/config.toml" ~/.config/helix/config.toml
ln -sf "$SCRIPT_DIR/helix/languages.toml" ~/.config/helix/languages.toml
echo "  Helix設定をシンボリックリンクで配置しました"

# Starship
echo "Starship設定を配置中..."
if [ -f ~/.config/starship.toml ] && [ ! -L ~/.config/starship.toml ]; then
    mv ~/.config/starship.toml ~/.config/starship.toml.backup.$(date +%Y%m%d%H%M%S)
    echo "  starship.toml をバックアップしました"
fi
ln -sf "$SCRIPT_DIR/starship/starship.toml" ~/.config/starship.toml
echo "  Starship設定をシンボリックリンクで配置しました"

# ==========================================================================
# zoxideの初期化
# ==========================================================================

echo ""
echo "=== zoxideを初期化中 ==="
mkdir -p ~/.cache
zoxide init nushell > ~/.cache/zoxide.nu
echo "zoxideを初期化しました"

# ==========================================================================
# デフォルトシェルをNushellに変更
# ==========================================================================

echo ""
echo "=== デフォルトシェルをNushellに設定中 ==="

NU_PATH=$(which nu)

# /etc/shells に追加されているか確認
if ! grep -q "$NU_PATH" /etc/shells; then
    echo "Nushellを /etc/shells に追加します..."
    echo "$NU_PATH" | sudo tee -a /etc/shells
fi

# デフォルトシェルを変更
if [ "$SHELL" != "$NU_PATH" ]; then
    echo "デフォルトシェルをNushellに変更します..."
    chsh -s "$NU_PATH"
    echo "デフォルトシェルを変更しました: $NU_PATH"
else
    echo "デフォルトシェル: すでにNushellです"
fi

# ==========================================================================
# 完了メッセージ
# ==========================================================================

echo ""
echo "=== セットアップ完了 ==="
echo ""
echo "次のステップ:"
echo "1. ターミナルを再起動（または新しいターミナルを開く）"
echo "2. WezTermを起動してNushellが動作することを確認"
echo ""
echo "=== インストールされたツール ==="
echo ""
echo "シェル・ターミナル:"
echo "  nushell   : モダンなシェル（Nushell）"
echo "  wezterm   : GPU加速ターミナル"
echo "  starship  : カスタマイズ可能なプロンプト"
echo ""
echo "エディタ:"
echo "  hx        : Helixエディタ（LSP自動有効）"
echo ""
echo "ファイル操作:"
echo "  z         : 履歴ベースのスマートcd（zoxide）"
echo "  rg        : 高速grep（ripgrep）"
echo "  fd        : 高速find"
echo "  sk        : ファジーファインダー（skim）"
echo "  bat       : シンタックスハイライト付きcat"
echo ""
echo "システム:"
echo "  btop      : リソースモニター"
echo ""
echo "=== 便利なコマンド ==="
echo ""
echo "  skcd      : ファジー検索でディレクトリ移動"
echo "  skhist    : コマンド履歴をファジー検索"
echo "  z <path>  : 履歴から部分一致でディレクトリ移動"
echo ""
echo "詳細は README.md を参照してください"
