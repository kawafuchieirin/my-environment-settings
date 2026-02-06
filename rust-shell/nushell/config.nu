# ==============================================================================
# Nushell設定
# ==============================================================================
$env.config = {
    show_banner: false
    edit_mode: vi
}

# ==============================================================================
# エイリアス
# ==============================================================================

# ファイル操作
alias ll = ls -la
alias la = ls -a

# Git
alias g = git
alias gs = git status
alias ga = git add
alias gc = git commit
alias gp = git push
alias gl = git log --oneline
alias gd = git diff

# その他
alias c = clear

# ==============================================================================
# ローカル設定（存在する場合）
# ==============================================================================
const local_config = ($nu.default-config-dir | path join "local.nu")
if ($local_config | path exists) {
    source $local_config
}
