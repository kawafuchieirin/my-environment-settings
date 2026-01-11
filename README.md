# my-environment-settings

macOS開発環境の設定を管理するリポジトリ。新しいMacへの移行時に同じ環境を再現できます。

## クイックスタート

新しいMacで以下のコマンドを実行するだけで環境をセットアップできます：

```bash
# リポジトリをクローン
git clone https://github.com/kawafuchieirin/my-environment-settings.git
cd my-environment-settings

# セットアップを実行（対話モード）
chmod +x setup.sh && ./setup.sh
```

## セットアップオプション

### 対話モード（推奨）

```bash
./setup.sh
```

ウィザード形式で以下を選択できます：
- シェル環境（zsh または Nushell）
- macOSシステム設定の適用
- VS Code設定のセットアップ

### コマンドラインオプション

```bash
# ヘルプを表示
./setup.sh --help

# ドライラン（実際には実行せず、何が行われるかを確認）
./setup.sh --dry-run --all

# zsh環境とmacOS設定をセットアップ
./setup.sh --zsh --macos

# Nushell環境とVS Codeをセットアップ
./setup.sh --nushell --vscode

# すべてをセットアップ（シェルは対話で選択）
./setup.sh --all
```

| オプション | 説明 |
|-----------|------|
| `-h, --help` | ヘルプを表示 |
| `-d, --dry-run` | 実行せずに内容を確認 |
| `-z, --zsh` | zsh環境をセットアップ |
| `-n, --nushell` | Nushell環境をセットアップ |
| `-m, --macos` | macOSシステム設定を適用 |
| `-v, --vscode` | VS Code設定をセットアップ |
| `-a, --all` | すべてをセットアップ |

## ディレクトリ構成

```
.
├── setup.sh              # マスターセットアップスクリプト
├── terminal/             # zsh + モダンCLIツール（従来環境）
├── rust-shell/           # Nushell + Rust製ツール（モダン環境）
├── macos/                # macOSシステム設定
└── vscode/               # VS Code設定
```

## シェル環境の選択

### terminal/ - zsh環境

従来のzshにモダンなCLIツールを組み合わせた環境：

- **シェル**: zsh + Oh My Zshなしのプラグイン構成
- **プロンプト**: Starship（オプション）
- **ツール**: eza, bat, fzf, zoxide, ripgrep, delta, lazygit, tldr
- **Python**: pyenv + pyenv-virtualenv

```bash
# 個別にセットアップする場合
cd terminal && chmod +x setup.sh && ./setup.sh
```

### rust-shell/ - Nushell環境

Rust製ツールで統一したモダンな環境：

- **シェル**: Nushell（構造化データ、Viモード）
- **ターミナル**: WezTerm（Tokyo Nightテーマ）
- **エディタ**: Helix（LSP自動有効）
- **プロンプト**: Starship
- **ツール**: zoxide, ripgrep, fd, skim, bat, btop

```bash
# 個別にセットアップする場合
cd rust-shell && chmod +x setup.sh && ./setup.sh
```

> **注意**: rust-shell/を実行するとデフォルトシェルがNushellに変更されます

## その他の設定

### macos/ - システム設定

`defaults write`でmacOSの各種設定を適用：

- キーボード（キーリピート高速化）
- トラックパッド（タップでクリック、3本指ドラッグ）
- Finder（隠しファイル表示、拡張子表示）
- Dock（自動で隠す、アニメーション高速化）
- スクリーンショット（保存先、ファイル名）

```bash
cd macos && chmod +x setup.sh && ./setup.sh
```

### vscode/ - VS Code設定

settings.json、keybindings.json、拡張機能をセットアップ：

```bash
cd vscode && chmod +x setup.sh && ./setup.sh
```

> **前提条件**: VS Codeが事前にインストールされている必要があります

## 前提条件

- macOS
- Xcode Command Line Tools（未インストールの場合、スクリプトが自動でインストールを促します）
- Git

## バックアップ

各セットアップスクリプトは既存の設定ファイルを上書きする前に、タイムスタンプ付きのバックアップを作成します：

```
~/.zshrc.backup.20240115120000
```

## ライセンス

MIT
