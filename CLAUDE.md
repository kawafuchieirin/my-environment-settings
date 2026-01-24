# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

個人のmacOS開発環境設定を管理するリポジトリ。各setup.shは設定ファイルをホームディレクトリにシンボリックリンクで配置し、必要なツールをHomebrewでインストールする。

2つのシェル環境を提供（どちらか一方を選択）:
- **terminal/**: zsh + モダンCLIツール（従来環境）
- **rust-shell/**: Nushell + Rust製ツール（モダン環境）- デフォルトシェルがNushellに変更される

## セットアップコマンド

```bash
# マスターセットアップ（対話モードで環境選択）
./setup.sh

# オプション付き実行
./setup.sh --dry-run --all    # ドライランで確認
./setup.sh --zsh --macos      # zsh環境とmacOS設定
./setup.sh --nushell --vscode # Nushell環境とVS Code

# 個別セットアップ
cd terminal && ./setup.sh     # zsh環境
cd rust-shell && ./setup.sh   # Nushell環境
cd macos && ./setup.sh        # macOSシステム設定
cd vscode && ./setup.sh       # VS Code設定
```

## アーキテクチャ

### 設定ファイルの配置方式
- **シンボリックリンク方式**: 設定ファイルはリポジトリから直接リンクされるため、リポジトリ内の編集が即座に反映される
- **バックアップ自動作成**: 既存の設定ファイルは `.backup.YYYYMMDDHHMMSS` 形式でバックアップ

### terminal/
- **Oh My Zshなし**: Homebrewで個別にプラグインをインストール（zsh-syntax-highlighting、zsh-autosuggestions、zsh-history-substring-search）
- **ライトテーマ**: FZF_DEFAULT_OPTSは白背景用の配色
- **ツール存在チェック**: 各ツールは `command -v` でインストール確認してから設定
- **セクション構成**: .zshrcは「# ===」区切りでセクション分け

### rust-shell/
- **Rust製ツール統一**: Nushell、WezTerm、Helix、Starship、zoxide、ripgrep、fd、skim、bat、btop
- **設定ファイル配置先**: `~/.config/` 配下（nushell/, wezterm/, helix/, starship.toml）
- **Draculaテーマ**: WezTermで使用、Helixはデフォルトテーマ
- **Viモード**: NushellとHelixでViライクな操作（`edit_mode: vi`）
- **LSP自動有効**: Helixは設定不要でLanguage Serverが動作
- **起動シェル**: WezTermは `/opt/homebrew/bin/nu --login` でNushellを起動

### macos/
- **defaults write**: すべての設定をスクリプトで再現可能に
- **設定反映**: 変更後に `killall Finder/Dock/SystemUIServer` で即時反映

### vscode/
- **設定ファイル配置先**: `~/Library/Application Support/Code/User/`（コピー方式、シンボリックリンクではない）
- **extensions.txt**: 拡張機能リスト（コメント行は `#` 開始）

## 設定ファイルの編集ガイドライン

### terminal/.zshrc
- エイリアスは既存のセクション（Git、Python、ディレクトリ操作など）の適切な場所に追加
- 新しいツールは `command -v` でインストールチェックしてから設定:
  ```bash
  if command -v newtool &> /dev/null; then
      alias nt='newtool'
  fi
  ```
- 関数は `# 関数` セクション（`# ===` で区切られた部分）に追加
- グローバルエイリアス（パイプ用）は `alias -g` を使用
- サフィックスエイリアス（拡張子用）は `alias -s` を使用
- ヘルプテキストを追加する場合は `help()` 関数内のヒアドキュメントを更新

### rust-shell/nushell/config.nu
- エイリアス: `alias name = command` 形式で追加
- 関数: `def funcname [] { ... }` 形式で定義
- 環境変数を変更する関数: `def --env funcname [] { ... }` を使用
- パイプ用コマンド: `def G [pattern: string] { rg $pattern }` のように引数の型を明示

### rust-shell/wezterm/wezterm.lua
- キーバインド追加: `config.keys` テーブルに新しいエントリを追加
- カスタムイベント: `wezterm.on('event-name', function(window, pane) ... end)` で定義
- 設定変更は保存だけで自動反映（再起動不要）

### rust-shell/helix/
- **config.toml**: エディタ設定、キーバインドは `[keys.normal]` セクションに追加
- **languages.toml**: 言語サーバーとフォーマッター設定

### macos/setup.sh
- `defaults write` コマンドで設定を追加
- 設定変更後は対象アプリの再起動コマンドを追加（`killall Finder` 等）
- 設定値の確認: `defaults read <domain>` で現在値を確認可能

### vscode/
- **settings.json**: 言語別設定は `"[python]": { ... }` のようなセクションで追加
- **extensions.txt**: 1行1拡張機能ID形式（`#` で始まる行はコメント）
- **keybindings.json**: カスタムキーバインド

### setup.sh（新規ツール追加時）
各ディレクトリのsetup.shでツールを追加する場合:
- `brew install` コマンドに追加
- 設定ファイルのシンボリックリンク作成を追加（該当する場合）
- 完了メッセージに説明を追加
