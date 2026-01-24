-- ============================================
-- WezTerm 設定ファイル (初心者向け)
-- ============================================
--
-- このファイルを編集して保存すると、
-- WezTerm を再起動しなくても自動で反映されます！
--
-- 設定ファイルの場所: ~/.config/wezterm/wezterm.lua
-- ============================================

-- WezTerm の機能を読み込む
local wezterm = require 'wezterm'

-- 設定を入れる箱を用意
local config = wezterm.config_builder()

-- ============================================
-- 透過度の動的調整
-- ============================================
-- 透過度の調整幅
local opacity_step = 0.05
-- 透過度の範囲
local opacity_min = 0.2
local opacity_max = 1.0

-- 透過度を上げる (より不透明に)
wezterm.on('increase-opacity', function(window, _pane)
    local overrides = window:get_config_overrides() or {}
    local current = overrides.window_background_opacity or 0.92
    local new_opacity = math.min(current + opacity_step, opacity_max)
    overrides.window_background_opacity = new_opacity
    window:set_config_overrides(overrides)
    wezterm.log_info('Opacity: ' .. string.format('%.0f%%', new_opacity * 100))
end)

-- 透過度を下げる (より透明に)
wezterm.on('decrease-opacity', function(window, _pane)
    local overrides = window:get_config_overrides() or {}
    local current = overrides.window_background_opacity or 0.92
    local new_opacity = math.max(current - opacity_step, opacity_min)
    overrides.window_background_opacity = new_opacity
    window:set_config_overrides(overrides)
    wezterm.log_info('Opacity: ' .. string.format('%.0f%%', new_opacity * 100))
end)

-- 透過度をリセット (デフォルト値に戻す)
wezterm.on('reset-opacity', function(window, _pane)
    local overrides = window:get_config_overrides() or {}
    overrides.window_background_opacity = 0.92
    window:set_config_overrides(overrides)
    wezterm.log_info('Opacity reset to 92%')
end)

-- ============================================
-- フォント設定
-- ============================================
-- font_size: 文字の大きさ (数字を大きくすると文字が大きくなる)
config.font_size = 14.0

-- 使用するフォント (上から順に試して、見つかったものを使う)
-- 透過背景でも読みやすいように Medium ウェイトを使用
config.font = wezterm.font_with_fallback {
    { family = 'kanazawa', weight = 'Medium' },         -- メインフォント
    { family = 'JetBrains Mono', weight = 'Medium' },   -- フォールバック
    { family = 'Hack Nerd Font', weight = 'Medium' },   -- アイコン表示用
    'Menlo',                                            -- macOS 標準フォント
}

-- ============================================
-- 見た目の設定
-- ============================================
-- カラースキーム (色のテーマ)
-- 他のテーマ例: 'Dracula', 'Solarized Dark', 'One Dark', 'Catppuccin Mocha'
config.color_scheme = 'Dracula'

-- ウィンドウの透明度 (0.0=完全透明 〜 1.0=不透明)
config.window_background_opacity = 0.92

-- macOS: ウィンドウの背景ぼかし (数字が大きいほどぼかし強)
config.macos_window_background_blur = 1

-- ウィンドウの余白 (文字とウィンドウ端の間隔)
config.window_padding = {
    left = 12,
    right = 12,
    top = 12,
    bottom = 12,
}

-- ウィンドウの装飾 (RESIZE = リサイズのみ、タイトルバー非表示)
-- 元に戻したい場合は "TITLE | RESIZE" にする
config.window_decorations = "RESIZE"

-- ============================================
-- タブ設定
-- ============================================
-- タブが1つだけの時はタブバーを隠す
config.hide_tab_bar_if_only_one_tab = true

-- タブバーを下に表示 (false で上に表示)
config.tab_bar_at_bottom = true

-- シンプルなタブバーを使う (false でファンシーなデザイン)
config.use_fancy_tab_bar = false

-- ============================================
-- カーソル設定
-- ============================================
-- カーソルの形 (SteadyBar=縦線, SteadyBlock=四角, SteadyUnderline=下線)
-- Blinking〜 をつけると点滅する (例: BlinkingBar)
config.default_cursor_style = 'SteadyBar'

-- ============================================
-- シェル設定
-- ============================================
-- 起動時に使うシェル (Nushell をログインシェルとして使う)
config.default_prog = { '/opt/homebrew/bin/nu', '--login' }

-- ============================================
-- パフォーマンス設定
-- ============================================
-- GPU アクセラレーション (高速描画)
config.front_end = "WebGpu"

-- スクロールで戻れる行数
config.scrollback_lines = 10000

