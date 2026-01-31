# =============================================================================
# functions.nu - カスタム関数
# =============================================================================
# zshと共通の関数を定義
# 変更時は terminal/.zshrc と shared/config.yaml も同時に更新すること
# =============================================================================

# -----------------------------------------------------------------------------
# ディレクトリ操作
# -----------------------------------------------------------------------------

# ディレクトリ作成して移動
def --env mkcd [dir: string] {
    ^mkdir -p $dir
    cd $dir
}

# Gitリポジトリのルートに移動
def --env groot [] {
    cd (git rev-parse --show-toplevel)
}

# -----------------------------------------------------------------------------
# クリップボード
# -----------------------------------------------------------------------------

# カレントディレクトリのパスをクリップボードにコピー
def cpwd [] {
    pwd | str trim | pbcopy
    print $"パスをコピーしました: (pwd)"
}

# -----------------------------------------------------------------------------
# ネットワーク
# -----------------------------------------------------------------------------

# グローバルIP表示
def ip [] { http get https://ipinfo.io | from json }

# ローカルIP表示
def localip [] { ^ipconfig getifaddr en0 }

# 使用中ポート一覧
def ports [] { ^lsof -i -P -n | lines | find LISTEN }

# -----------------------------------------------------------------------------
# ディスク使用量
# -----------------------------------------------------------------------------

def duh [] { du | sort-by size --reverse }
def duf [] { df }

# -----------------------------------------------------------------------------
# ユーティリティ
# -----------------------------------------------------------------------------

# 天気を表示
def weather [city?: string] {
    let location = if ($city | is-empty) { "Tokyo" } else { $city }
    http get $"https://wttr.in/($location)?format=3"
}

# cheat.shでコマンドのヘルプを表示
def cheat [cmd: string] {
    http get $"https://cheat.sh/($cmd)"
}

# 指定秒数後に通知
def timer [seconds?: int] {
    let sec = if ($seconds | is-empty) { 60 } else { $seconds }
    print $"($sec)秒後に通知します..."
    sleep ($sec * 1sec)
    ^osascript -e 'display notification "タイマー完了" with title "Timer"'
    print "完了!"
}

# -----------------------------------------------------------------------------
# 圧縮ファイル展開
# -----------------------------------------------------------------------------

def extract [file: string] {
    if ($file | path exists) {
        let ext = ($file | path parse | get extension)
        match $ext {
            "zip" => { ^unzip $file },
            "gz" => {
                if ($file | str ends-with ".tar.gz") or ($file | str ends-with ".tgz") {
                    ^tar xzf $file
                } else {
                    ^gunzip $file
                }
            },
            "tgz" => { ^tar xzf $file },
            "bz2" => {
                if ($file | str ends-with ".tar.bz2") or ($file | str ends-with ".tbz2") {
                    ^tar xjf $file
                } else {
                    ^bunzip2 $file
                }
            },
            "tbz2" => { ^tar xjf $file },
            "xz" => {
                if ($file | str ends-with ".tar.xz") {
                    ^tar xJf $file
                } else {
                    ^unxz $file
                }
            },
            "tar" => { ^tar xf $file },
            "7z" => { ^7z x $file },
            "rar" => { ^unrar x $file },
            _ => { print $"'($file)' は対応していない形式です" }
        }
    } else {
        print $"'($file)' は有効なファイルではありません"
    }
}

# -----------------------------------------------------------------------------
# ファジー検索（skim）
# -----------------------------------------------------------------------------

# ファジー検索でディレクトリ移動
def --env skcd [] {
    let dir = (fd --type d | sk | str trim)
    if ($dir | is-not-empty) {
        cd $dir
    }
}

# 履歴をファジー検索
def skhist [] {
    history | get command | uniq | sk | str trim
}
