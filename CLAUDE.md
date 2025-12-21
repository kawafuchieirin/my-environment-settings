# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

個人のmacOS開発環境設定を管理するリポジトリ。各setup.shは設定ファイルをホームディレクトリにコピーし、必要なツールをHomebrewでインストールする。

## セットアップコマンド

```bash
# ターミナル設定（Homebrew、CLIツール、zshプラグイン、.zshrc配置）
cd terminal && chmod +x setup.sh && ./setup.sh

# macOSシステム設定（defaults writeでキーボード/Finder/Dock設定）
cd macos && chmod +x setup.sh && ./setup.sh

# VS Code設定（settings.json配置、拡張機能インストール）
cd vscode && chmod +x setup.sh && ./setup.sh
```

## 設計方針

### terminal/
- **Oh My Zshなし**: Homebrewでzsh-syntax-highlighting、zsh-autosuggestions、zsh-history-substring-searchを個別インストール
- **ライトテーマ**: 白背景用のFZF_DEFAULT_OPTS配色設定
- **ツール存在チェック**: 各ツールは `command -v` でインストール確認してから設定
- **セクション構成**: .zshrcは「# ===」区切りでセクション分け（基本設定、モダンCLIツール、キーバインド、エイリアス、関数など）

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

### macos/setup.sh を編集する場合
- `defaults write` コマンドで設定を追加
- 設定変更後は対象アプリの再起動コマンドを追加（killall）
- 設定値の確認は `defaults read <domain>` で可能

### vscode/ を編集する場合
- 拡張機能追加は extensions.txt に1行1拡張機能ID形式で追加
- 言語別設定は `[python]` のようなセクションで追加
