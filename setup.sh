#!/bin/bash

# =============================================================================
# macOS環境セットアップスクリプト
# 新しいMacへの移行時に現在の開発環境を復元するためのマスタースクリプト
# =============================================================================

set -e

# 色の定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# グローバル変数
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DRY_RUN=false
SHELL_TYPE=""
SETUP_MACOS=false
SETUP_VSCODE=false

# =============================================================================
# ヘルパー関数
# =============================================================================

print_header() {
    echo ""
    echo -e "${CYAN}=============================================${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}=============================================${NC}"
    echo ""
}

print_step() {
    echo -e "${BLUE}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✔ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✖ $1${NC}"
}

print_info() {
    echo -e "  $1"
}

# 確認プロンプト
confirm() {
    local message="$1"
    local default="${2:-n}"

    if [[ "$default" == "y" ]]; then
        prompt="[Y/n]"
    else
        prompt="[y/N]"
    fi

    read -p "$(echo -e "${YELLOW}$message $prompt: ${NC}")" response
    response=${response:-$default}

    [[ "$response" =~ ^[Yy]$ ]]
}

# ドライラン時のメッセージ
dry_run_msg() {
    if $DRY_RUN; then
        echo -e "${YELLOW}[DRY-RUN]${NC} $1"
        return 0
    fi
    return 1
}

# =============================================================================
# 使用方法
# =============================================================================

usage() {
    cat << EOF
使用方法: $(basename "$0") [オプション]

新しいMacに開発環境をセットアップするためのスクリプトです。

オプション:
    -h, --help          このヘルプを表示
    -d, --dry-run       実際には実行せず、何が行われるかを表示
    -z, --zsh           zsh環境をセットアップ (terminal/)
    -n, --nushell       Nushell環境をセットアップ (rust-shell/)
    -m, --macos         macOSシステム設定を適用
    -v, --vscode        VS Code設定をセットアップ
    -a, --all           すべてをセットアップ (対話モードでシェル選択)

例:
    $(basename "$0") --dry-run --all     # ドライランですべての設定を確認
    $(basename "$0") --zsh --macos       # zsh環境とmacOS設定をセットアップ
    $(basename "$0") --nushell --vscode  # Nushell環境とVS Codeをセットアップ
    $(basename "$0")                     # 対話モードで実行

EOF
    exit 0
}

# =============================================================================
# 前提条件チェック
# =============================================================================

check_prerequisites() {
    print_header "前提条件のチェック"

    # macOSかどうか確認
    if [[ "$(uname)" != "Darwin" ]]; then
        print_error "このスクリプトはmacOS専用です"
        exit 1
    fi
    print_success "macOS検出: $(sw_vers -productVersion)"

    # Apple Siliconかどうか確認
    if [[ "$(uname -m)" == "arm64" ]]; then
        print_success "Apple Silicon (ARM64) 検出"
    else
        print_warning "Intel Mac検出 - Homebrewのパスが異なる場合があります"
    fi

    # Xcode Command Line Toolsの確認
    if xcode-select -p &>/dev/null; then
        print_success "Xcode Command Line Tools: インストール済み"
    else
        print_warning "Xcode Command Line Tools: 未インストール"
        if ! $DRY_RUN; then
            print_step "Xcode Command Line Toolsをインストールしています..."
            xcode-select --install 2>/dev/null || true
            print_info "インストールダイアログが表示されます。完了後、再度このスクリプトを実行してください。"
            exit 0
        fi
    fi

    # Git確認
    if command -v git &>/dev/null; then
        print_success "Git: $(git --version | cut -d' ' -f3)"
    else
        print_error "Gitが見つかりません"
        exit 1
    fi
}

# =============================================================================
# 対話モード
# =============================================================================

interactive_mode() {
    print_header "環境セットアップウィザード"

    echo "新しいMacの開発環境をセットアップします。"
    echo ""

    # シェル環境の選択
    echo "シェル環境を選択してください:"
    echo "  1) zsh + モダンCLIツール (従来環境)"
    echo "  2) Nushell + Rust製ツール (モダン環境)"
    echo "  3) スキップ"
    echo ""
    read -p "選択 [1-3]: " shell_choice

    case $shell_choice in
        1) SHELL_TYPE="zsh" ;;
        2) SHELL_TYPE="nushell" ;;
        3) SHELL_TYPE="" ;;
        *) print_error "無効な選択です"; exit 1 ;;
    esac

    # macOS設定
    echo ""
    if confirm "macOSシステム設定を適用しますか？(キーボード、Finder、Dock等)"; then
        SETUP_MACOS=true
    fi

    # VS Code設定
    echo ""
    if confirm "VS Code設定をセットアップしますか？"; then
        SETUP_VSCODE=true
    fi

    # 確認
    echo ""
    print_header "セットアップ内容の確認"

    echo "以下の設定を行います:"
    echo ""

    if [[ -n "$SHELL_TYPE" ]]; then
        if [[ "$SHELL_TYPE" == "zsh" ]]; then
            print_info "✓ シェル環境: zsh (terminal/)"
        else
            print_info "✓ シェル環境: Nushell (rust-shell/)"
            print_warning "  注意: デフォルトシェルがNushellに変更されます"
        fi
    else
        print_info "✗ シェル環境: スキップ"
    fi

    if $SETUP_MACOS; then
        print_info "✓ macOS設定: 適用"
    else
        print_info "✗ macOS設定: スキップ"
    fi

    if $SETUP_VSCODE; then
        print_info "✓ VS Code: セットアップ"
        if ! command -v code &>/dev/null; then
            print_warning "  注意: VS Codeが見つかりません。先にインストールしてください。"
        fi
    else
        print_info "✗ VS Code: スキップ"
    fi

    echo ""
    if ! confirm "この設定で続行しますか？" "y"; then
        print_info "セットアップをキャンセルしました"
        exit 0
    fi
}

