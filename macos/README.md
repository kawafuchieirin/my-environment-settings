# macOS システム設定

開発者向けのmacOS設定を自動化するスクリプトです。

## インストール

```bash
cd macos
chmod +x setup.sh
./setup.sh
```

## 適用される設定

### キーボード

| 設定 | 値 | 説明 |
|------|-----|------|
| キーリピート速度 | 高速 | コード編集時の移動が快適に |
| キーリピート遅延 | 短縮 | 押してすぐリピート開始 |
| 長押しアクセント | 無効 | キーリピートを優先 |

### トラックパッド

| 設定 | 値 |
|------|-----|
| タップでクリック | 有効 |
| 3本指ドラッグ | 有効 |
| トラッキング速度 | 高速 |

### Finder

| 設定 | 値 |
|------|-----|
| 隠しファイル | 表示 |
| ファイル拡張子 | 常に表示 |
| パスバー | 表示 |
| ステータスバー | 表示 |
| タイトルバー | フルパス表示 |

### Dock

| 設定 | 値 |
|------|-----|
| 自動非表示 | 有効 |
| アニメーション | 高速 |
| 最近使ったアプリ | 非表示 |
| サイズ | 48px |

### スクリーンショット

| 設定 | 値 |
|------|-----|
| 保存場所 | ~/Desktop/Screenshots |
| ファイル名 | screenshot |
| ウィンドウの影 | 無効 |

## 手動設定が必要な項目

### Caps Lock → Control に変更

1. システム設定 → キーボード
2. 「キーボードショートカット」をクリック
3. 左メニューから「修飾キー」を選択
4. Caps Lock を「Control」に変更

### 推奨アプリ

| アプリ | 説明 | インストール |
|--------|------|--------------|
| [Rectangle](https://rectangleapp.com/) | ウィンドウ管理 | `brew install --cask rectangle` |
| [Karabiner-Elements](https://karabiner-elements.pqrs.org/) | キーリマップ | `brew install --cask karabiner-elements` |

## 便利なキーボードショートカット

### 基本操作

| ショートカット | 説明 |
|---------------|------|
| `Cmd + Space` | Spotlight検索 |
| `Cmd + Tab` | アプリ切り替え |
| `Cmd + `` ` | 同一アプリ内ウィンドウ切り替え |
| `Ctrl + Cmd + Q` | 画面ロック |
| `Cmd + ,` | 環境設定を開く |

### スクリーンショット

| ショートカット | 説明 |
|---------------|------|
| `Cmd + Shift + 3` | 全画面キャプチャ |
| `Cmd + Shift + 4` | 選択範囲キャプチャ |
| `Cmd + Shift + 4 + Space` | ウィンドウキャプチャ |
| `Cmd + Shift + 5` | ツールバー表示 |

### ウィンドウ操作

| ショートカット | 説明 |
|---------------|------|
| `Ctrl + Cmd + F` | フルスクリーン切り替え |
| `Cmd + M` | 最小化 |
| `Cmd + H` | 隠す |
| `Cmd + Option + H` | 他を全て隠す |
| `Cmd + W` | ウィンドウを閉じる |
| `Cmd + Q` | アプリ終了 |

### Finder

| ショートカット | 説明 |
|---------------|------|
| `Cmd + Shift + .` | 隠しファイル表示/非表示 |
| `Cmd + Shift + G` | パスを指定して移動 |
| `Space` | クイックルック |
| `Cmd + Delete` | ゴミ箱に移動 |
| `Cmd + Shift + Delete` | ゴミ箱を空にする |
| `Cmd + I` | 情報を見る |

### テキスト編集

| ショートカット | 説明 |
|---------------|------|
| `Cmd + ←/→` | 行頭/行末に移動 |
| `Option + ←/→` | 単語単位で移動 |
| `Cmd + Shift + ←/→` | 行頭/行末まで選択 |
| `Option + Delete` | 単語を削除 |
| `Cmd + Delete` | 行頭まで削除 |

### Mission Control

| ショートカット | 説明 |
|---------------|------|
| `Ctrl + ↑` | Mission Control |
| `Ctrl + ↓` | アプリケーションウィンドウ |
| `Ctrl + ←/→` | デスクトップ切り替え |
| `F11` | デスクトップを表示 |

## 設定のリセット

特定の設定をデフォルトに戻す場合：

```bash
# キーリピート速度をリセット
defaults delete -g InitialKeyRepeat
defaults delete -g KeyRepeat

# Finderの設定をリセット
defaults delete com.apple.finder AppleShowAllFiles
defaults delete com.apple.finder ShowPathbar

# Dockの設定をリセット
defaults delete com.apple.dock autohide
killall Dock
```

## 全ての設定を確認

```bash
# グローバル設定
defaults read -g

# Finder設定
defaults read com.apple.finder

# Dock設定
defaults read com.apple.dock
```
