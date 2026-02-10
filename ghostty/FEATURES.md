# Ghostty 機能まとめ

Mitchell Hashimoto（HashiCorp共同創業者）が開発した高速・高機能・ネイティブUIを兼ね備えたターミナルエミュレータ。

## 特徴

- **ネイティブUI**: macOSではSwift/AppKit、LinuxではGTK4を使用し、各プラットフォームに最適化
- **GPU加速レンダリング**: macOSではMetal、LinuxではOpenGLを使用
- **高速**: 起動時間、スクロール速度、IO処理すべてにおいて最速クラス
- **オープンソース**

## 主な機能

### ウィンドウ管理

- 複数ウィンドウ / タブ / 画面分割（上下左右）
- 分割のズーム切り替え（1つの分割を全画面表示）
- 分割サイズのリサイズ、均等化
- ウィンドウ状態の保存・復元（macOS）

### フォント

- フォントファミリー指定（通常/太字/イタリック個別設定可）
- 可変フォント（Variable Font）のバリエーション軸指定
- OpenType Feature制御、リガチャサポート
- コードポイント別フォントマッピング

### テーマ・カラー

- 数百の組み込みテーマを搭載
- ライト/ダークモード別テーマ設定（例: `theme = light:Catppuccin Latte,dark:Catppuccin Mocha`）
- システムのダークモード切り替えに自動追従
- 背景色、前景色、256色パレットの個別設定

### 背景のカスタマイズ

- 背景透過度（`background-opacity`）
- 背景ブラー効果（`background-blur`）
- 背景画像の設定（PNG/JPEG）

### キーバインド

- `keybind = trigger=action` 形式でカスタム設定
- 修飾キー: `shift`, `ctrl`, `alt`(`opt`), `super`(`cmd`)
- グローバルキーバインド対応（macOS、`global:`プリフィックス）
- コマンドパレット

### クリップボード

- 選択時自動コピー（`copy-on-select`）
- 末尾空白の自動トリム
- ペースト保護（安全でない文字列の警告）

### シェル統合

対応シェル: bash, zsh, fish, elvish

| 機能 | 説明 |
|------|------|
| プロンプト検出 | プロンプト位置でのターミナル閉鎖時に確認省略 |
| ディレクトリ記憶 | 新規タブが前回のワーキングディレクトリで起動 |
| コマンド出力選択 | Cmd+トリプルクリックで出力全体を選択 |
| プロンプトジャンプ | 前後のプロンプト間を移動 |
| Alt+クリック移動 | プロンプト位置からクリック位置へカーソル移動 |

設定例:

```
shell-integration = zsh        # 特定シェルを指定
shell-integration = detect     # 自動検出（デフォルト）
shell-integration = none       # 無効化
```

### macOS固有の機能

| 機能 | 説明 |
|------|------|
| Quick Terminal | グローバルホットキーで呼び出すドロップダウン式ターミナル |
| Quick Look | Force Touchで定義や検索が可能 |
| プロキシアイコン | タイトルバーのアイコンをドラッグしてファイル操作 |
| セキュアキーボード入力 | パスワード入力の自動検出と保護 |
| Display P3色空間 | sRGBに加えてDisplay P3をサポート |

Quick Terminalの設定例:

```
quick-terminal-position = top
quick-terminal-size = 50%
quick-terminal-animation-duration = 0.2
quick-terminal-autohide = true
```

### その他

- Kittyグラフィクスプロトコル（画像のインライン表示）
- Kittyキーボードプロトコル
- ハイパーリンク対応
- 広範なVT互換性（xterm互換重視）

## 設定カテゴリ一覧

設定ファイル: `~/.config/ghostty/config`（key=value形式）

| カテゴリ | 主な設定項目 |
|---------|-------------|
| フォント | `font-family`, `font-size`, `font-style`, `font-variation`, `font-feature` |
| カラー/テーマ | `theme`, `background`, `foreground`, `palette`, `cursor-color` |
| ウィンドウ | `window-width`, `window-height`, `window-padding-*`, `window-decoration`, `fullscreen` |
| カーソル | `cursor-style`, `cursor-style-blink`, `cursor-opacity` |
| マウス | `mouse-hide-while-typing`, `mouse-scroll-multiplier`, `focus-follows-mouse` |
| スクロール | `scrollback-limit`, `scroll-to-bottom` |
| クリップボード | `clipboard-read`, `clipboard-write`, `copy-on-select`, `clipboard-paste-protection` |
| キーバインド | `keybind`（複数定義可） |
| シェル統合 | `shell-integration`, `shell-integration-features` |
| 背景 | `background-opacity`, `background-blur`, `background-image` |
| Quick Terminal | `quick-terminal-position`, `quick-terminal-size`, `quick-terminal-screen` |

設定の実行時リロード: `Cmd+Shift+,`

## 参考リンク

- 公式サイト: https://ghostty.org/
- ドキュメント: https://ghostty.org/docs
- 設定リファレンス: https://ghostty.org/docs/config/reference
- GitHub: https://github.com/ghostty-org/ghostty
