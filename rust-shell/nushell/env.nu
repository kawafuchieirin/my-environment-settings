# Nushell Environment Config
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
