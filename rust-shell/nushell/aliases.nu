# =============================================================================
# aliases.nu - エイリアス定義
# =============================================================================
# zshと共通のエイリアスを定義
# 変更時は terminal/.zshrc と shared/config.yaml も同時に更新すること
# =============================================================================

# -----------------------------------------------------------------------------
# ファイル操作
# -----------------------------------------------------------------------------
alias ll = ls -l
alias la = ls -a
alias lla = ls -la
alias cat = bat
alias grep = rg
alias ff = fd      # find files (fd) - Nushell の find はビルトイン
alias top = btop
alias vim = hx
alias vi = hx

# -----------------------------------------------------------------------------
# Git
# -----------------------------------------------------------------------------
alias g = git
alias gs = git status
alias ga = git add
alias gc = git commit
alias gp = git push
alias gl = git log --oneline --graph
alias gd = git diff
alias lg = lazygit

# -----------------------------------------------------------------------------
# Python
# -----------------------------------------------------------------------------
alias py = python
alias py3 = python3
alias pip = pip3
alias venv = python -m venv

# activate: Nushellではsourceは関数内で使用不可のため、手動で実行
# 使用方法: overlay use .venv/bin/activate.nu
def activate [] {
    if (".venv/bin/activate.nu" | path exists) {
        print "実行してください: overlay use .venv/bin/activate.nu"
    } else {
        print "エラー: .venv/bin/activate.nu が見つかりません"
    }
}

# -----------------------------------------------------------------------------
# ディレクトリ操作
# -----------------------------------------------------------------------------
alias mkdir = ^mkdir -p

# -----------------------------------------------------------------------------
# その他
# -----------------------------------------------------------------------------
alias c = clear
alias cc = claude --dangerously-skip-permissions
# h: 重複を排除した履歴表示
def h [n: int = 50] { history | last $n | uniq-by command | reverse }
alias x = exit
alias tl = tldr
alias j = jq
alias rdock = killall Dock  # Dockを再起動

# -----------------------------------------------------------------------------
# クリップボード
# -----------------------------------------------------------------------------
alias pbp = pbpaste
alias pbc = pbcopy

# -----------------------------------------------------------------------------
# エディタ
# -----------------------------------------------------------------------------
alias C = ^open -a Cursor .  # Cursorでカレントディレクトリを開く

# -----------------------------------------------------------------------------
# パイプ用コマンド（zshのグローバルエイリアス相当）
# -----------------------------------------------------------------------------
def G [pattern: string] { rg $pattern }           # grep
def H [n: int = 10] { first $n }                  # head
def T [n: int = 10] { last $n }                   # tail
def J [...path: string] { if ($path | is-empty) { from json } else { from json | get ($path | str join ".") } }  # jq
