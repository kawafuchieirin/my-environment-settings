#!/bin/bash
# =============================================================================
# terminal/setup.sh - zsh環境セットアップスクリプト
# =============================================================================
#
# 概要:
#   zshシェル環境をセットアップするスクリプト。Homebrew経由でCLIツールと
#   zshプラグインをインストールし、設定ファイルをシンボリックリンクで配置。
#
# インストールされるツール:
#   - Nerd Font (JetBrainsMono)
#   - CLIツール: eza, bat, fzf, zoxide, ripgrep, delta, lazygit, tldr, jq
#   - zshプラグイン: syntax-highlighting, autosuggestions, history-substring-search
#   - Atuin: 高機能シェル履歴管理
#   - pyenv: Pythonバージョン管理
#
# 配置される設定ファイル:
#   ~/.zshrc      <- terminal/.zshrc（シンボリックリンク）
#   ~/.gitconfig  <- terminal/.gitconfig（シンボリックリンク）
#
# 使用方法:
#   cd terminal && ./setup.sh
#
# 注意:
#   - 既存の設定ファイルは自動でバックアップされます
#   - .zshrcの配置は確認プロンプトが表示されます
#
# =============================================================================
set -e

echo "=== macOS Terminal セットアップ ==="
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
brew install --cask font-jetbrains-mono-nerd-font

# CLIツールのインストール
echo ""
echo "=== CLIツールをインストール中 ==="
brew install eza bat fzf zoxide ripgrep delta lazygit tldr jq

# fzfのキーバインド設定
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

# zshプラグインのインストール（スタンドアロン）
echo ""
echo "=== zshプラグインをインストール中 ==="

# zsh-syntax-highlighting
if ! brew list zsh-syntax-highlighting &>/dev/null; then
    brew install zsh-syntax-highlighting
    echo "zsh-syntax-highlighting: インストールしました"
else
    echo "zsh-syntax-highlighting: インストール済み"
fi

# zsh-autosuggestions
if ! brew list zsh-autosuggestions &>/dev/null; then
    brew install zsh-autosuggestions
    echo "zsh-autosuggestions: インストールしました"
else
    echo "zsh-autosuggestions: インストール済み"
fi

# zsh-history-substring-search（↑↓キーで部分一致検索）
if ! brew list zsh-history-substring-search &>/dev/null; then
    brew install zsh-history-substring-search
    echo "zsh-history-substring-search: インストールしました"
else
    echo "zsh-history-substring-search: インストール済み"
fi

# Atuin（高機能シェル履歴管理）
echo ""
echo "=== Atuinをインストール中 ==="
if ! command -v atuin &> /dev/null; then
    brew install atuin
    echo "Atuin: インストールしました"
else
    echo "Atuin: インストール済み"
fi

# Python環境（pyenv）のインストール
echo ""
echo "=== pyenvをインストール中 ==="
if ! command -v pyenv &> /dev/null; then
    brew install pyenv pyenv-virtualenv
else
    echo "pyenv: インストール済み"
fi

# 設定ファイルのバックアップとコピー
echo ""
echo "=== 設定ファイルを配置中 ==="
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# .zshrcのバックアップと配置
echo ""
read -p ".zshrcをシンボリックリンクで配置しますか？ (y/N): " copy_zshrc
if [[ "$copy_zshrc" =~ ^[Yy]$ ]]; then
    if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
        mv "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
        echo ".zshrcをバックアップしました"
    fi
    ln -sf "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
    echo ".zshrcをシンボリックリンクで配置しました"
else
    echo ".zshrcの配置をスキップしました"
fi

# .gitconfigのシンボリックリンク配置
if [ -f "$SCRIPT_DIR/.gitconfig" ]; then
    if [ -f "$HOME/.gitconfig" ] && [ ! -L "$HOME/.gitconfig" ]; then
        mv "$HOME/.gitconfig" "$HOME/.gitconfig.backup.$(date +%Y%m%d%H%M%S)"
        echo ".gitconfigをバックアップしました"
    fi
    ln -sf "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig"
    echo ".gitconfigをシンボリックリンクで配置しました"
fi

# ターミナルテーマのインポート案内
echo ""
echo "=== セットアップ完了 ==="
echo ""
echo "次のステップ:"
echo "1. ターミナルを再起動してください"
echo "2. ターミナル > 設定 > プロファイル でフォントを 'JetBrainsMono Nerd Font' に変更"
echo "3. 'Light-Clean.terminal' をダブルクリックしてテーマをインポート"
echo "4. インポートしたテーマをデフォルトに設定"
echo ""
echo "追加したツール:"
echo "- delta: git diffを美しく表示"
echo "- lazygit: 'lg' でGUIのようなgit操作"
echo "- tldr: 'tl <コマンド>' でコマンドの使用例を表示"
echo "- jq: JSONの整形・フィルタリング"