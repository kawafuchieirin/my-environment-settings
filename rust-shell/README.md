# Rust Shell - Rust製ツールで統一した開発環境

Rust製の高速でモダンな開発ツールの設定ファイル集です。

## 導入ツール一覧

| 用途 | ツール名 | 説明 |
|------|----------|------|
| シェル | [Nushell](https://www.nushell.sh/) | 構造化データ対応のモダンシェル |
| ターミナル | [WezTerm](https://wezfurlong.org/wezterm/) | GPU加速・Lua設定対応ターミナル |
| エディタ | [Helix](https://helix-editor.com/) | 設定不要でLSP動作するエディタ |
| プロンプト | [Starship](https://starship.rs/) | 高速でカスタマイズ自由なプロンプト |
| ディレクトリ移動 | [zoxide](https://github.com/ajeetdsouza/zoxide) | 履歴ベースの賢いcd |
| 検索 | [ripgrep](https://github.com/BurntSushi/ripgrep) | 高速なgrep代替 |
| ファイル検索 | [fd](https://github.com/sharkdp/fd) | 高速なfind代替 |
| Fuzzy Finder | [skim](https://github.com/lotabout/skim) | Rust製ファジーファインダー |
| cat代替 | [bat](https://github.com/sharkdp/bat) | シンタックスハイライト付きcat |
| top代替 | [btop](https://github.com/aristocratos/btop) | リソースモニター |

## インストール (macOS)

### 1. Homebrew でツールをインストール

```bash
# 必須ツール
brew install nushell wezterm helix starship zoxide ripgrep fd skim bat

# オプション
brew install btop
```

### 2. フォントのインストール

```bash
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono font-hack-nerd-font
```

### 3. 設定ファイルの配置

```bash
# Nushell
mkdir -p ~/.config/nushell
cp nushell/env.nu ~/.config/nushell/
cp nushell/config.nu ~/.config/nushell/

# WezTerm
mkdir -p ~/.config/wezterm
cp wezterm/wezterm.lua ~/.config/wezterm/

# Helix
mkdir -p ~/.config/helix
cp helix/config.toml ~/.config/helix/
cp helix/languages.toml ~/.config/helix/

# Starship
cp starship/starship.toml ~/.config/
```

### 4. zoxide の初期化

```bash
# zoxide のキャッシュファイルを生成
zoxide init nushell > ~/.cache/zoxide.nu
```

### 5. デフォルトシェルを Nushell に変更

```bash
# Nushell のパスを確認
which nu

# /etc/shells に追加 (初回のみ)
echo "/opt/homebrew/bin/nu" | sudo tee -a /etc/shells

# デフォルトシェルを変更
chsh -s /opt/homebrew/bin/nu
```

## ディレクトリ構成

```
rest-shell/
├── README.md
├── nushell/
│   ├── env.nu          # 環境変数設定
│   └── config.nu       # Nushell設定
├── wezterm/
│   └── wezterm.lua     # WezTerm設定
├── helix/
│   ├── config.toml     # Helix設定
│   └── languages.toml  # 言語サーバー設定
└── starship/
    └── starship.toml   # Starship設定
```

## 主な機能

### Nushell
- テーブル形式の出力でデータ操作が容易
- Vi モード対応
- エイリアス設定済み (`ll`, `la`, `cat` → `bat` など)
- skim を使ったファジー検索関数 (`skcd`, `skhist`)

### WezTerm
- Tokyo Night カラースキーム
- GPU アクセラレーション有効
- ペイン分割 (Cmd+D / Cmd+Shift+D)
- デフォルトシェルを Nushell に設定

### Helix
- 相対行番号表示
- LSP/インレイヒント自動有効化
- 自動フォーマット/自動保存
- Vi ライクなキーバインド + カスタムショートカット

### Starship
- Git ブランチ/ステータス表示
- 言語バージョン表示 (Rust, Node.js, Python, Go)
- コマンド実行時間表示
- カスタマイズ可能なプロンプト

## 使い方

### Nushell 基本操作

```bash
# ファイル一覧をテーブル形式で表示
ls | where size > 1mb

# JSON をパースして操作
open package.json | get dependencies

# CSV を読み込んでフィルタリング
open data.csv | where age > 30 | sort-by name

# HTTP リクエスト
http get https://api.github.com/users/octocat

# パイプラインでデータ変換
ls | select name size | to json

# コマンド履歴を検索
history | where command =~ "git"
```

#### 設定済みエイリアス

| エイリアス | 実際のコマンド |
|-----------|---------------|
| `ll` | `ls -l` |
| `la` | `ls -a` |
| `lla` | `ls -la` |
| `cat` | `bat` |
| `grep` | `rg` |
| `find` | `fd` |
| `vim` / `vi` | `hx` |

#### カスタム関数

```bash
# ファジー検索でディレクトリ移動
skcd

# コマンド履歴をファジー検索
skhist
```

---

### WezTerm キーバインド

| キー | 動作 |
|------|------|
| `Cmd + D` | 縦にペイン分割 |
| `Cmd + Shift + D` | 横にペイン分割 |
| `Cmd + W` | ペインを閉じる |
| `Cmd + ←/→/↑/↓` | ペイン間を移動 |
| `Cmd + K` | スクロールバッファをクリア |
| `Cmd + T` | 新しいタブ |
| `Cmd + 数字` | タブを切り替え |

---

### Helix エディタ操作

#### 起動

```bash
# ファイルを開く
hx filename.rs

# カレントディレクトリを開く
hx .

# 複数ファイルを開く
hx file1.rs file2.rs
```

#### 基本操作 (ノーマルモード)

| キー | 動作 |
|------|------|
| `i` | 挿入モード (カーソル前) |
| `a` | 挿入モード (カーソル後) |
| `o` | 下に新しい行を追加して挿入モード |
| `O` | 上に新しい行を追加して挿入モード |
| `Esc` | ノーマルモードに戻る |
| `w` | 次の単語へ移動 |
| `b` | 前の単語へ移動 |
| `gg` | ファイル先頭へ |
| `ge` | ファイル末尾へ |
| `x` | 行を選択 |
| `d` | 選択範囲を削除 |
| `y` | 選択範囲をコピー |
| `p` | ペースト |
| `u` | 元に戻す |
| `U` | やり直し |
| `/` | 検索 |
| `n` | 次の検索結果 |
| `N` | 前の検索結果 |

#### Space メニュー (ノーマルモードで Space を押す)

| キー | 動作 |
|------|------|
| `Space + f` | ファイルピッカー |
| `Space + b` | バッファピッカー |
| `Space + s` | シンボルピッカー |
| `Space + w + v` | 縦分割 |
| `Space + w + s` | 横分割 |
| `Space + w + q` | ウィンドウを閉じる |

#### LSP 操作

| キー | 動作 |
|------|------|
| `Space + l + r` | リネーム |
| `Space + l + a` | コードアクション |
| `Space + l + d` | 定義へジャンプ |
| `Space + l + i` | 実装へジャンプ |
| `Space + l + t` | 型定義へジャンプ |
| `gd` | 定義へジャンプ (ショートカット) |
| `gr` | 参照を表示 |

#### 保存・終了

| キー | 動作 |
|------|------|
| `Ctrl + s` | 保存 |
| `Ctrl + q` | 終了 |
| `:w` | 保存 |
| `:q` | 終了 |
| `:wq` | 保存して終了 |
| `:q!` | 保存せず終了 |

---

### zoxide (スマートな cd)

```bash
# 通常の cd のように使用
z ~/projects

# 履歴から部分一致でジャンプ
z proj       # ~/projects にジャンプ (過去に訪問していれば)
z foo bar    # "foo" と "bar" を含むパスにジャンプ

# インタラクティブ選択
zi

# 現在のディレクトリをデータベースに追加
zoxide add /path/to/directory

# データベースから削除
zoxide remove /path/to/directory

# データベースを表示
zoxide query -l
```

---

### ripgrep (高速検索)

```bash
# 基本的な検索
rg "検索文字列"

# 大文字小文字を無視
rg -i "pattern"

# 特定の拡張子のみ
rg "pattern" -t rust
rg "pattern" -g "*.ts"

# 特定のディレクトリを除外
rg "pattern" -g "!node_modules"

# ファイル名のみ表示
rg -l "pattern"

# 行番号付きで表示
rg -n "pattern"

# 前後のコンテキストを表示
rg -C 3 "pattern"    # 前後3行
rg -B 2 -A 2 "pattern"  # 前2行、後2行

# 正規表現
rg "fn\s+\w+\("      # Rust の関数定義を検索

# 置換プレビュー
rg "old" -r "new"
```

---

### fd (高速ファイル検索)

```bash
# ファイル名で検索
fd "pattern"

# 拡張子でフィルタ
fd -e rs           # .rs ファイルのみ

# ディレクトリのみ
fd -t d "pattern"

# ファイルのみ
fd -t f "pattern"

# 隠しファイルも含める
fd -H "pattern"

# 除外パターン
fd "pattern" -E node_modules

# 絶対パスで表示
fd -a "pattern"

# 検索結果に対してコマンド実行
fd -e rs -x wc -l   # 各 .rs ファイルの行数
fd -e rs -X rm      # 全 .rs ファイルを削除 (注意!)
```

---

### skim (ファジーファインダー)

```bash
# インタラクティブにファイル選択
sk

# fd と組み合わせ
fd | sk

# ripgrep と組み合わせ (ファイル内容を検索)
sk --ansi -i -c 'rg --color=always --line-number "{}"'

# プレビュー付き
fd | sk --preview 'bat --color=always {}'

# 複数選択 (Tab で選択)
fd | sk -m

# コマンド履歴
history | sk
```

---

### bat (シンタックスハイライト付き cat)

```bash
# ファイルを表示
bat filename.rs

# 行番号なし
bat -p filename.rs

# 特定の行範囲
bat -r 10:20 filename.rs

# 言語を指定
bat -l json < data.txt

# diff モード
bat -d file1.rs file2.rs

# Git の変更を表示
bat --diff

# テーマ一覧
bat --list-themes

# テーマを指定
bat --theme="Tokyo Night" filename.rs
```

## トラブルシューティング

### Nushell が起動しない

```bash
# Nushell のパスを確認
which nu

# 直接実行してエラーを確認
/opt/homebrew/bin/nu
```

### zoxide が動かない

```bash
# キャッシュファイルを再生成
zoxide init nushell > ~/.cache/zoxide.nu

# Nushell を再起動
exit
nu
```

### Helix で LSP が動かない

```bash
# ヘルスチェック
hx --health

# 特定の言語のヘルスチェック
hx --health rust
hx --health typescript

# 必要な LSP をインストール
# Rust
rustup component add rust-analyzer

# TypeScript
npm install -g typescript-language-server typescript

# Python
pip install python-lsp-server
```

### WezTerm でフォントが表示されない

```bash
# フォントを再インストール
brew reinstall --cask font-jetbrains-mono font-hack-nerd-font

# フォントキャッシュをクリア (macOS)
sudo atsutil databases -remove
```

## 参考

- [Zenn記事: 開発環境をRust製ツールに統一した話](https://zenn.dev/tsubasa_ryuto/articles/13588a7236f578)
