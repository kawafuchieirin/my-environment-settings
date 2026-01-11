# =============================================================================
# 基本的なzsh設定（Oh My Zshなし）
# =============================================================================

# 環境変数
export LANG=ja_JP.UTF-8
export EDITOR='vim'

# Homebrew (Apple Silicon対応)
if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# =============================================================================
# Python環境 (pyenv)
# =============================================================================

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

# pyenvの初期化（存在チェック付き）
if command -v pyenv &> /dev/null; then
    eval "$(pyenv init -)"
    # pyenv-virtualenvが利用可能な場合のみ初期化
    if pyenv commands | grep -q virtualenv-init; then
        eval "$(pyenv virtualenv-init -)"
    fi
fi

# =============================================================================
# zshの基本設定
# =============================================================================

# 履歴設定
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS  # 重複する履歴を保存しない
setopt HIST_SAVE_NO_DUPS     # 履歴ファイルに重複して保存しない
setopt SHARE_HISTORY         # 複数のzshセッション間で履歴を共有
setopt EXTENDED_HISTORY      # タイムスタンプを記録
setopt HIST_VERIFY           # 履歴展開後に確認

# 補完機能
autoload -Uz compinit && compinit
setopt AUTO_CD               # ディレクトリ名だけで移動
setopt AUTO_PUSHD           # cd時に自動でpushdする
setopt PUSHD_IGNORE_DUPS    # pushdで重複を記録しない

# プロンプト設定（シンプル）
PROMPT='%F{green}%~%f$ '

# =============================================================================
# モダンCLIツール
# =============================================================================

# eza (ls の代替)
if command -v eza &> /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -l --icons --group-directories-first --git'
    alias la='eza -la --icons --group-directories-first --git'
    alias lt='eza --tree --level=2 --icons'
    alias lta='eza --tree --level=2 --icons -a'
fi

# bat (cat の代替)
if command -v bat &> /dev/null; then
    alias cat='bat --style=plain'
    alias catn='bat'  # 行番号付き
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# zoxide (cd の代替)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'
fi

# fzf設定
if command -v fzf &> /dev/null; then
    # ライトテーマ用の配色
    export FZF_DEFAULT_OPTS='
        --height 40%
        --layout=reverse
        --border
        --color=bg+:#e8e8e8,bg:#ffffff,spinner:#0969da,hl:#0550ae
        --color=fg:#24292f,header:#0550ae,info:#57606a,pointer:#0969da
        --color=marker:#1a7f37,fg+:#24292f,prompt:#0969da,hl+:#0550ae
    '
    # ripgrepをデフォルトに
    if command -v rg &> /dev/null; then
        export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
    fi
    # fzfキーバインディング
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi

# =============================================================================
# キーバインド
# =============================================================================

bindkey -e  # Emacsモード

# Option + 矢印キーで単語単位の移動
bindkey '\e\e[C' forward-word      # Option + →
bindkey '\e\e[D' backward-word     # Option + ←
bindkey '^[[1;3C' forward-word     # Alt + → (一部ターミナル用)
bindkey '^[[1;3D' backward-word    # Alt + ← (一部ターミナル用)

# コマンドラインをエディタで編集 (Ctrl+X Ctrl+E)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# =============================================================================
# グローバルエイリアス（パイプで使用）
# =============================================================================

alias -g L='| less'
alias -g G='| grep'
alias -g H='| head'
alias -g T='| tail'
alias -g C='| wc -l'
alias -g J='| jq'
alias -g X='| xargs'
alias -g N='> /dev/null 2>&1'

# 使用例:
# cat log.txt L    → cat log.txt | less
# history G ssh    → history | grep ssh
# ls | C           → ls | wc -l

# =============================================================================
# サフィックスエイリアス（拡張子でプログラム起動）
# =============================================================================

alias -s py=python
alias -s {json,yaml,yml,md,txt}=vim
alias -s {html,htm}='open -a "Safari"'
alias -s {png,jpg,jpeg,gif}='open -a "Preview"'

# 使用例:
# script.py     → python script.py
# data.json     → vim data.json

# =============================================================================
# エイリアス
# =============================================================================

# Git
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph'
alias gd='git diff'
alias lg='lazygit'

# delta設定（git diffの美化）
if command -v delta &> /dev/null; then
    export GIT_PAGER='delta'
fi

# Python
alias py='python'
alias py3='python3'
alias pip='pip3'
alias venv='python -m venv'
alias activate='source .venv/bin/activate'

# ディレクトリ操作
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkdir='mkdir -p'

# 安全策
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# その他
alias c='clear'
alias h='history'
alias grep='grep --color=auto'
alias x='exit'
alias r='exec zsh'  # 設定再読み込み
alias rdock='killall Dock'  # Dockを再起動

