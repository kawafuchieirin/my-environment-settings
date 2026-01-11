# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

個人のmacOS開発環境設定を管理するリポジトリ。各setup.shは設定ファイルをホームディレクトリにコピーし、必要なツールをHomebrewでインストールする。

2つのシェル環境を提供:
- **terminal/**: zsh + モダンCLIツール（従来環境）
- **rust-shell/**: Nushell + Rust製ツール（モダン環境）

## セットアップコマンド

```bash
# ターミナル設定（Homebrew、CLIツール、zshプラグイン、.zshrc配置）
cd terminal && chmod +x setup.sh && ./setup.sh

# Rust Shell設定（Nushell、WezTerm、Helix、Starship）
cd rust-shell && chmod +x setup.sh && ./setup.sh

# macOSシステム設定（defaults writeでキーボード/Finder/Dock設定）
cd macos && chmod +x setup.sh && ./setup.sh

# VS Code設定（settings.json配置、拡張機能インストール）
cd vscode && chmod +x setup.sh && ./setup.sh
```

**注意**: terminal/ と rust-shell/ はどちらか一方を選択。rust-shell/を実行するとデフォルトシェルがNushellに変更される。

## 設計方針

### terminal/
- **Oh My Zshなし**: Homebrewでzsh-syntax-highlighting、zsh-autosuggestions、zsh-history-substring-searchを個別インストール
- **ライトテーマ**: 白背景用のFZF_DEFAULT_OPTS配色設定
- **ツール存在チェック**: 各ツールは `command -v` でインストール確認してから設定
- **セクション構成**: .zshrcは「# ===」区切りでセクション分け（基本設定、モダンCLIツール、キーバインド、エイリアス、関数など）

### rust-shell/
- **Rust製ツール統一**: Nushell、WezTerm、Helix、Starship、zoxide、ripgrep、fd、skim、bat
- **設定ファイル配置先**: `~/.config/` 配下（nushell/, wezterm/, helix/, starship.toml）
- **Tokyo Nightテーマ**: WezTermとHelixで統一されたカラースキーム
- **Viモード**: NushellとHelixでViライクな操作が可能
- **LSP自動有効**: Helixは設定不要でLanguage Serverが動作

### macos/
- **defaults write**: すべての設定をスクリプトで再現可能に
- **設定反映**: 変更後に `killall Finder/Dock/SystemUIServer` で即時反映

### vscode/
- **設定ファイル配置先**: `~/Library/Application Support/Code/User/`
- **extensions.txt**: 拡張機能リスト（コメント行は `#` 開始）

## 設定ファイルの編集ガイドライン

### .zshrc を編集する場合
- エイリアスは既存のセクション（Git、Python、ディレクトリ操作など）の適切な場所に追加
- 新しいツールは `command -v` でインストールチェックしてからエイリアス設定
- 関数は `# 関数` セクションに追加
- グローバルエイリアス（パイプ用）は `alias -g` を使用
- サフィックスエイリアス（拡張子用）は `alias -s` を使用

### rust-shell/ を編集する場合
- **nushell/config.nu**: エイリアスは `alias` セクション、関数は `def` で定義
- **nushell/env.nu**: 環境変数とPATH設定
- **wezterm/wezterm.lua**: Lua形式、キーバインドは `config.keys` テーブルに追加
- **helix/config.toml**: TOML形式、キーバインドは `[keys.normal]` セクションに追加
- **helix/languages.toml**: 言語サーバーとフォーマッター設定
- **starship/starship.toml**: プロンプト表示設定

### macos/setup.sh を編集する場合
- `defaults write` コマンドで設定を追加
- 設定変更後は対象アプリの再起動コマンドを追加（killall）
- 設定値の確認は `defaults read <domain>` で可能

### vscode/ を編集する場合
- 拡張機能追加は extensions.txt に1行1拡張機能ID形式で追加
- 言語別設定は `[python]` のようなセクションで追加
