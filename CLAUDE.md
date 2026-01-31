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

### ローカル設定（機密情報の分離）

個人PC/会社PCで異なる設定（APIキー、社内ツールなど）は**ローカル設定ファイル**に記載:

| シェル | ローカル設定ファイル | テンプレート |
|-------|-------------------|-------------|
| zsh | `terminal/.zshrc.local` | `.zshrc.local.example` |
| Nushell | `rust-shell/nushell/local.nu` | `local.nu.example` |

**これらのファイルは`.gitignore`に含まれ、コミットされません。**

セットアップ手順:
```bash
# zsh
cp terminal/.zshrc.local.example terminal/.zshrc.local
vim terminal/.zshrc.local

# Nushell
cp rust-shell/nushell/local.nu.example rust-shell/nushell/local.nu
hx rust-shell/nushell/local.nu
```

ローカル設定に含めるべき情報:
- APIキー（AWS、GitHub、OpenAI等）
- データベース接続情報
- 社内サーバーのSSH設定
- VPN接続コマンド
- 社内ツールへのエイリアス

### terminal/
- **Oh My Zshなし**: Homebrewで個別にプラグインをインストール（zsh-syntax-highlighting、zsh-autosuggestions、zsh-history-substring-search）
- **ライトテーマ**: FZF_DEFAULT_OPTSは白背景用の配色
- **ツール存在チェック**: 各ツールは `command -v` でインストール確認してから設定
- **セクション構成**: .zshrcは「# ===」区切りでセクション分け

### rust-shell/
- **Rust製ツール統一**: Nushell、WezTerm、Helix、Starship、zoxide、ripgrep、fd、skim、bat、btop
- **設定ファイル配置先**:
  - Nushell: `~/Library/Application Support/nushell/`（macOS固有のパス）
  - その他: `~/.config/` 配下（wezterm/, helix/, starship.toml）
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

## 重要: zshとNushellの設定同期ルール

**エイリアス、環境変数、PATH、関数を変更する場合は、必ず以下の3ファイルを同時に更新すること。**

### 同時更新が必要なファイル

| 設定項目 | zsh | Nushell | 共通定義 |
|---------|-----|---------|---------|
| エイリアス | `terminal/.zshrc` | `rust-shell/nushell/config.nu` | `shared/config.yaml` |
| 環境変数 | `terminal/.zshrc` | `rust-shell/nushell/env.nu` | `shared/config.yaml` |
| PATH | `terminal/.zshrc` | `rust-shell/nushell/env.nu` | `shared/config.yaml` |
| 関数 | `terminal/.zshrc` | `rust-shell/nushell/config.nu` | `shared/config.yaml` |

### 共通設定一覧（shared/config.yaml）

`shared/config.yaml`は**単一の信頼できる情報源（Single Source of Truth）**です。

#### 共通エイリアス（必須で両方に存在すること）

```yaml
# ファイル操作
ll, la, cat, grep

# Git
g, gs, ga, gc, gp, gl, gd, lg

# Python
py, py3, pip, venv

# その他
c, h, x, tl, j, rdock, pbp, pbc, cc, C
```

#### 共通関数（必須で両方に存在すること）

```yaml
mkcd, groot, cpwd, weather, cheat, extract, timer, ip, localip, ports, duh, duf
```

#### 共通PATH（優先度順）

```yaml
- $HOME/.local/bin
- $HOME/npm-global/bin
- $HOME/.pyenv/shims
- $HOME/.pyenv/bin
- $HOME/.cargo/bin
- /opt/homebrew/opt/fzf/bin
- /opt/homebrew/bin
- /opt/homebrew/sbin
```

#### 共通環境変数

```yaml
LANG: ja_JP.UTF-8
EDITOR: vim (zsh) / hx (nushell)
PYENV_ROOT: $HOME/.pyenv
```

### 変更手順

1. `shared/config.yaml`に変更を追加
2. `terminal/.zshrc`に変更を反映（zsh構文）
3. `rust-shell/nushell/config.nu`または`env.nu`に変更を反映（Nushell構文）
4. 両方のhelp関数を更新（該当する場合）

### 構文の違い

| 項目 | zsh | Nushell |
|-----|-----|---------|
| エイリアス | `alias name='cmd'` | `alias name = cmd` |
| 関数 | `func() { ... }` | `def func [] { ... }` |
| 環境変数 | `export VAR=value` | `$env.VAR = value` |
| 条件分岐 | `if cmd; then ... fi` | `if condition { ... }` |

---

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

### rust-shell/nushell/（機能別に分割）

ファイル構成:
```
nushell/
├── config.nu     # メイン設定（$env.configと各ファイルのsource）
├── env.nu        # 環境変数・PATH
├── aliases.nu    # エイリアス定義
├── functions.nu  # カスタム関数
├── help.nu       # ヘルプコマンド
└── local.nu      # ローカル設定（gitignore）
```

編集ガイドライン:
- **エイリアス追加**: `aliases.nu` に `alias name = command` 形式で追加
- **関数追加**: `functions.nu` に `def funcname [] { ... }` 形式で追加
- **環境変数を変更する関数**: `def --env funcname [] { ... }` を使用
- **パイプ用コマンド**: `def G [pattern: string] { rg $pattern }` のように引数の型を明示
- **ヘルプ更新**: `help.nu` の該当関数を更新

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