# 新しいツール
alias tl='tldr'  # コマンドの使い方を簡潔に表示
alias j='jq'     # JSONパーサー

# クリップボード
alias pbp='pbpaste'
alias pbc='pbcopy'

# ネットワーク
alias ip='curl -s ipinfo.io | jq'
alias localip='ipconfig getifaddr en0'
alias ports='lsof -i -P -n | grep LISTEN'

# ディスク使用量
alias duh='du -h -d 1 | sort -hr'
alias duf='df -h'

# =============================================================================
# 関数
# =============================================================================

# 新しいPythonプロジェクトを作成
mkpy() {
    if [ -z "$1" ]; then
        echo "Usage: mkpy <project-name>"
        return 1
    fi
    mkdir -p "$1"
    cd "$1"
    python -m venv .venv
    source .venv/bin/activate
    echo "# $1" > README.md
    echo ".venv/" > .gitignore
    echo "__pycache__/" >> .gitignore
    echo "*.pyc" >> .gitignore
    echo ".env" >> .gitignore
    git init
    echo "Pythonプロジェクト '$1' を作成しました"
}

# ディレクトリ作成して移動
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# fzfでファイルを選択してvimで開く
fv() {
    local file
    file=$(fzf --preview 'bat --style=numbers --color=always {}')
    [ -n "$file" ] && vim "$file"
}

# fzfでディレクトリを選択して移動
fd() {
    local dir
    dir=$(find . -type d 2>/dev/null | fzf --preview 'eza --tree --level=1 {}')
    [ -n "$dir" ] && cd "$dir"
}

# fzfで履歴を検索して実行
fh() {
    local cmd
    cmd=$(history | fzf --tac | sed 's/^[ ]*[0-9]*[ ]*//')
    [ -n "$cmd" ] && eval "$cmd"
}

# fzfでプロセスを選択してkill
fkill() {
    local pid
    pid=$(ps aux | fzf --header-lines=1 | awk '{print $2}')
    [ -n "$pid" ] && kill -9 "$pid"
}

# 圧縮ファイルを自動展開
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"    ;;
            *.tar.gz)    tar xzf "$1"    ;;
            *.tar.xz)    tar xJf "$1"    ;;
            *.bz2)       bunzip2 "$1"    ;;
            *.gz)        gunzip "$1"     ;;
            *.tar)       tar xf "$1"     ;;
            *.tbz2)      tar xjf "$1"    ;;
            *.tgz)       tar xzf "$1"    ;;
            *.zip)       unzip "$1"      ;;
            *.Z)         uncompress "$1" ;;
            *.7z)        7z x "$1"       ;;
            *.rar)       unrar x "$1"    ;;
            *)           echo "'$1' は対応していない形式です" ;;
        esac
    else
        echo "'$1' は有効なファイルではありません"
    fi
}

# 天気を表示
weather() {
    curl -s "wttr.in/${1:-Tokyo}?format=3"
}

# Gitリポジトリのルートに移動
groot() {
    cd "$(git rev-parse --show-toplevel 2>/dev/null || echo '.')"
}

# 指定秒数後に通知
timer() {
    local seconds="${1:-60}"
    echo "${seconds}秒後に通知します..."
    sleep "$seconds"
    osascript -e 'display notification "タイマー完了" with title "Timer"'
    echo "完了!"
}

# カレントディレクトリのパスをクリップボードにコピー
cpwd() {
    pwd | tr -d '\n' | pbcopy
    echo "パスをコピーしました: $(pwd)"
}

# cheat.shでコマンドのヘルプを表示
cheat() {
    curl -s "cheat.sh/$1"
}

# =============================================================================
# シンタックスハイライト（zsh-syntax-highlightingの代替）
# =============================================================================

