# Starship 設定

クロスシェル対応プロンプト [Starship](https://starship.rs/) のカスタム設定ファイル。zshとNushellの両方で共通のプロンプト表示を提供する。

## ファイル構成

| ファイル | 説明 |
|---------|------|
| `starship.toml` | Starshipのメイン設定ファイル |

## 設定内容

### プロンプト表示形式

以下の要素を左から順に表示するミニマルなプロンプト:

```
<ディレクトリ> <Gitブランチ> <Gitステータス> ❯
```

### 各モジュールの設定

| モジュール | 設定 |
|-----------|------|
| `directory` | 表示階層数: 3、リポジトリルートで切り詰め |
| `git_branch` | 太字紫でブランチ名を表示 |
| `git_status` | 太字赤でステータス（変更・未追跡等）を表示 |
| `character` | 成功時: 緑の `❯`、エラー時: 赤の `❯` |

### 表示例

```
~/work-space/project main ❯          # 正常時（緑）
~/work-space/project main [!+] ❯     # 変更あり（ステータス赤、プロンプト緑）
```

## セットアップ

リポジトリルートの `setup.sh` を実行すると、以下のシンボリックリンクが作成される。

```
~/.config/starship.toml -> <repo>/starship/starship.toml
```

手動でリンクする場合:

```bash
ln -sf "$(pwd)/starship.toml" ~/.config/starship.toml
```

## カスタマイズ

設定を変更する場合は `starship.toml` を直接編集する。保存すると次回のプロンプト表示から反映される。

```toml
# 表示例: Node.jsバージョンを追加
format = """
$directory\
$git_branch\
$git_status\
$nodejs\
$character"""

[nodejs]
format = "[$version](bold green) "
```

利用可能なモジュール一覧は [Starship公式ドキュメント](https://starship.rs/config/) を参照。

## 前提条件

- [Starship](https://starship.rs/) がインストール済みであること
- [Nerd Font](https://www.nerdfonts.com/) 対応フォント（一部アイコン表示に必要）