# =============================================================================
# セットアップ実行
# =============================================================================

run_shell_setup() {
    if [[ -z "$SHELL_TYPE" ]]; then
        return
    fi

    if [[ "$SHELL_TYPE" == "zsh" ]]; then
        print_header "zsh環境のセットアップ"
        local setup_script="$SCRIPT_DIR/terminal/setup.sh"
    else
        print_header "Nushell環境のセットアップ"
        local setup_script="$SCRIPT_DIR/rust-shell/setup.sh"
    fi

    if [[ ! -f "$setup_script" ]]; then
        print_error "セットアップスクリプトが見つかりません: $setup_script"
        return 1
    fi

    if dry_run_msg "実行: $setup_script"; then
        return
    fi

    chmod +x "$setup_script"
    "$setup_script"

    print_success "シェル環境のセットアップが完了しました"
}

run_macos_setup() {
    if ! $SETUP_MACOS; then
        return
    fi

    print_header "macOS設定の適用"

    local setup_script="$SCRIPT_DIR/macos/setup.sh"

    if [[ ! -f "$setup_script" ]]; then
        print_error "セットアップスクリプトが見つかりません: $setup_script"
        return 1
    fi

    if dry_run_msg "実行: $setup_script"; then
        return
    fi

    chmod +x "$setup_script"
    "$setup_script"

    print_success "macOS設定の適用が完了しました"
}

run_vscode_setup() {
    if ! $SETUP_VSCODE; then
        return
    fi

    print_header "VS Code設定のセットアップ"

    # VS Codeのインストール確認
    if ! command -v code &>/dev/null; then
        print_warning "VS Codeがインストールされていません"
        echo ""
        echo "VS Codeをインストールするには:"
        echo "  1. https://code.visualstudio.com/ からダウンロード"
        echo "  2. または: brew install --cask visual-studio-code"
        echo ""

        if confirm "Homebrewでインストールしますか？"; then
            if dry_run_msg "実行: brew install --cask visual-studio-code"; then
                return
            fi
            brew install --cask visual-studio-code
            # PATHにcodeコマンドを追加
            export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
        else
            print_info "VS Code設定をスキップします"
            return
        fi
    fi

    local setup_script="$SCRIPT_DIR/vscode/setup.sh"

    if [[ ! -f "$setup_script" ]]; then
        print_error "セットアップスクリプトが見つかりません: $setup_script"
        return 1
    fi

    if dry_run_msg "実行: $setup_script"; then
        return
    fi

    chmod +x "$setup_script"
    "$setup_script"

    print_success "VS Code設定のセットアップが完了しました"
}

# =============================================================================
# 完了メッセージ
# =============================================================================

print_completion() {
    print_header "セットアップ完了"

    echo "開発環境のセットアップが完了しました！"
    echo ""

    if [[ "$SHELL_TYPE" == "nushell" ]]; then
        echo "次のステップ:"
        echo "  1. ターミナルを再起動してください"
        echo "  2. 新しいシェル (Nushell) が起動します"
        echo ""
    elif [[ "$SHELL_TYPE" == "zsh" ]]; then
        echo "次のステップ:"
        echo "  1. ターミナルを再起動するか、'source ~/.zshrc' を実行してください"
        echo ""
    fi

    if $SETUP_MACOS; then
        echo "macOS設定の一部は再ログインまたは再起動後に反映されます。"
        echo ""
    fi

    echo "問題が発生した場合は、各ディレクトリのREADME.mdを参照してください。"
}

# =============================================================================
# メイン処理
# =============================================================================

main() {
    # 引数のパース
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                ;;
            -d|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -z|--zsh)
                SHELL_TYPE="zsh"
                shift
                ;;
            -n|--nushell)
                SHELL_TYPE="nushell"
                shift
                ;;
            -m|--macos)
                SETUP_MACOS=true
                shift
                ;;
            -v|--vscode)
                SETUP_VSCODE=true
                shift
                ;;
            -a|--all)
                SETUP_MACOS=true
                SETUP_VSCODE=true
                # シェルは対話で選択
                shift
                ;;
            *)
                print_error "不明なオプション: $1"
                usage
                ;;
        esac
    done

    # ドライランモードの表示
    if $DRY_RUN; then
        print_warning "ドライランモード: 実際には何も実行されません"
        echo ""
    fi

    # 何も指定されていない場合は対話モード
    if [[ -z "$SHELL_TYPE" ]] && ! $SETUP_MACOS && ! $SETUP_VSCODE; then
        interactive_mode
    elif [[ -z "$SHELL_TYPE" ]] && ($SETUP_MACOS || $SETUP_VSCODE); then
        # --allが指定されたがシェルが未選択の場合
        echo "シェル環境を選択してください:"
        echo "  1) zsh + モダンCLIツール (従来環境)"
        echo "  2) Nushell + Rust製ツール (モダン環境)"
        echo "  3) スキップ"
        read -p "選択 [1-3]: " shell_choice

        case $shell_choice in
            1) SHELL_TYPE="zsh" ;;
            2) SHELL_TYPE="nushell" ;;
            3) SHELL_TYPE="" ;;
            *) print_error "無効な選択です"; exit 1 ;;
        esac
    fi

    # 前提条件チェック
    check_prerequisites

    # 各セットアップの実行
    run_shell_setup
    run_macos_setup
    run_vscode_setup

    # 完了メッセージ
    if ! $DRY_RUN; then
        print_completion
    else
        echo ""
        print_warning "ドライランモードで完了しました。実際に実行するには -d オプションを外してください。"
    fi
}

# スクリプト実行
main "$@"