# macOSの場合、Homebrewでインストール可能
if [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# =============================================================================
# 自動補完の提案（zsh-autosuggestions の代替）
# =============================================================================

# macOSの場合、Homebrewでインストール可能
if [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# =============================================================================
# 履歴検索強化（↑↓キーで部分一致検索）
# =============================================================================

# zsh-history-substring-search
if [[ -f /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
    source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
    # ↑↓キーで部分一致検索
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    # Emacsモードでも使えるように
    bindkey '^P' history-substring-search-up
    bindkey '^N' history-substring-search-down
elif [[ -f /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
    source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    bindkey '^P' history-substring-search-up
    bindkey '^N' history-substring-search-down
fi

# =============================================================================
# Git fzf 関数（ブランチ・コミット選択など）
# =============================================================================

# fzfでGitブランチを選択してチェックアウト
gb() {
    local branch
    branch=$(git branch -a --color=always | grep -v '/HEAD\s' | \
        fzf --ansi --preview 'git log --oneline --graph --color=always $(echo {} | sed "s/.* //" | sed "s#remotes/[^/]*/##")' | \
        sed 's/.* //' | sed 's#remotes/[^/]*/##')
    [ -n "$branch" ] && git checkout "$branch"
}

# fzfでGitコミットを選択（ハッシュをコピー）
gco() {
    local commit
    commit=$(git log --oneline --color=always | \
        fzf --ansi --preview 'git show --color=always $(echo {} | cut -d" " -f1)' | \
        cut -d' ' -f1)
    [ -n "$commit" ] && echo "$commit" | tr -d '\n' | pbcopy && echo "コピーしました: $commit"
}

# fzfでGitファイルを選択してdiff表示
gdf() {
    local file
    file=$(git diff --name-only | fzf --preview 'git diff --color=always {}')
    [ -n "$file" ] && git diff "$file"
}

# fzfでステージングするファイルを選択
gaf() {
    local files
    files=$(git status -s | fzf -m --preview 'git diff --color=always $(echo {} | awk "{print \$2}")' | awk '{print $2}')
    [ -n "$files" ] && echo "$files" | xargs git add && git status -s
}

# fzfでGit stashを選択して適用
gsp() {
    local stash
    stash=$(git stash list | fzf --preview 'git stash show -p $(echo {} | cut -d: -f1)' | cut -d: -f1)
    [ -n "$stash" ] && git stash pop "$stash"
}

# fzfで削除済みブランチも含めて検索
gba() {
    git branch -a --color=always | \
        fzf --ansi --preview 'git log --oneline --graph --color=always $(echo {} | sed "s/.* //" | sed "s#remotes/[^/]*/##") | head -20'
}

# =============================================================================
# Atuin（高機能シェル履歴管理）
# =============================================================================

# Atuinの初期化
# - Ctrl+R: 履歴検索（fzfライクなUI）
# - ↑: 通常の履歴検索（substring-searchと併用）
if command -v atuin &> /dev/null; then
    eval "$(atuin init zsh --disable-up-arrow)"
fi
# 注意: --disable-up-arrow で↑キーはsubstring-searchを使用
# Atuinの履歴検索は Ctrl+R で使用

# =============================================================================
# ヘルプコマンド
# =============================================================================

help() {
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                         ターミナル設定 ヘルプ                                  ║
╚══════════════════════════════════════════════════════════════════════════════╝

┌─────────────────────────────────────────────────────────────────────────────┐
│ キーボードショートカット                                                      │
└─────────────────────────────────────────────────────────────────────────────┘
  Ctrl + R        Atuin履歴検索（高機能UI）
  ↑/↓             部分一致履歴検索（入力中の文字で絞り込み）
  Ctrl + T        fzfでファイル検索
  Option + ←/→    単語単位でカーソル移動
  Ctrl + A/E      行頭/行末に移動
  Ctrl + X Ctrl+E コマンドをエディタで編集

┌─────────────────────────────────────────────────────────────────────────────┐
│ Git コマンド                                                                 │
└─────────────────────────────────────────────────────────────────────────────┘
  gs              git status
  ga              git add
  gc              git commit
  gp              git push
  gl              git log --oneline --graph
  lg              lazygit（GUI風Git操作）
  groot           Gitリポジトリのルートに移動

┌─────────────────────────────────────────────────────────────────────────────┐
│ Git + fzf（インタラクティブ選択）                                             │
└─────────────────────────────────────────────────────────────────────────────┘
  gb              ブランチ選択 → チェックアウト
  gco             コミット選択 → ハッシュをコピー
  gdf             変更ファイル選択 → diff表示
  gaf             ファイル選択 → ステージング（Tab複数選択）
  gsp             stash選択 → 適用
  gba             全ブランチ表示（リモート含む）

┌─────────────────────────────────────────────────────────────────────────────┐
│ ファイル操作                                                                 │
└─────────────────────────────────────────────────────────────────────────────┘
  ls/ll/la/lt     eza（モダンなls）
  cat/catn        bat（シンタックスハイライト付き）
  z <パス>        zoxide（学習型cd）
  fv              fzfでファイル選択 → vimで開く
  fd              fzfでディレクトリ選択 → 移動
  fh              fzfで履歴選択 → 実行
  fkill           fzfでプロセス選択 → kill
  extract <file>  圧縮ファイルを自動展開

┌─────────────────────────────────────────────────────────────────────────────┐
│ グローバルエイリアス（パイプで使用）                                           │
└─────────────────────────────────────────────────────────────────────────────┘
  L               | less      例: cat log.txt L
  G               | grep      例: history G ssh
  H               | head      例: ls | H
  T               | tail      例: ls | T
  C               | wc -l     例: ls | C
  J               | jq        例: curl api J
  X               | xargs     例: find . | X rm

┌─────────────────────────────────────────────────────────────────────────────┐
│ Python                                                                       │
└─────────────────────────────────────────────────────────────────────────────┘
  py              python
  venv            python -m venv
  activate        source .venv/bin/activate
  mkpy <name>     新規Pythonプロジェクト作成

┌─────────────────────────────────────────────────────────────────────────────┐
│ ネットワーク                                                                 │
└─────────────────────────────────────────────────────────────────────────────┘
  ip              グローバルIP表示
  localip         ローカルIP表示
  ports           使用中ポート一覧

┌─────────────────────────────────────────────────────────────────────────────┐
│ その他便利コマンド                                                            │
└─────────────────────────────────────────────────────────────────────────────┘
  r               設定再読み込み
  x               exit
  c               clear
  cpwd            カレントパスをクリップボードにコピー
  duh             ディレクトリサイズ表示
  weather [都市]  天気表示（デフォルト: Tokyo）
  timer [秒]      タイマー（デフォルト: 60秒）
  cheat <cmd>     コマンドのヘルプ表示（cheat.sh）

┌─────────────────────────────────────────────────────────────────────────────┐
│ サフィックスエイリアス（ファイル名だけで実行）                                  │
└─────────────────────────────────────────────────────────────────────────────┘
  script.py       → python script.py
  data.json       → vim data.json
  page.html       → Safariで開く

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
詳細: ~/Desktop/my-environment-settings/terminal/README.md
EOF
}

# カテゴリ別ヘルプ
help-git() {
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║                     Git コマンド ヘルプ                        ║
╚═══════════════════════════════════════════════════════════════╝

【基本コマンド】
  g               git
  gs              git status
  ga <file>       git add
  gc              git commit
  gp              git push
  gd              git diff
  gl              git log --oneline --graph
  lg              lazygit（GUI風操作）
  groot           リポジトリのルートに移動

【fzf連携（インタラクティブ選択）】
  gb              ブランチ選択 → チェックアウト
                  ・プレビューでコミット履歴表示
                  ・リモートブランチも選択可能

  gco             コミット選択 → ハッシュをコピー
                  ・cherry-pick や revert で使用

  gdf             変更ファイル選択 → diff表示
                  ・プレビューでdiff確認

  gaf             ファイル選択 → ステージング
                  ・Tab で複数選択
                  ・プレビューでdiff確認

  gsp             stash選択 → pop適用
                  ・プレビューでstash内容確認

  gba             全ブランチ表示
                  ・ローカル/リモート含む

【delta（diff美化）】
  git diff は自動的に delta でカラフル表示されます
EOF
}

help-fzf() {
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║                     fzf コマンド ヘルプ                        ║
╚═══════════════════════════════════════════════════════════════╝

【キーボードショートカット】
  Ctrl + R        Atuin履歴検索（高機能）
  Ctrl + T        ファイル検索（カレント以下）
  Alt + C         ディレクトリ移動

【fzf操作キー】
  ↑/↓             選択移動
  Enter           決定
  Tab             複数選択（gaf等で使用）
  Ctrl + C        キャンセル
  Ctrl + /        プレビュー切り替え

【カスタムコマンド】
  fv              ファイル選択 → vimで開く
  fd              ディレクトリ選択 → 移動
  fh              履歴選択 → 実行
  fkill           プロセス選択 → kill

【Git連携】
  gb              ブランチ選択
  gco             コミット選択
  gdf             diffファイル選択
  gaf             ステージングファイル選択
  gsp             stash選択
EOF
}

help-keys() {
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║                 キーボードショートカット ヘルプ                 ║
╚═══════════════════════════════════════════════════════════════╝

【履歴検索】
  Ctrl + R        Atuin履歴検索（SQLiteベース、高機能UI）
  ↑/↓             部分一致検索（入力した文字で絞り込み）
                  例: git と入力して ↑ → git関連のみ表示

【カーソル移動】
  Ctrl + A        行頭に移動
  Ctrl + E        行末に移動
  Option + ←      前の単語に移動
  Option + →      次の単語に移動

【編集】
  Ctrl + U        行頭まで削除
  Ctrl + K        行末まで削除
  Ctrl + W        単語を削除
  Ctrl + Y        削除した内容を貼り付け
  Ctrl + X Ctrl+E コマンドをエディタで編集

【fzf】
  Ctrl + T        ファイル検索
  Alt + C         ディレクトリ移動

【その他】
  Ctrl + L        画面クリア（= clear）
  Ctrl + C        コマンド中断
  Ctrl + Z        プロセスを一時停止
  Ctrl + D        ログアウト
EOF
}

alias help-all='help && echo "" && help-git && echo "" && help-fzf && echo "" && help-keys'