# ローカル設定ガイド

個人PCと会社用PCで異なる設定（APIキー、社内ツールなど）を管理する方法です。

## 概要

ローカル設定ファイルは`.gitignore`に含まれるため、**コミットされません**。
各マシンで機密情報を安全に管理できます。

```
リポジトリ（共有）          ローカル（非共有）
├── terminal/
│   ├── .zshrc              ← 共通設定
│   ├── .zshrc.local.example ← テンプレート
│   └── .zshrc.local        ← 機密情報（gitignore）
│
└── rust-shell/nushell/
    ├── config.nu           ← 共通設定
    ├── local.nu.example    ← テンプレート
    └── local.nu            ← 機密情報（gitignore）
```

---

## セットアップ手順

### 1. zsh環境

```bash
# テンプレートをコピー
cp terminal/.zshrc.local.example terminal/.zshrc.local

# 編集
vim terminal/.zshrc.local
```

### 2. Nushell環境

```bash
# setup.shが自動で空のlocal.nuを作成します
# 手動で作成する場合:
cat > ~/Library/Application\ Support/nushell/local.nu << 'EOF'
# ローカル設定
EOF

# 編集
hx ~/Library/Application\ Support/nushell/local.nu
```

> **注意**: Nushellの`source`は静的解析されるため、`local.nu`が存在しないとエラーになります。`setup.sh`を実行すれば自動で作成されます。

### 3. 設定を反映

```bash
# zsh
source ~/.zshrc

# Nushell
# 新しいセッションを開く（WezTermで Cmd+T）
```

---

## 設定例

### 会社用PC

#### zsh (.zshrc.local)

```bash
# =============================================================================
# 会社用設定
# =============================================================================

# AWS認証情報
export AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"
export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
export AWS_DEFAULT_REGION="ap-northeast-1"

# 社内API
export COMPANY_API_KEY="your-company-api-key"
export INTERNAL_API_URL="https://api.internal.company.com"

# データベース
export DATABASE_URL="postgres://user:pass@db.company.com:5432/production"

# Slack
export SLACK_WEBHOOK_URL="https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXX"

# 社内ツールへのエイリアス
alias vpn='sudo openconnect --user=your-name vpn.company.com'
alias jira='open "https://company.atlassian.net/browse"'
alias confluence='open "https://company.atlassian.net/wiki"'
alias gitlab='open "https://gitlab.company.com"'

# 社内サーバー接続
alias ssh-dev='ssh deploy@dev.company.com'
alias ssh-stg='ssh deploy@staging.company.com'
alias ssh-prod='ssh deploy@prod.company.com'

# 社内ツールのPATH
export PATH="$HOME/company-cli/bin:$PATH"

# プロキシ設定（必要な場合）
# export HTTP_PROXY="http://proxy.company.com:8080"
# export HTTPS_PROXY="http://proxy.company.com:8080"
```

#### Nushell (local.nu)

```nu
# =============================================================================
# 会社用設定
# =============================================================================

# AWS認証情報
$env.AWS_ACCESS_KEY_ID = "AKIAIOSFODNN7EXAMPLE"
$env.AWS_SECRET_ACCESS_KEY = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
$env.AWS_DEFAULT_REGION = "ap-northeast-1"

# 社内API
$env.COMPANY_API_KEY = "your-company-api-key"
$env.INTERNAL_API_URL = "https://api.internal.company.com"

# データベース
$env.DATABASE_URL = "postgres://user:pass@db.company.com:5432/production"

# 社内ツールへのエイリアス
alias vpn = sudo openconnect --user=your-name vpn.company.com
alias jira = open "https://company.atlassian.net/browse"
alias confluence = open "https://company.atlassian.net/wiki"
alias gitlab = open "https://gitlab.company.com"

# 社内サーバー接続
alias ssh-dev = ssh deploy@dev.company.com
alias ssh-stg = ssh deploy@staging.company.com
alias ssh-prod = ssh deploy@prod.company.com

# 社内ツールのPATH
$env.PATH = ($env.PATH | prepend $"($env.HOME)/company-cli/bin")
```

