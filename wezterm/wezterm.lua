local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- フォント
config.font = wezterm.font('JetBrains Mono')
config.font_size = 14.0

-- カラースキーム
config.color_scheme = 'Dracula'

-- ウィンドウ
config.window_decorations = 'RESIZE'
config.window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
}

-- タブ
config.hide_tab_bar_if_only_one_tab = true

-- デフォルトシェル（Nushell）
config.default_prog = { '/opt/homebrew/bin/nu', '--login' }

return config
