#!/bin/bash
# =============================================================================
# macos/setup.sh - macOSシステム設定スクリプト
# =============================================================================
#
# 概要:
#   macOSのシステム設定を開発者向けにカスタマイズするスクリプト。
#   defaults writeコマンドを使用して設定を変更。
#
# 設定内容:
#   キーボード:
#     - キーリピート速度の高速化
#     - アクセント文字メニュー無効化（キーリピート優先）
#
#   トラックパッド:
#     - タップでクリック有効
#     - 3本指ドラッグ有効
#     - トラッキング速度の高速化
#
#   Finder:
#     - 隠しファイル表示
#     - ファイル拡張子を常に表示
#     - パスバー/ステータスバー表示
#     - ネットワークドライブで.DS_Store作成無効
#
#   Dock:
#     - 自動非表示
#     - アニメーション高速化
#     - 最近使ったアプリ非表示
#
#   スクリーンショット:
#     - 保存先: ~/Desktop/Screenshots
#     - ウィンドウの影を無効化
#
# 使用方法:
#   cd macos && ./setup.sh
#
# 注意:
#   - 一部設定はログアウト/再起動後に反映されます
#   - 起動音の無効化にはsudo権限が必要です
#   - Caps Lock→Controlの変更は手動でシステム設定から行ってください
#
# =============================================================================
set -e

echo "=== macOS キーボード・システム設定 ==="
echo ""

# =============================================================================
# キーボード設定
# =============================================================================

echo "=== キーボード設定を適用中 ==="

# キーリピート速度を高速化（開発者向け）
# InitialKeyRepeat: キーを押してからリピート開始までの遅延（小さいほど速い）
# KeyRepeat: リピート間隔（小さいほど速い）
defaults write -g InitialKeyRepeat -int 15  # デフォルト: 25 (375ms)
defaults write -g KeyRepeat -int 2          # デフォルト: 6 (90ms)
echo "キーリピート速度: 高速化しました"

# 長押しでアクセント文字を表示する代わりにキーリピートを有効化
defaults write -g ApplePressAndHoldEnabled -bool false
echo "キーリピート: 有効化しました（アクセント文字メニュー無効）"

# Caps LockキーをControlキーに変更する案内
echo ""
echo "[手動設定] Caps Lock → Control に変更推奨："
echo "  システム設定 → キーボード → キーボードショートカット → 修飾キー"

# =============================================================================
# トラックパッド設定
# =============================================================================

echo ""
echo "=== トラックパッド設定を適用中 ==="

# タップでクリック
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
echo "タップでクリック: 有効"

# 3本指ドラッグ（アクセシビリティ設定）
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
echo "3本指ドラッグ: 有効"

# トラッキング速度を上げる（0.0〜3.0、デフォルト: 1.0）
defaults write -g com.apple.trackpad.scaling -float 2.0
echo "トラッキング速度: 高速化"

# =============================================================================
# Finder設定
# =============================================================================

echo ""
echo "=== Finder設定を適用中 ==="

# 隠しファイルを表示
defaults write com.apple.finder AppleShowAllFiles -bool true
echo "隠しファイル: 表示"

# ファイル拡張子を常に表示
defaults write -g AppleShowAllExtensions -bool true
echo "ファイル拡張子: 常に表示"

# パスバーを表示
defaults write com.apple.finder ShowPathbar -bool true
echo "パスバー: 表示"

# ステータスバーを表示
defaults write com.apple.finder ShowStatusBar -bool true
echo "ステータスバー: 表示"

# フルパスをタイトルバーに表示
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
echo "タイトルバー: フルパス表示"

# 検索時にデフォルトでカレントディレクトリを検索
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
echo "検索スコープ: カレントディレクトリ"

# .DS_Store ファイルをネットワークドライブに作成しない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
echo ".DS_Store: ネットワークドライブで無効"

# =============================================================================
# Dock設定
# =============================================================================

echo ""
echo "=== Dock設定を適用中 ==="

# Dockを自動的に隠す
defaults write com.apple.dock autohide -bool true
echo "Dock自動非表示: 有効"

# Dock表示/非表示のアニメーション速度
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.3
echo "Dockアニメーション: 高速化"

# 最近使ったアプリをDockに表示しない
defaults write com.apple.dock show-recents -bool false
echo "最近使ったアプリ: 非表示"

# Dockのサイズ
defaults write com.apple.dock tilesize -int 48
echo "Dockサイズ: 48px"

# =============================================================================
# スクリーンショット設定
# =============================================================================

echo ""
echo "=== スクリーンショット設定を適用中 ==="

# スクリーンショットの保存場所
SCREENSHOT_DIR="$HOME/Desktop/Screenshots"
mkdir -p "$SCREENSHOT_DIR"
defaults write com.apple.screencapture location -string "$SCREENSHOT_DIR"
echo "保存場所: $SCREENSHOT_DIR"

# スクリーンショットのファイル名から日時を除去
defaults write com.apple.screencapture name -string "screenshot"
echo "ファイル名: screenshot"

# 影を無効化
defaults write com.apple.screencapture disable-shadow -bool true
echo "ウィンドウの影: 無効"

# =============================================================================
# その他
# =============================================================================

echo ""
echo "=== その他の設定を適用中 ==="

# クラッシュレポートを通知センターに表示しない
defaults write com.apple.CrashReporter DialogType -string "none"
echo "クラッシュレポート: 無効"

# 起動音を無効化
sudo nvram StartupMute=%01 2>/dev/null || echo "起動音の設定にはsudo権限が必要です"

# =============================================================================
# 設定の反映
# =============================================================================

echo ""
echo "=== 設定を反映中 ==="

# Finderを再起動
killall Finder 2>/dev/null || true
echo "Finder: 再起動しました"

# Dockを再起動
killall Dock 2>/dev/null || true
echo "Dock: 再起動しました"

# SystemUIServerを再起動（スクリーンショット設定反映）
killall SystemUIServer 2>/dev/null || true
echo "SystemUIServer: 再起動しました"

echo ""
echo "=== セットアップ完了 ==="
echo ""
echo "一部の設定を完全に反映するには、ログアウト/ログインが必要です。"
echo ""
echo "=== 便利なキーボードショートカット ==="
echo ""
echo "基本操作:"
echo "  Cmd + Space      : Spotlight検索"
echo "  Cmd + Tab        : アプリ切り替え"
echo "  Cmd + \`          : 同一アプリ内ウィンドウ切り替え"
echo "  Ctrl + Cmd + Q   : 画面ロック"
echo ""
echo "スクリーンショット:"
echo "  Cmd + Shift + 3  : 全画面"
echo "  Cmd + Shift + 4  : 選択範囲"
echo "  Cmd + Shift + 5  : ツールバー表示"
echo ""
echo "ウィンドウ:"
echo "  Ctrl + Cmd + F   : フルスクリーン切り替え"
echo "  Cmd + M          : 最小化"
echo "  Cmd + H          : 隠す"
echo ""
echo "Finder:"
echo "  Cmd + Shift + .  : 隠しファイル表示/非表示"
echo "  Cmd + Shift + G  : パスを指定して移動"
echo "  Space            : クイックルック"
