# my-environment-settings

macOS開発環境設定を管理するリポジトリ。

## 環境

2つのシェル環境を提供（どちらか一方を選択）:

- **terminal/**: zsh + モダンCLIツール
- **rust-shell/**: Nushell + Rust製ツール

## セットアップ

```bash
# マスターセットアップ
./setup.sh

# 個別セットアップ
cd terminal && ./setup.sh     # zsh環境
cd rust-shell && ./setup.sh   # Nushell環境
cd macos && ./setup.sh        # macOS設定
cd vscode && ./setup.sh       # VS Code設定
```

## ディレクトリ構成

```
.
├── terminal/      # zsh設定
├── rust-shell/    # Nushell + WezTerm + Helix
├── macos/         # macOSシステム設定
├── vscode/        # VS Code設定
├── shared/        # 共通設定
└── setup.sh       # マスターセットアップ
```
