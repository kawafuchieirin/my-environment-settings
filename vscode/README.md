# VS Code 設定

開発効率を上げるVS Code設定です。

## インストール

```bash
cd vscode
chmod +x setup.sh
./setup.sh
```

## 含まれる設定

### エディタ

| 設定 | 値 |
|------|-----|
| フォント | JetBrainsMono Nerd Font |
| フォントサイズ | 14px |
| リガチャ | 有効（`===` → `≡` など） |
| 自動保存 | 1秒後に自動保存 |
| 保存時フォーマット | 有効 |
| ミニマップ | 無効 |
| サイドバー | 右側 |

### 言語別設定

| 言語 | フォーマッター | タブサイズ |
|------|---------------|-----------|
| Python | Black | 4 |
| JavaScript/TypeScript | Prettier | 2 |
| JSON | Prettier | 2 |

## キーボードショートカット

### ファイル操作

| ショートカット | 説明 |
|---------------|------|
| `Cmd + P` | ファイル検索 |
| `Cmd + Shift + P` | コマンドパレット |
| `Cmd + Shift + F` | プロジェクト内検索 |
| `Cmd + Shift + H` | プロジェクト内置換 |
| `Cmd + B` | サイドバー表示/非表示 |
| `Cmd + J` | パネル表示/非表示 |

### 編集

| ショートカット | 説明 |
|---------------|------|
| `Cmd + D` | 次の同じ単語を選択（マルチカーソル） |
| `Cmd + Shift + L` | 同じ単語を全て選択 |
| `Alt + ↑/↓` | 行を上下に移動 |
| `Cmd + Shift + D` | 行を複製 |
| `Cmd + Shift + K` | 行を削除 |
| `Cmd + /` | コメント切り替え |

### コード操作

| ショートカット | 説明 |
|---------------|------|
| `F2` | 名前変更（リファクタリング） |
| `F12` | 定義に移動 |
| `Shift + Alt + F` | ドキュメント全体をフォーマット |
| `Cmd + .` | クイックフィックス |

### ターミナル

| ショートカット | 説明 |
|---------------|------|
| `` Ctrl + ` `` | ターミナル表示/非表示 |
| `` Ctrl + Shift + ` `` | 新しいターミナル |

### 分割エディタ

| ショートカット | 説明 |
|---------------|------|
| `Cmd + \` | エディタを分割 |
| `Cmd + 1/2/3` | エディタグループにフォーカス |

## 拡張機能

### 必須

| 拡張機能 | 説明 |
|---------|------|
| Prettier | コードフォーマッター |
| ESLint | JavaScript/TypeScriptリンター |
| GitLens | Git履歴・blame表示 |
| Error Lens | エラーをインラインで表示 |

### Python

| 拡張機能 | 説明 |
|---------|------|
| Python | Python言語サポート |
| Pylance | 型チェック・補完 |
| Black Formatter | Pythonフォーマッター |
| isort | インポート整理 |

### エディタ強化

| 拡張機能 | 説明 |
|---------|------|
| Path Intellisense | ファイルパス補完 |
| Auto Rename Tag | HTMLタグの自動リネーム |
| Better Comments | コメントをカラフルに |
| Material Icon Theme | ファイルアイコン |

### Git

| 拡張機能 | 説明 |
|---------|------|
| Git Graph | Gitブランチをグラフ表示 |

## 拡張機能の個別インストール

```bash
# 全てインストール
cat extensions.txt | grep -v '^#' | grep -v '^$' | xargs -L 1 code --install-extension

# 個別インストール
code --install-extension esbenp.prettier-vscode
code --install-extension ms-python.python
```

## カスタマイズ

### テーマの変更

```json
{
    "workbench.colorTheme": "One Dark Pro"
}
```

人気のテーマ:
- `One Dark Pro`
- `GitHub Theme`
- `Tokyo Night`
- `Dracula`

### フォントサイズの変更

```json
{
    "editor.fontSize": 16,
    "terminal.integrated.fontSize": 14
}
```

## ファイル構成

```
vscode/
├── setup.sh          # インストールスクリプト
├── settings.json     # エディタ設定
├── keybindings.json  # キーボードショートカット
├── extensions.txt    # 拡張機能リスト
├── REFERENCES.md     # 参考サイト
└── README.md         # このファイル
```
