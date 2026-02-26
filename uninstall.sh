#!/usr/bin/env bash
# uninstall.sh — Reverse all actions performed by setup.sh
# Usage: bash uninstall.sh [--yes] [--symlinks-only]

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

log_info()  { echo -e "${BLUE}[info]${NC}  $*"; }
log_ok()    { echo -e "${GREEN}[ok]${NC}    $*"; }
log_warn()  { echo -e "${YELLOW}[warn]${NC}  $*"; }
log_error() { echo -e "${RED}[error]${NC} $*" >&2; }
log_step()  { echo -e "\n${BOLD}-- $* --${NC}"; }

# ---------------------------------------------------------------------------
# OS Detection
# ---------------------------------------------------------------------------

detect_os() {
    case "$(uname -s)" in
        Darwin) echo "macos" ;;
        Linux)  echo "linux" ;;
        *)
            log_error "Unsupported OS: $(uname -s)"
            exit 1
            ;;
    esac
}

# ---------------------------------------------------------------------------
# Stow
# ---------------------------------------------------------------------------

unstow_all() {
    log_step "Removing stow symlinks"

    local os="$1"

    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ "$line" =~ ^#.*$ || -z "${line// }" ]] && continue

        local name target_os
        read -r name target_os <<< "$line"

        if [[ "$target_os" != "both" && "$target_os" != "$os" ]]; then
            log_info "skipping $name (${target_os}-only)"
            continue
        fi

        if [[ ! -d "$DOTFILES_DIR/$name" ]]; then
            log_info "skipping $name (no stow directory)"
            continue
        fi

        if stow --dir="$DOTFILES_DIR" --target="$HOME" --delete "$name" 2>&1; then
            log_ok "$name"
        else
            log_warn "$name — stow delete failed, check for conflicts"
        fi
    done < "$DOTFILES_DIR/packages.config"
}

# ---------------------------------------------------------------------------
# macOS uninstall
# ---------------------------------------------------------------------------

uninstall_macos() {
    log_step "Removing macOS fish path entries"

    if command -v fish &>/dev/null; then
        fish -c "fish_add_path --remove /opt/homebrew/bin /opt/homebrew/sbin" 2>/dev/null \
            && log_ok "fish paths removed" \
            || log_warn "could not remove fish paths"
    else
        log_info "fish not found — skipping path removal"
    fi

    log_step "Uninstalling Homebrew casks"

    local casks=(font-hack-nerd-font)

    for cask in "${casks[@]}"; do
        if brew list --cask "$cask" &>/dev/null 2>&1; then
            log_info "Uninstalling $cask..."
            brew uninstall --cask "$cask" && log_ok "$cask" || log_warn "$cask — uninstall failed"
        else
            log_info "$cask not installed — skipping"
        fi
    done

    log_step "Uninstalling Homebrew formulas"

    local packages=(git neovim tmux curl stow fish starship eza bat fzf lazygit lazydocker gh go mongosh tree-sitter rustup himalaya)

    for pkg in "${packages[@]}"; do
        if brew list --formula "$pkg" &>/dev/null 2>&1; then
            log_info "Uninstalling $pkg..."
            brew uninstall "$pkg" && log_ok "$pkg" || log_warn "$pkg — uninstall failed"
        else
            log_info "$pkg not installed — skipping"
        fi
    done
}

# ---------------------------------------------------------------------------
# Linux uninstall
# ---------------------------------------------------------------------------

uninstall_linux() {
    log_step "Removing Linux fish path entries"

    if command -v fish &>/dev/null; then
        fish -c "fish_add_path --remove /usr/local/bin /usr/local/go/bin $HOME/.local/bin /opt/nvim-linux-x86_64/bin" 2>/dev/null \
            && log_ok "fish paths removed" \
            || log_warn "could not remove fish paths"
    else
        log_info "fish not found — skipping path removal"
    fi

    log_step "Removing manual binaries"

    local bins=(lazygit lazydocker mongosh starship)
    for bin in "${bins[@]}"; do
        if [[ -f "/usr/local/bin/$bin" ]]; then
            sudo rm -f "/usr/local/bin/$bin"
            log_ok "$bin removed from /usr/local/bin"
        else
            log_info "$bin not found — skipping"
        fi
    done

    if [[ -d /usr/local/go ]]; then
        log_info "Removing Go (/usr/local/go)..."
        sudo rm -rf /usr/local/go
        log_ok "go removed"
    else
        log_info "go not found — skipping"
    fi

    if [[ -d /opt/nvim-linux-x86_64 ]]; then
        log_info "Removing Neovim (/opt/nvim-linux-x86_64)..."
        sudo rm -rf /opt/nvim-linux-x86_64
        log_ok "neovim removed"
    else
        log_info "neovim not found — skipping"
    fi

    log_step "Removing eza apt repo"

    if [[ -f /etc/apt/keyrings/gierens.gpg ]]; then
        sudo rm -f /etc/apt/keyrings/gierens.gpg
        log_ok "gierens.gpg removed"
    fi
    if [[ -f /etc/apt/sources.list.d/gierens.list ]]; then
        sudo rm -f /etc/apt/sources.list.d/gierens.list
        log_ok "gierens.list removed"
    fi

    log_step "Uninstalling apt packages"

    local packages=(git tmux curl stow fish gpg wget bat fzf gh eza)

    for pkg in "${packages[@]}"; do
        if dpkg -s "$pkg" &>/dev/null 2>&1; then
            log_info "Uninstalling $pkg..."
            sudo apt-get remove -y "$pkg" && log_ok "$pkg" || log_warn "$pkg — uninstall failed"
        else
            log_info "$pkg not installed — skipping"
        fi
    done
}