---

### 個人用PC

#### zsh (.zshrc.local)

```bash
# =============================================================================
# 個人用設定
# =============================================================================

# GitHub
export GITHUB_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# OpenAI
export OPENAI_API_KEY="sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# Anthropic
export ANTHROPIC_API_KEY="sk-ant-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# 個人プロジェクト
export PERSONAL_PROJECT_DIR="$HOME/projects"

# 個人サーバー
alias ssh-vps='ssh user@your-vps.com'
alias ssh-nas='ssh admin@192.168.1.100'

# 開発用エイリアス
alias dev='cd ~/projects && code .'
```

#### Nushell (local.nu)

```nu
# =============================================================================
# 個人用設定
# =============================================================================

# GitHub
$env.GITHUB_TOKEN = "ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# OpenAI
$env.OPENAI_API_KEY = "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# Anthropic
$env.ANTHROPIC_API_KEY = "sk-ant-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# 個人プロジェクト
$env.PERSONAL_PROJECT_DIR = $"($env.HOME)/projects"

# 個人サーバー
alias ssh-vps = ssh user@your-vps.com
alias ssh-nas = ssh admin@192.168.1.100
```

---

## よくある設定項目

| カテゴリ | 環境変数 / エイリアス |
|---------|---------------------|
| AWS | `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_DEFAULT_REGION` |
| GCP | `GOOGLE_APPLICATION_CREDENTIALS`, `GCLOUD_PROJECT` |
| Azure | `AZURE_SUBSCRIPTION_ID`, `AZURE_TENANT_ID` |
| GitHub | `GITHUB_TOKEN`, `GH_TOKEN` |
| OpenAI | `OPENAI_API_KEY` |
| Anthropic | `ANTHROPIC_API_KEY` |
| データベース | `DATABASE_URL`, `REDIS_URL`, `MONGODB_URI` |
| Slack | `SLACK_WEBHOOK_URL`, `SLACK_TOKEN` |
| Docker | `DOCKER_HOST`, `DOCKER_REGISTRY` |
| プロキシ | `HTTP_PROXY`, `HTTPS_PROXY`, `NO_PROXY` |

---

## セキュリティのベストプラクティス

### やるべきこと

- ローカル設定ファイルのパーミッションを制限する
  ```bash
  chmod 600 terminal/.zshrc.local
  chmod 600 rust-shell/nushell/local.nu
  ```

- 定期的にAPIキーをローテーションする

- 必要最小限の権限を持つAPIキーを使用する

### やってはいけないこと

- ローカル設定ファイルを手動でコミットしない
  ```bash
  # 絶対にやらない
  git add -f terminal/.zshrc.local
  ```

- ローカル設定ファイルを他人と共有しない

- APIキーをSlackやメールで送信しない

---

## トラブルシューティング

### ローカル設定が読み込まれない

```bash
# zsh: ファイルが存在するか確認
ls -la terminal/.zshrc.local

# Nushell: ファイルが存在するか確認
ls ~/Library/Application\ Support/nushell/local.nu
```

### 設定が反映されない

```bash
# zsh: 再読み込み
source ~/.zshrc

# Nushell: 新しいセッションを開く
# WezTermで Cmd+T
```

### 誤ってコミットしてしまった場合

```bash
# 履歴から完全に削除（注意: 履歴が書き換わる）
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch terminal/.zshrc.local' \
  --prune-empty --tag-name-filter cat -- --all

# GitHubにプッシュ
git push origin --force --all

# APIキーを即座にローテーション！
```

---

## 新しいマシンでのセットアップチェックリスト

- [ ] リポジトリをクローン
- [ ] `./setup.sh`を実行
- [ ] `.zshrc.local`または`local.nu`を作成
- [ ] 必要な環境変数を設定
- [ ] 必要なエイリアスを設定
- [ ] ファイルのパーミッションを確認（600）
- [ ] 設定が正しく読み込まれるか確認
