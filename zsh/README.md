# zsh 設定

zshシェルのカスタム設定ファイル。

## ファイル構成

| ファイル | 説明 |
|---------|------|
| `.zshrc` | zshのメイン設定ファイル |
| `.zshrc.local` | ローカル専用設定（gitignore対象） |

## 設定内容

### 環境変数

- `LANG=ja_JP.UTF-8`
- `EDITOR=hx`

### PATH

以下のパスを優先的に追加:

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

### Starship連携

Starshipがインストールされている場合、自動的にプロンプトを初期化する。

## セットアップ

リポジトリルートの `setup.sh` を実行すると、以下のシンボリックリンクが作成される。

```
~/.zshrc -> <repo>/zsh/.zshrc
```

手動でリンクする場合:

```bash
ln -sf "$(pwd)/.zshrc" ~/.zshrc
```

## ローカル設定

機密情報や端末固有の設定は `~/.zshrc.local` に記載する。このファイルが存在すれば自動で読み込まれる。

```bash
# ~/.zshrc.local の例
export GITHUB_TOKEN="ghp_xxxx"
export AWS_PROFILE="my-profile"
```

## 前提条件

- macOS標準のzsh、または別途インストールしたzsh
- [Starship](https://starship.rs/)（プロンプト表示に使用、任意）