# ---------------------------------------------------------------------------
# Post-uninstall (applies to both OSes)
# ---------------------------------------------------------------------------

post_uninstall() {
    log_step "Post-uninstall cleanup"

    # gh copilot extension
    if gh extension list 2>/dev/null | grep -q "gh-copilot"; then
        log_info "Removing gh copilot extension..."
        gh extension remove github/gh-copilot && log_ok "gh copilot removed" || log_warn "gh copilot removal failed"
    else
        log_info "gh copilot not installed — skipping"
    fi

    # TPM
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    if [[ -d "$tpm_dir" ]]; then
        rm -rf "$tpm_dir"
        log_ok "tpm removed"
    else
        log_info "tpm not found — skipping"
    fi

    # SDKMAN
    if [[ -d "$HOME/.sdkman" ]]; then
        rm -rf "$HOME/.sdkman"
        log_ok "sdkman removed"
    else
        log_info "sdkman not found — skipping"
    fi

    # Rust toolchain
    if command -v rustup &>/dev/null; then
        log_info "Uninstalling Rust toolchain via rustup..."
        rustup self uninstall -y && log_ok "rust removed" || {
            log_warn "rustup self uninstall failed — falling back to manual removal"
            rm -rf "$HOME/.cargo" "$HOME/.rustup"
            log_ok "rust removed (manual)"
        }
    elif [[ -d "$HOME/.cargo" || -d "$HOME/.rustup" ]]; then
        rm -rf "$HOME/.cargo" "$HOME/.rustup"
        log_ok "rust removed (manual)"
    else
        log_info "rust not found — skipping"
    fi

    # Hack Nerd Font (Linux only — macOS uses Homebrew cask)
    local os
    os="$(detect_os)"
    if [[ "$os" == "linux" ]]; then
        local font_dir="$HOME/.local/share/fonts"
        local font_files
        font_files=$(find "$font_dir" -name "Hack*.ttf" 2>/dev/null || true)
        if [[ -n "$font_files" ]]; then
            find "$font_dir" -name "Hack*.ttf" -delete
            fc-cache -f
            log_ok "Hack Nerd Font removed"
        else
            log_info "Hack Nerd Font not found — skipping"
        fi
    fi
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

main() {
    local yes=false
    local symlinks_only=false

    for arg in "$@"; do
        case "$arg" in
            --yes)           yes=true ;;
            --symlinks-only) symlinks_only=true ;;
            *)
                log_error "Unknown argument: $arg"
                echo "Usage: $0 [--yes] [--symlinks-only]"
                exit 1
                ;;
        esac
    done

    local os
    os="$(detect_os)"

    echo -e "${BOLD}Dotfiles Uninstall${NC}"
    echo -e "  os:       $os"
    echo -e "  dotfiles: $DOTFILES_DIR"
    echo -e "  home:     $HOME"
    echo ""

    if [[ "$symlinks_only" == true ]]; then
        echo -e "  mode:     symlinks only"
        echo ""
    else
        echo -e "This will remove symlinks, installed packages, and post-install tools."
    fi

    if [[ "$yes" == false ]]; then
        read -r -p "Continue? [y/N] " confirm
        case "$confirm" in
            [yY]) ;;
            *) log_info "Aborted."; exit 0 ;;
        esac
    fi

    unstow_all "$os"

    if [[ "$symlinks_only" == false ]]; then
        if [[ "$os" == "macos" ]]; then
            uninstall_macos
        else
            uninstall_linux
        fi

        post_uninstall
    fi

    echo ""
    log_ok "Done."
}

main "$@"
