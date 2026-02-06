# my-environment-settings

macOS開発環境のシェル設定を管理するリポジトリ。

## 構成

| ディレクトリ | 内容 |
|-------------|------|
| `zsh/` | zsh設定 |
| `nushell/` | Nushell設定 |
| `wezterm/` | WezTerm設定 |
| `starship/` | Starshipプロンプト設定 |
| `shared/` | 共通設定定義（YAML） |

## セットアップ

```bash
./setup.sh
```

## ローカル設定

機密情報は以下のファイルに記載（gitignore対象）:

- `zsh/.zshrc.local`
- `nushell/local.nu`
