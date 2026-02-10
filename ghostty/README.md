# Ghostty 設定

ターミナルエミュレータ [Ghostty](https://ghostty.org/) の設定ファイル。

## ファイル構成

| ファイル | 説明 |
|---------|------|
| `config` | Ghostty設定ファイル |

## 設定内容

| 設定 | 値 | 説明 |
|-----|-----|------|
| `font-family` | `JetBrains Mono` | フォント |
| `font-size` | `14` | フォントサイズ |
| `shell-integration` | `zsh` | シェル統合 |

## セットアップ

`setup.sh` により `~/.config/ghostty/config` にシンボリックリンクが作成される。

```bash
# 手動で設定する場合
ln -sf $(pwd)/config ~/.config/ghostty/config
```

## 設定リファレンス

Ghosttyの全設定項目は公式ドキュメントを参照:
https://ghostty.org/docs/config/reference
