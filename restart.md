# 設定ファイル変更後の反映手順

このドキュメントでは、各設定ファイルを変更した後に反映させる方法をまとめています。

## 概要

| 設定ファイル | 反映方法 | 備考 |
|-------------|---------|------|
| terminal/.zshrc | 新規ターミナル or `source` | シンボリックリンク |
| terminal/.gitconfig | 即時反映 | シンボリックリンク |
| rust-shell/nushell/*.nu | 新規セッション or `source` | シンボリックリンク |
| rust-shell/wezterm/wezterm.lua | 自動反映 | 保存のみでOK |
| rust-shell/helix/*.toml | Helix再起動 | `:config-reload` も可 |
| rust-shell/starship/starship.toml | 次回プロンプト表示時 | 自動反映 |
| macos/setup.sh | スクリプト実行 | アプリ再起動が必要 |
| vscode/ | setup.sh実行 + VS Code再起動 | コピー方式 |

---

## terminal/ (zsh環境)

### .zshrc

シンボリックリンク方式のため、リポジトリ内のファイルを編集すると即座に反映準備が整います。

**反映方法（以下のいずれか）:**

```bash
# 方法1: 現在のセッションに反映
source ~/.zshrc

# 方法2: 新しいターミナルウィンドウ/タブを開く
```

**注意:** `source`で反映できない変更（PATH初期化など）は新規ターミナルを開いてください。

### .gitconfig

Gitは設定ファイルを毎回読み込むため、**保存するだけで即時反映**されます。

```bash
# 設定が反映されているか確認
git config --list
```

---

## rust-shell/ (Nushell環境)

### nushell/config.nu

**反映方法（以下のいずれか）:**

```nu
# 方法1: 現在のセッションに反映
source $nu.config-path

# 方法2: 新しいNushellセッションを開く
```

### nushell/env.nu

環境変数の設定は起動時に読み込まれるため、**新しいNushellセッションを開く**必要があります。

```nu
# 新しいセッションを開く（WezTermで新規タブ: Ctrl+Shift+T）
```

### wezterm/wezterm.lua

WezTermは設定ファイルの変更を監視しているため、**保存するだけで自動反映**されます。再起動は不要です。

```bash
# 変更が反映されない場合のみ、WezTermを再起動
# macOSの場合: Cmd+Q で終了して再度開く
```

### helix/config.toml, languages.toml

**反映方法（以下のいずれか）:**

```
# 方法1: Helix内で設定を再読み込み
:config-reload

# 方法2: Helixを再起動
:quit して再度 hx を実行
```

**注意:** 一部の設定（テーマなど）は再起動が必要な場合があります。

### starship/starship.toml

Starshipはプロンプト表示のたびに設定を読み込むため、**次のコマンド実行後に自動反映**されます。

```bash
# Enterを押すだけで新しいプロンプトに反映
```

---

## macos/ (システム設定)

macOSのシステム設定は`defaults write`で変更後、対象アプリケーションの再起動が必要です。

### 反映方法

```bash
# スクリプト全体を再実行
cd macos && ./setup.sh

# または個別に反映（変更した設定に応じて）
killall Finder          # Finder設定
killall Dock            # Dock設定
killall SystemUIServer  # メニューバー設定
```

### 設定カテゴリ別の再起動コマンド

| カテゴリ | 再起動コマンド |
|---------|---------------|
| Finder | `killall Finder` |
| Dock | `killall Dock` |
| メニューバー | `killall SystemUIServer` |
| キーボード | ログアウト/再ログイン |
| トラックパッド | 即時反映 or ログアウト |

---

## vscode/ (VS Code設定)

VS Codeの設定は**コピー方式**のため、リポジトリ内の変更を手動で反映する必要があります。

### 反映方法

```bash
# 方法1: セットアップスクリプトを再実行
cd vscode && ./setup.sh

# 方法2: 手動でコピー
cp vscode/settings.json ~/Library/Application\ Support/Code/User/
cp vscode/keybindings.json ~/Library/Application\ Support/Code/User/
```

### 拡張機能の追加

```bash
# extensions.txtに追加後、スクリプトで一括インストール
cd vscode && ./setup.sh

# または個別にインストール
code --install-extension 拡張機能ID
```

### VS Codeの再読み込み

設定ファイルをコピーした後:

- **コマンドパレット**（Cmd+Shift+P）→ `Developer: Reload Window`
- または VS Codeを再起動

---

## ローカル設定（機密情報）

個人PC/会社PCで異なる設定は、ローカル設定ファイルに記載します。
これらのファイルは`.gitignore`に含まれ、コミットされません。

### セットアップ

```bash
# zsh（初回のみ）
cp terminal/.zshrc.local.example terminal/.zshrc.local
vim terminal/.zshrc.local

# Nushell（初回のみ）
cp rust-shell/nushell/local.nu.example rust-shell/nushell/local.nu
hx rust-shell/nushell/local.nu
```

### 反映方法

| ファイル | 反映方法 |
|---------|---------|
| `.zshrc.local` | `source ~/.zshrc` または新規ターミナル |
| `local.nu` | 新規Nushellセッション |

### 記載する内容の例

- APIキー（AWS、GitHub、OpenAI等）
- データベース接続URL
- 社内サーバーのSSH設定
- VPN接続コマンド
- 社内ツールへのエイリアス

---

## トラブルシューティング

### 変更が反映されない場合

1. **シンボリックリンクの確認**
   ```bash
   ls -la ~/.zshrc  # リポジトリを指しているか確認
   ```

2. **シンタックスエラーの確認**
   ```bash
   # zshの場合
   zsh -n ~/.zshrc

   # Nushellの場合
   nu -c "source $nu.config-path"
   ```

3. **キャッシュのクリア**（Starshipの場合）
   ```bash
   starship init nu --print-full-init | save -f ~/.cache/starship/init.nu
   ```

### シンボリックリンクが切れている場合

```bash
# 再度セットアップスクリプトを実行
./setup.sh
```
