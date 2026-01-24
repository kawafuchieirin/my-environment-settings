# Nushell Config File
# このファイルを ~/.config/nushell/config.nu にコピーしてください

$env.config = {
    show_banner: false

    ls: {
        use_ls_colors: true
        clickable_links: true
    }

    rm: {
        always_trash: true
    }

    table: {
        mode: rounded
        index_mode: always
        show_empty: true
        padding: { left: 1, right: 1 }
        trim: {
            methodology: wrapping
            wrapping_try_keep_words: true
            truncating_suffix: "..."
        }
        header_on_separator: false
    }

    error_style: "fancy"

    history: {
        max_size: 100_000
        sync_on_enter: true
        file_format: "sqlite"
        isolation: false
    }

    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "prefix"
        external: {
            enable: true
            max_results: 100
            completer: null
        }
    }

    cursor_shape: {
        vi_insert: line
        vi_normal: block
        emacs: line
    }

    color_config: {
        separator: white
        leading_trailing_space_bg: { attr: n }
        header: green_bold
        empty: blue
        bool: light_cyan
        int: white
        filesize: cyan
        duration: white
        date: purple
        range: white
        float: white
        string: white
        nothing: white
        binary: white
        cell-path: white
        row_index: green_bold
        record: white
        list: white
        block: white
        hints: dark_gray
        search_result: { bg: red fg: white }
        shape_and: purple_bold
        shape_binary: purple_bold
        shape_block: blue_bold
        shape_bool: light_cyan
        shape_closure: green_bold
        shape_custom: green
        shape_datetime: cyan_bold
        shape_directory: cyan
        shape_external: cyan
        shape_externalarg: green_bold
        shape_filepath: cyan
        shape_flag: blue_bold
        shape_float: purple_bold
        shape_garbage: { fg: white bg: red attr: b}
        shape_globpattern: cyan_bold
        shape_int: purple_bold
        shape_internalcall: cyan_bold
        shape_list: cyan_bold
        shape_literal: blue
        shape_match_pattern: green
        shape_matching_brackets: { attr: u }
        shape_nothing: light_cyan
        shape_operator: yellow
        shape_or: purple_bold
        shape_pipe: purple_bold
        shape_range: yellow_bold
        shape_record: cyan_bold
        shape_redirection: purple_bold
        shape_signature: green_bold
        shape_string: green
        shape_string_interpolation: cyan_bold
        shape_table: blue_bold
        shape_variable: purple
        shape_vardecl: purple
    }

    footer_mode: 25
    float_precision: 2
    buffer_editor: "hx"
    use_ansi_coloring: true
    bracketed_paste: true
    edit_mode: vi
    shell_integration: {
        osc2: true
        osc7: true
        osc8: true
        osc9_9: false
        osc133: true
        osc633: true
        reset_application_mode: true
    }
    render_right_prompt_on_last_line: false
    use_kitty_protocol: false
    highlight_resolved_externals: false
}

# =============================================================================
# エイリアス
# =============================================================================

# 基本
alias ll = ls -l
alias la = ls -a
alias lla = ls -la
alias cat = bat
alias grep = rg
alias ff = fd      # find files (fd) - Nushell の find はビルトイン
alias top = btop
alias vim = hx
alias vi = hx
alias rdock = killall Dock  # Dockを再起動

# Git
alias g = git
alias gs = git status
alias ga = git add
alias gc = git commit
alias gp = git push
alias gl = git log --oneline --graph
alias gd = git diff
alias lg = lazygit

# Python
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

# ディレクトリ操作
alias mkdir = ^mkdir -p

# その他
alias c = clear
alias cc = claude --dangerously-skip-permissions
alias h = history
alias x = exit
alias tl = tldr
alias j = jq

# クリップボード
alias pbp = pbpaste
alias pbc = pbcopy

