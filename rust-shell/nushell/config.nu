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

# エイリアス
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
    print r#"
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

┌─────────────────────────────────────────────────────────────────────────────┐
│ ディレクトリ移動                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
  z <パス>        履歴ベースのスマートcd（zoxide）
  zi              インタラクティブにディレクトリ選択
  skcd            ファジー検索でディレクトリ移動（skim）

┌─────────────────────────────────────────────────────────────────────────────┐
│ 検索                                                                         │
└─────────────────────────────────────────────────────────────────────────────┘
  rg <pattern>    高速テキスト検索（ripgrep）
  fd <pattern>    高速ファイル検索
  sk              ファジーファインダー（skim）
  skhist          コマンド履歴をファジー検索

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
"#
}

def help-keys [] {
    print r#"
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
"#
}

def help-helix [] {
    print r#"
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
"#
}

def help-wezterm [] {
    print r#"
╔═══════════════════════════════════════════════════════════════╗
║                  WezTerm ショートカット ヘルプ                  ║
╚═══════════════════════════════════════════════════════════════╝

【タブ操作】
  Cmd + T         新しいタブ
  Cmd + W         タブ/ペインを閉じる
  Cmd + 1-9       タブを切り替え
  Cmd + Shift + [ 前のタブ
  Cmd + Shift + ] 次のタブ

【ペイン分割】
  Cmd + D         縦にペイン分割（左右に分かれる）
  Cmd + Shift + D 横にペイン分割（上下に分かれる）

【ペイン移動】
  Cmd + ←/→/↑/↓   ペイン間を移動

【ペインサイズ変更】
  Option + Shift + ←  ペインを左に縮小
  Option + Shift + →  ペインを右に拡大
  Option + Shift + ↑  ペインを上に縮小
  Option + Shift + ↓  ペインを下に拡大

【透明度調整】
  Ctrl + Cmd + ↑  透明度を上げる（不透明に）
  Ctrl + Cmd + ↓  透明度を下げる（透明に）
  Ctrl + Cmd + 0  透明度をリセット（92%）

【その他】
  Cmd + K         スクロールバッファをクリア
  Cmd + F         検索
  Cmd + +/-       フォントサイズ変更
  Cmd + 0         フォントサイズリセット
"#
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
