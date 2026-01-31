# =============================================================================
# Nushell Environment Config (env.nu)
# =============================================================================
#
# 概要:
#   Nushellの環境変数設定ファイル。PATH、プロンプト（Starship）、
#   各種ツールの環境変数を定義。config.nuより先に読み込まれる。
#
# 配置先:
#   ~/Library/Application Support/nushell/env.nu（macOS）
#   ~/.config/nushell/env.nu（Linux）
#
# PATHに追加されるディレクトリ:
#   - /opt/homebrew/bin, /opt/homebrew/sbin（Homebrew）
#   - ~/.cargo/bin（Rust/Cargo）
#   - ~/.pyenv/bin, ~/.pyenv/shims（pyenv）
#   - ~/npm-global/bin（npm global）
#   - ~/.local/bin（ユーザーローカル）
#   - /opt/homebrew/opt/fzf/bin（fzf）
#
# プロンプト:
#   Starshipを使用（$env.STARSHIP_SHELL = "nu"）
#   create_left_prompt関数でプロンプトを生成
#
# 環境変数:
#   $env.PYENV_ROOT: pyenvのルートディレクトリ
#
# カスタマイズ:
#   - PATHへの追加: | prepend '/path/to/dir' を追加
#   - 環境変数: $env.VAR_NAME = "value"
#
# 注意:
#   - env.nuはconfig.nuより先に読み込まれる
#   - プロンプト関連の設定はここで行う
#
# =============================================================================
# このファイルを ~/.config/nushell/env.nu にコピーしてください

# PATH の設定 (zsh と同等のパスを設定)
$env.PATH = (
    $env.PATH
    | split row (char esep)
    # Homebrew
    | prepend '/opt/homebrew/bin'
    | prepend '/opt/homebrew/sbin'
    # Cargo/Rust
    | prepend $'($env.HOME)/.cargo/bin'
    # pyenv
    | prepend $'($env.HOME)/.pyenv/bin'
    | prepend $'($env.HOME)/.pyenv/shims'
    # npm global
    | prepend $'($env.HOME)/npm-global/bin'
    # local bin
    | prepend $'($env.HOME)/.local/bin'
    # fzf
    | prepend '/opt/homebrew/opt/fzf/bin'
    | uniq
)

# pyenv 環境変数
$env.PYENV_ROOT = $'($env.HOME)/.pyenv'

# Starship prompt を有効化
$env.STARSHIP_SHELL = "nu"

def create_left_prompt [] {
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

$env.PROMPT_COMMAND = { || create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = ""
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_MULTILINE_INDICATOR = "::: "

# zoxide を初期化
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}
