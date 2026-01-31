# =============================================================================
# Nushell Config File (config.nu)
# =============================================================================
#
# 概要:
#   Nushellのメイン設定ファイル。機能別に分割されたファイルを読み込む。
#
# ファイル構成:
#   config.nu     : メイン設定（このファイル）- $env.config と source
#   env.nu        : 環境変数・PATH
#   aliases.nu    : エイリアス定義
#   functions.nu  : カスタム関数
#   help.nu       : ヘルプコマンド
#   local.nu      : ローカル設定（機密情報、gitignore）
#
# 配置先:
#   ~/Library/Application Support/nushell/（macOS）
#   ~/.config/nushell/（Linux）
#
# =============================================================================

# -----------------------------------------------------------------------------
# Nushell 基本設定
# -----------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------
# 外部ツールの初期化
# -----------------------------------------------------------------------------

# zoxide の初期化
source ~/.cache/zoxide.nu

# -----------------------------------------------------------------------------
# 機能別設定ファイルの読み込み
# -----------------------------------------------------------------------------

# エイリアス
source $"($nu.default-config-dir)/aliases.nu"

# カスタム関数
source $"($nu.default-config-dir)/functions.nu"

# ヘルプコマンド
source $"($nu.default-config-dir)/help.nu"

# ローカル設定（機密情報など）
# このファイルは .gitignore に含まれ、コミットされません
# setup.sh が空のファイルを自動作成します
source $"($nu.default-config-dir)/local.nu"