# ネットワーク
def ip [] { http get https://ipinfo.io | from json }
def localip [] { ^ipconfig getifaddr en0 }
def ports [] { ^lsof -i -P -n | lines | find LISTEN }

# ディスク使用量
def duh [] { du | sort-by size --reverse }
def duf [] { df }

# パイプ用コマンド（zshのグローバルエイリアス相当）
def G [pattern: string] { rg $pattern }           # grep
def H [n: int = 10] { first $n }                  # head
def T [n: int = 10] { last $n }                   # tail
def J [...path: string] { if ($path | is-empty) { from json } else { from json | get ($path | str join ".") } }  # jq

# エディタ
alias C = ^open -a Cursor .                        # Cursorでカレントディレクトリを開く

# =============================================================================
# 便利な関数
# =============================================================================

# ディレクトリ作成して移動
def --env mkcd [dir: string] {
    ^mkdir -p $dir
    cd $dir
}

# Gitリポジトリのルートに移動
def --env groot [] {
    cd (git rev-parse --show-toplevel)
}

# カレントディレクトリのパスをクリップボードにコピー
def cpwd [] {
    pwd | str trim | pbcopy
    print $"パスをコピーしました: (pwd)"
}

# 天気を表示
def weather [city?: string] {
    let location = if ($city | is-empty) { "Tokyo" } else { $city }
    http get $"https://wttr.in/($location)?format=3"
}

# cheat.shでコマンドのヘルプを表示
def cheat [cmd: string] {
    http get $"https://cheat.sh/($cmd)"
}

# 圧縮ファイルを自動展開
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

# 指定秒数後に通知
def timer [seconds?: int] {
    let sec = if ($seconds | is-empty) { 60 } else { $seconds }
    print $"($sec)秒後に通知します..."
    sleep ($sec * 1sec)
    ^osascript -e 'display notification "タイマー完了" with title "Timer"'
    print "完了!"
}

# zoxide の初期化
source ~/.cache/zoxide.nu

# skim (sk) を使ったファジー検索
def skcd [] {
    let dir = (fd --type d | sk | str trim)
    if ($dir | is-not-empty) {
        cd $dir
    }
}

def skhist [] {
    history | get command | uniq | sk | str trim
}

# =============================================================================
# ヘルプコマンド
# =============================================================================

def help [] {
    print r#'
╔══════════════════════════════════════════════════════════════════════════════╗
║                         Rust Shell ヘルプ                                     ║
╚══════════════════════════════════════════════════════════════════════════════╝

┌─────────────────────────────────────────────────────────────────────────────┐
│ エイリアス                                                                    │
└─────────────────────────────────────────────────────────────────────────────┘
  ll              ls -l（詳細表示）
  la              ls -a（隠しファイル表示）
  lla             ls -la（詳細 + 隠しファイル）
  cat             bat（シンタックスハイライト付き）
  grep            rg（ripgrep）
  ff              fd（ファイル検索）
  top             btop（リソースモニター）
  vim / vi        hx（Helixエディタ）
  c               clear（画面クリア）
  h               history（履歴表示）
  x               exit（終了）

┌─────────────────────────────────────────────────────────────────────────────┐
│ Git コマンド                                                                  │
└─────────────────────────────────────────────────────────────────────────────┘
  g               git
  gs              git status
  ga              git add
  gc              git commit
  gp              git push
  gd              git diff
  gl              git log --oneline --graph
  lg              lazygit（GUI風Git操作）
  groot           Gitリポジトリのルートに移動

┌─────────────────────────────────────────────────────────────────────────────┐
│ Python                                                                        │
└─────────────────────────────────────────────────────────────────────────────┘
  py              python
  py3             python3
  venv            python -m venv（仮想環境作成）
  activate        仮想環境を有効化（.venv）

┌─────────────────────────────────────────────────────────────────────────────┐
│ ディレクトリ移動                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
  z <パス>        履歴ベースのスマートcd（zoxide）
  zi              インタラクティブにディレクトリ選択
  skcd            ファジー検索でディレクトリ移動（skim）
  mkcd <dir>      ディレクトリ作成して移動
  groot           Gitリポジトリのルートに移動

┌─────────────────────────────────────────────────────────────────────────────┐
│ 検索                                                                         │
└─────────────────────────────────────────────────────────────────────────────┘
  rg <pattern>    高速テキスト検索（ripgrep）
  fd <pattern>    高速ファイル検索
  sk              ファジーファインダー（skim）
  skhist          コマンド履歴をファジー検索

┌─────────────────────────────────────────────────────────────────────────────┐
│ ネットワーク                                                                  │
└─────────────────────────────────────────────────────────────────────────────┘
  ip              グローバルIP表示
  localip         ローカルIP表示
  ports           使用中ポート一覧

┌─────────────────────────────────────────────────────────────────────────────┐
│ その他便利コマンド                                                            │
└─────────────────────────────────────────────────────────────────────────────┘
  cpwd            カレントパスをクリップボードにコピー
  duh             ディレクトリサイズ表示
  duf             ディスク使用量表示
  weather [都市]  天気表示（デフォルト: Tokyo）
  timer [秒]      タイマー（デフォルト: 60秒）
  cheat <cmd>     コマンドのヘルプ表示（cheat.sh）
  extract <file>  圧縮ファイルを自動展開
  tl              tldr（コマンドの使い方を簡潔に表示）
  j               jq（JSONパーサー）
  pbp / pbc       クリップボード（ペースト/コピー）

┌─────────────────────────────────────────────────────────────────────────────┐
│ パイプ用コマンド                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
  | G <pattern>   grep（例: ls | G txt）
  | H [n]         head（例: ls | H 5）
  | T [n]         tail（例: ls | T 5）
  | C             count（例: ls | C）
  | J [key]       jq（例: open file.json | J data）

┌─────────────────────────────────────────────────────────────────────────────┐
│ Nushell 基本操作                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
  ls | where size > 1mb       ファイルをフィルタリング
  open file.json              JSON/YAML/TOMLを構造化データとして開く
  open file.json | get key    特定のキーを取得
  ls | to json                テーブルをJSONに変換
  http get <url>              HTTPリクエスト
  history | where command =~ "git"    履歴を検索

┌─────────────────────────────────────────────────────────────────────────────┐
│ カテゴリ別ヘルプ                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
  help-keys       キーボードショートカット
  help-helix      Helixエディタの操作
  help-wezterm    WezTermのショートカット
  help-all        全てのヘルプを表示

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
詳細: rust-shell/README.md
'#
}

def help-keys [] {
    print r#'
╔═══════════════════════════════════════════════════════════════╗
║                 キーボードショートカット ヘルプ                 ║
╚═══════════════════════════════════════════════════════════════╝

【Nushell - Viモード】
  Esc             ノーマルモードに切り替え
  i               挿入モード（カーソル前）
  a               挿入モード（カーソル後）
  w / b           単語単位で移動
  0 / $           行頭 / 行末に移動
  dd              行を削除
  yy              行をコピー
  p               ペースト
  u               元に戻す
  /               検索

【Nushell - 共通】
  Ctrl + R        履歴検索
  Ctrl + C        コマンド中断
  Ctrl + D        終了
  Ctrl + L        画面クリア
  Tab             補完
'#
}

def help-helix [] {
    print r#'
╔═══════════════════════════════════════════════════════════════╗
║                   Helix エディタ ヘルプ                        ║
╚═══════════════════════════════════════════════════════════════╝

【起動】
  hx <file>       ファイルを開く
  hx .            カレントディレクトリを開く

【基本操作（ノーマルモード）】
  i / a           挿入モード（カーソル前/後）
  o / O           下/上に新しい行を追加して挿入モード
  Esc             ノーマルモードに戻る
  w / b           次/前の単語へ移動
  gg / ge         ファイル先頭/末尾へ
  x               行を選択
  d               選択範囲を削除
  y               選択範囲をコピー
  p               ペースト
  u / U           元に戻す / やり直し
  / / n / N       検索 / 次 / 前

【Spaceメニュー（Spaceキーを押す）】
  Space + f       ファイルピッカー
  Space + b       バッファピッカー
  Space + s       シンボルピッカー
  Space + w + v   縦分割
  Space + w + s   横分割
  Space + w + q   ウィンドウを閉じる

【LSP操作】
  gd              定義へジャンプ
  gr              参照を表示
  Space + l + r   リネーム
  Space + l + a   コードアクション

【保存・終了】
  Ctrl + s        保存
  Ctrl + q        終了
  :w / :q / :wq   保存 / 終了 / 保存して終了
'#
}

def help-wezterm [] {
    print r#'
╔═══════════════════════════════════════════════════════════════╗
║                  WezTerm ショートカット ヘルプ                  ║
╚═══════════════════════════════════════════════════════════════╝

【タブ操作】
  Cmd + T         新しいタブ
  Cmd + D         新しいタブ
  Cmd + W         タブを閉じる
  Cmd + ←/→       前/次のタブへ移動
  Cmd + 1-9       タブを番号で切り替え

【透明度調整】
  Ctrl + Cmd + ↑  透明度を上げる（不透明に）
  Ctrl + Cmd + ↓  透明度を下げる（透明に）
  Ctrl + Cmd + 0  透明度をリセット（92%）

【その他】
  Cmd + K         スクロールバッファをクリア
  Cmd + F         検索
  Cmd + +/-       フォントサイズ変更
  Cmd + 0         フォントサイズリセット
'#
}

def help-all [] {
    help
    print ""
    help-keys
    print ""
    help-helix
    print ""
    help-wezterm
}
