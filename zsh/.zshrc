# ==============================================================================
# 環境変数
# ==============================================================================
export LANG=ja_JP.UTF-8
export EDITOR=hx

# ==============================================================================
# API Key
# ==============================================================================
export QUANTS_API_V2_API_KEY="QUiku1dfCs0pl1f1sWZk4mgfxjqMS26BghDkerHAXWM"
export GEMINI_API_KEY="AIzaSyAXp6Jkg9of8Pin-WFriz7O0lyTZwmDdJ0"

# ==============================================================================
# PATH
# ==============================================================================
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/opt/python/libexec/bin:$PATH"

# ==============================================================================
# エイリアス
# ==============================================================================

# ファイル操作（eza）
alias ls='eza --icons'
alias ll='eza -l --icons --git'
alias la='eza -la --icons --git'
alias tree='eza --tree --icons'

# Git
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# Claude
alias cc='claude --dangerously-skip-permissions'

# Cursor
alias x='open -a "Cursor" .'


# ==============================================================================
# プラグイン
# ==============================================================================
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ==============================================================================
# Starship
# ==============================================================================
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# ==============================================================================
# ローカル設定
# ==============================================================================
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
