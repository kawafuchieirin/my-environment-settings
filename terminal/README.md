# macOS Terminal 設定

macOS純正ターミナルを機能的でかっこよくする設定です。

## 構成

- **シンプルなzsh設定**: Oh My Zshなしの軽量構成
- **ライトテーマ**: 白背景に黒文字
- **Python開発向け**: pyenv、便利なエイリアス
- **モダンCLIツール**: eza、bat、fzf、zoxideなど

## ヘルプコマンド

ターミナルで以下のコマンドを実行すると使い方を確認できます：

```bash
help          # 全体のヘルプを表示
help-git      # Git関連のヘルプ
help-fzf      # fzf関連のヘルプ
help-keys     # キーボードショートカット
help-all      # 全てのヘルプを表示
```

## インストール

```bash
cd terminal
chmod +x setup.sh
./setup.sh
```

## セットアップ後の手順

1. **ターミナルを再起動**

2. **フォントを変更**
   - ターミナル → 設定 → プロファイル → テキスト → フォント
   - 「JetBrainsMono Nerd Font」を選択（サイズ: 14推奨）

3. **テーマをインポート**
   - `Light-Clean.terminal` をダブルクリック
   - ターミナル → 設定 → プロファイル で「Light-Clean」をデフォルトに設定

## 含まれるツール

| ツール | 説明 | 使い方 |
|--------|------|--------|
| eza | モダンなls | `ls`, `ll`, `la`, `lt` |
| bat | シンタックスハイライト付きcat | `cat`, `catn` |
| fzf | ファジーファインダー | `Ctrl+T`(ファイル), `Ctrl+R`(履歴) |
| zoxide | 学習型cd | `z <部分パス>` |
| ripgrep | 高速grep | `rg <パターン>` |
| Atuin | 高機能シェル履歴管理 | `Ctrl+R`(履歴検索UI) |

## キーボードショートカット

| ショートカット | 説明 |
|---------------|------|
| `Ctrl + R` | **Atuin履歴検索**（SQLiteベース、高機能UI） |
| `↑/↓` | **部分一致履歴検索**（入力中の文字で絞り込み） |
| `Option + ←/→` | 単語単位でカーソル移動 |
| `Ctrl + A/E` | 行頭/行末に移動 |
| `Ctrl + X Ctrl + E` | コマンドをエディタで編集 |
| `Ctrl + T` | fzfでファイル検索 |

## 便利なエイリアス

### グローバルエイリアス（パイプで使用）
```bash
cat log.txt L    # | less
history G ssh    # | grep
ls | C           # | wc -l
curl api J       # | jq
```

### Git
```bash
g     # git
gs    # git status
ga    # git add
gc    # git commit
gp    # git push
gl    # git log --oneline --graph
lg    # lazygit
groot # gitリポジトリのルートに移動
```

### Git + fzf（インタラクティブ選択）
```bash
gb    # fzfでブランチ選択→チェックアウト
gco   # fzfでコミット選択→ハッシュをコピー
gdf   # fzfで変更ファイル選択→diff表示
gaf   # fzfでファイル選択→ステージング
gsp   # fzfでstash選択→適用
gba   # fzfで全ブランチ表示（リモート含む）
```

### Python
```bash
py        # python
venv      # python -m venv
activate  # source .venv/bin/activate
mkpy <name>  # 新規Pythonプロジェクト作成
```

### ネットワーク
```bash
ip       # グローバルIP表示
localip  # ローカルIP表示
ports    # 使用中ポート一覧
```

### ファイル操作
```bash
fv      # fzfでファイルを選択してvimで開く
fd      # fzfでディレクトリを選択して移動
fh      # fzfで履歴を検索して実行
fkill   # fzfでプロセスを選択してkill
extract # 圧縮ファイルを自動展開
cpwd    # カレントディレクトリをクリップボードにコピー
duh     # ディレクトリサイズ表示
```

### サフィックスエイリアス（ファイル名だけで実行）
```bash
script.py    # → python script.py
data.json    # → vim data.json
page.html    # → Safariで開く
```

### その他
```bash
r          # 設定再読み込み
x          # exit
weather    # 天気表示
timer 60   # 60秒タイマー
cheat tar  # コマンドのヘルプ表示
```

## ファイル構成

```
terminal/
├── setup.sh              # インストールスクリプト
├── .zshrc                # zsh設定ファイル（Oh My Zshなし）
├── Light-Clean.terminal  # ターミナルテーマ
├── PLUGINS.md            # プラグイン・ツール一覧
├── REFERENCES.md         # 参考サイト一覧
└── README.md             # このファイル
```

## プラグイン・ツール詳細

各プラグイン・ツールの詳細な説明は [PLUGINS.md](PLUGINS.md) を参照してください。

## 履歴検索の使い方

### 部分一致検索（↑/↓キー）

コマンドの一部を入力して `↑` を押すと、その文字を含む履歴だけが表示されます。

```bash
git↑     # → git commit, git push, git status など
docker↑  # → docker run, docker ps など
```

### Atuin（Ctrl+R）

`Ctrl+R` で高機能な履歴検索UIが開きます。

**特徴：**
- SQLiteベースで大量の履歴を高速検索
- 実行時間、終了コード、ディレクトリも記録
- あいまい検索対応

**初回起動時：**
```bash
# 既存の履歴をインポートするか聞かれたら y を選択
atuin import auto
```

**Atuin設定（オプション）：**
```bash
# 設定ファイルを編集
vim ~/.config/atuin/config.toml
```

```toml
# 検索モード: prefix, fulltext, fuzzy
search_mode = "fuzzy"

# UIスタイル: auto, full, compact
style = "compact"

# 履歴の同期（複数マシン間）
# sync_address = "https://api.atuin.sh"
# sync_frequency = "5m"
```

## Git + fzf の使い方

### ブランチ選択（gb）

```bash
gb  # ブランチ一覧をfzfで表示、選択するとチェックアウト
```
- プレビューでそのブランチのコミット履歴を表示
- リモートブランチも選択可能

### ファイルのステージング（gaf）

```bash
gaf  # 変更ファイルをfzfで複数選択してステージング
```
- `Tab` で複数選択
- プレビューでdiffを確認しながら選択

### コミットハッシュのコピー（gco）

```bash
gco  # コミット一覧から選択してハッシュをクリップボードにコピー
```
- `git cherry-pick` や `git revert` で使用

## カスタマイズ

### プロンプトの変更
`.zshrc` の `PROMPT` 変数を編集して、お好みのプロンプトスタイルに変更できます。

```bash
# 現在のスタイル
PROMPT='%F{green}%~%f$ '

# ユーザー名を追加
PROMPT='%F{blue}%n%f:%F{green}%~%f$ '

# 時刻を追加
PROMPT='%F{gray}%T%f %F{green}%~%f$ '
```

### 追加のプラグイン
Homebrewで追加のzshプラグインをインストールできます：
```bash
brew install zsh-completions
```

## トラブルシューティング

### アイコンが表示されない

フォントが正しく設定されていない可能性があります。

1. ターミナル → 設定 → プロファイル → テキスト → フォント
2. 「JetBrainsMono Nerd Font」を選択
3. ターミナルを再起動

### Atuinが動作しない

```bash
# Atuinの状態確認
atuin status

# 履歴の再インポート
atuin import auto
```

### 設定が反映されない

```bash
# 設定を再読み込み
source ~/.zshrc
# または
r
```