-- ============================================
-- キーボードショートカット
-- ============================================
-- よく使う操作をキーボードで素早く実行できます
config.keys = {
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- ペイン分割 (画面を分ける)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Cmd + D: 縦に分割 (左右に分かれる)
    {
        key = 'd',
        mods = 'CMD',
        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    -- Cmd + Shift + D: 横に分割 (上下に分かれる)
    {
        key = 'd',
        mods = 'CMD|SHIFT',
        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- ペイン操作
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Cmd + W: 今のペインを閉じる
    {
        key = 'w',
        mods = 'CMD',
        action = wezterm.action.CloseCurrentPane { confirm = true },
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- ペイン間の移動 (Cmd + 矢印キー)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Cmd + ←: 左のペインへ
    {
        key = 'LeftArrow',
        mods = 'CMD',
        action = wezterm.action.ActivatePaneDirection 'Left',
    },
    -- Cmd + →: 右のペインへ
    {
        key = 'RightArrow',
        mods = 'CMD',
        action = wezterm.action.ActivatePaneDirection 'Right',
    },
    -- Cmd + ↑: 上のペインへ
    {
        key = 'UpArrow',
        mods = 'CMD',
        action = wezterm.action.ActivatePaneDirection 'Up',
    },
    -- Cmd + ↓: 下のペインへ
    {
        key = 'DownArrow',
        mods = 'CMD',
        action = wezterm.action.ActivatePaneDirection 'Down',
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- ペインサイズの変更 (Cmd + Option + 矢印キー)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Cmd + Option + ←: ペインを左に縮小
    {
        key = 'LeftArrow',
        mods = 'CMD|OPT',
        action = wezterm.action.AdjustPaneSize { 'Left', 5 },
    },
    -- Cmd + Option + →: ペインを右に拡大
    {
        key = 'RightArrow',
        mods = 'CMD|OPT',
        action = wezterm.action.AdjustPaneSize { 'Right', 5 },
    },
    -- Cmd + Option + ↑: ペインを上に縮小
    {
        key = 'UpArrow',
        mods = 'CMD|OPT',
        action = wezterm.action.AdjustPaneSize { 'Up', 5 },
    },
    -- Cmd + Option + ↓: ペインを下に拡大
    {
        key = 'DownArrow',
        mods = 'CMD|OPT',
        action = wezterm.action.AdjustPaneSize { 'Down', 5 },
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- その他の便利なショートカット
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Cmd + K: 画面をクリア
    {
        key = 'k',
        mods = 'CMD',
        action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
    },

    -- Cmd + F: 検索モード
    {
        key = 'f',
        mods = 'CMD',
        action = wezterm.action.Search 'CurrentSelectionOrEmptyString',
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- 透過度の調整
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Ctrl + Cmd + ↑: 透過度を上げる (より不透明に)
    {
        key = 'UpArrow',
        mods = 'CTRL|CMD',
        action = wezterm.action.EmitEvent 'increase-opacity',
    },
    -- Ctrl + Cmd + ↓: 透過度を下げる (より透明に)
    {
        key = 'DownArrow',
        mods = 'CTRL|CMD',
        action = wezterm.action.EmitEvent 'decrease-opacity',
    },
    -- Ctrl + Cmd + 0: 透過度をリセット
    {
        key = '0',
        mods = 'CTRL|CMD',
        action = wezterm.action.EmitEvent 'reset-opacity',
    },
}

-- ============================================
-- 設定を適用
-- ============================================
return config

-- ============================================
-- メモ: よく使うショートカット一覧
-- ============================================
-- Cmd + T        : 新しいタブを開く
-- Cmd + W        : ペイン/タブを閉じる
-- Cmd + D        : 縦に画面分割
-- Cmd + Shift + D: 横に画面分割
-- Cmd + 矢印     : ペイン間移動
-- Cmd + K        : 画面クリア
-- Cmd + F        : 検索
-- Cmd + +        : 文字を大きく
-- Cmd + -        : 文字を小さく
-- Cmd + 0        : 文字サイズをリセット
--
-- ペインサイズの変更:
-- Cmd + Option + ←: ペインを左に縮小
-- Cmd + Option + →: ペインを右に拡大
-- Cmd + Option + ↑: ペインを上に縮小
-- Cmd + Option + ↓: ペインを下に拡大
--
-- 透過度の調整:
-- Ctrl + Cmd + ↑: 透過度を上げる (不透明に)
-- Ctrl + Cmd + ↓: 透過度を下げる (透明に)
-- Ctrl + Cmd + 0: 透過度をリセット (92%)
-- ============================================
