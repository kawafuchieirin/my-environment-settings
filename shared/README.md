# Shared 設定

zshのエイリアス・環境変数・PATHの定義ファイル。シェル設定の単一の信頼できる情報源（Single Source of Truth）として機能する。

## ファイル構成

| ファイル | 説明 |
|---------|------|
| `config.yaml` | 共通設定をYAML形式で定義 |

## 設定内容

### 環境変数

| 変数 | 値 | 用途 |
|-----|-----|------|
| `LANG` | `ja_JP.UTF-8` | ロケール設定 |
| `EDITOR` | `hx` | デフォルトエディタ（Helix） |

### PATH

優先度順に以下のパスを定義:

1. `$HOME/.local/bin`
2. `$HOME/.cargo/bin`
3. `/opt/homebrew/bin`
4. `/opt/homebrew/sbin`

### エイリアス

| エイリアス | コマンド | 用途 |
|-----------|---------|------|
| `ll` | `ls -lah` | 詳細リスト表示 |
| `la` | `ls -A` | 隠しファイル含む一覧 |
| `g` | `git` | Git短縮 |
| `gs` | `git status` | ステータス確認 |
| `ga` | `git add` | ステージング |
| `gc` | `git commit` | コミット |
| `gp` | `git push` | プッシュ |
| `gl` | `git log --oneline` | ログ一覧 |
| `gd` | `git diff` | 差分表示 |
| `c` | `clear` | 画面クリア |

## 使い方

エイリアスや環境変数を追加・変更する際は、まず `config.yaml` を更新し、その内容に合わせて `zsh/.zshrc` を同期する。

### 設定追加の流れ

1. `config.yaml` に定義を追加
2. `zsh/.zshrc` にzsh形式で反映

```yaml
# config.yaml への追加例
aliases:
  dk: docker
  dkc: docker compose
```

```bash
# zsh/.zshrc への反映
alias dk='docker'
alias dkc='docker compose'
```
