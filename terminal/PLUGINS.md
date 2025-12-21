# ターミナル プラグイン・ツール一覧

macOS標準ターミナル + zsh で使用しているプラグイン・ツールの一覧です。

## zsh プラグイン

| プラグイン | 説明 | インストール |
|-----------|------|-------------|
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | コマンドをシンタックスハイライト | `brew install zsh-syntax-highlighting` |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | 履歴から補完候補を薄く表示 | `brew install zsh-autosuggestions` |
| [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search) | ↑↓キーで部分一致履歴検索 | `brew install zsh-history-substring-search` |

### zsh-syntax-highlighting

コマンドを入力中にリアルタイムでシンタックスハイライトを表示。

- 正しいコマンド: 緑色
- 存在しないコマンド: 赤色
- パス: 下線付き

### zsh-autosuggestions

過去の履歴から補完候補を薄いグレーで表示。`→` キーで確定。

### zsh-history-substring-search

入力した文字列を含む履歴だけを ↑/↓ で検索。

```bash
git     # ← ここで ↑ を押すと git を含む履歴のみ表示
```

---

## CLI ツール

### ファイル操作

| ツール | 説明 | 代替対象 | インストール |
|--------|------|---------|-------------|
| [eza](https://github.com/eza-community/eza) | モダンな ls | `ls` | `brew install eza` |
| [bat](https://github.com/sharkdp/bat) | シンタックスハイライト付き cat | `cat` | `brew install bat` |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | 学習型ディレクトリジャンプ | `cd` | `brew install zoxide` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | 高速 grep | `grep` | `brew install ripgrep` |

#### eza

```bash
ls      # アイコン付きリスト
ll      # 詳細表示 + git status
la      # 隠しファイル含む
lt      # ツリー表示
```

#### bat

```bash
cat file.py    # シンタックスハイライト付き表示
catn file.py   # 行番号付き表示
```

#### zoxide

```bash
z proj         # "proj" を含むよく使うディレクトリにジャンプ
z foo bar      # "foo" と "bar" を含むディレクトリ
zi             # インタラクティブ選択
```

#### ripgrep

```bash
rg "pattern"           # カレント以下を再帰検索
rg "pattern" -t py     # Pythonファイルのみ
rg "pattern" -g "*.js" # glob パターン指定
```

---

### ファジーファインダー

| ツール | 説明 | インストール |
|--------|------|-------------|
| [fzf](https://github.com/junegunn/fzf) | 汎用ファジーファインダー | `brew install fzf` |
| [Atuin](https://github.com/atuinsh/atuin) | 高機能シェル履歴管理 | `brew install atuin` |

#### fzf

キーバインド:
- `Ctrl + T`: ファイル検索
- `Ctrl + R`: 履歴検索（Atuinが上書き）
- `Alt + C`: ディレクトリ移動

カスタムコマンド:
```bash
fv      # ファイル選択 → vim で開く
fd      # ディレクトリ選択 → 移動
fh      # 履歴選択 → 実行
fkill   # プロセス選択 → kill
```

#### Atuin

SQLite ベースの高機能履歴管理。

- `Ctrl + R`: 履歴検索 UI
- 実行時間、終了コード、ディレクトリを記録
- 複数マシン間で同期可能（オプション）

```bash
atuin stats          # 統計表示
atuin search "git"   # 検索
atuin import auto    # 既存履歴をインポート
```

---

### Git ツール

| ツール | 説明 | インストール |
|--------|------|-------------|
| [delta](https://github.com/dandavison/delta) | Git diff の美化 | `brew install git-delta` |
| [lazygit](https://github.com/jesseduffield/lazygit) | ターミナル Git UI | `brew install lazygit` |

#### delta

`git diff` を自動的にカラフル表示。行番号、サイドバイサイド表示対応。

```bash
git diff           # delta で美化表示
git log -p         # パッチも delta で表示
git show           # コミット詳細も delta で表示
```

#### lazygit

```bash
lg    # lazygit を起動
```

キー操作:
- `j/k`: 移動
- `space`: ステージング
- `c`: コミット
- `p`: プッシュ
- `?`: ヘルプ

---

### その他ツール

| ツール | 説明 | インストール |
|--------|------|-------------|
| [tldr](https://github.com/tldr-pages/tldr) | コマンドの簡潔なヘルプ | `brew install tldr` |
| [jq](https://github.com/stedolan/jq) | JSON パーサー | `brew install jq` |

#### tldr

```bash
tl tar    # tar コマンドの使用例を表示
tl git    # git コマンドの使用例
```

#### jq

```bash
cat data.json | jq           # 整形表示
cat data.json | jq '.name'   # フィールド抽出
curl api | jq '.items[]'     # 配列展開
```

---

## フォント

| フォント | 説明 | インストール |
|---------|------|-------------|
| [JetBrainsMono Nerd Font](https://www.nerdfonts.com/) | アイコン付きプログラミングフォント | `brew install --cask font-jetbrains-mono-nerd-font` |

ターミナル設定でフォントを「JetBrainsMono Nerd Font」に変更すると、eza のアイコンが正しく表示されます。

---

## 一括インストール

```bash
# zsh プラグイン
brew install zsh-syntax-highlighting zsh-autosuggestions zsh-history-substring-search

# CLI ツール
brew install eza bat fzf zoxide ripgrep delta lazygit tldr jq atuin

# フォント
brew install --cask font-jetbrains-mono-nerd-font
```

---

## 参考リンク

- [Homebrew](https://brew.sh/) - macOS パッケージマネージャー
- [Nerd Fonts](https://www.nerdfonts.com/) - アイコン付きフォント
- [Modern Unix](https://github.com/ibraheemdev/modern-unix) - モダン CLI ツール集
