#!/usr/bin/env bash
# setup.sh — Dotfiles bootstrap for macOS and Linux
# Usage: bash setup.sh

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
# Package Installation
# ---------------------------------------------------------------------------

install_macos() {
    log_step "Installing packages via Homebrew"

    if ! command -v brew &>/dev/null; then
        log_info "Homebrew not found — installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        log_ok "brew"
    fi

    local packages=(git neovim tmux curl stow fish starship eza bat fzf lazygit lazydocker gh go mongosh tree-sitter rustup himalaya)

    for pkg in "${packages[@]}"; do
        if brew list --formula "$pkg" &>/dev/null 2>&1; then
            log_ok "$pkg already installed"
        else
            log_info "Installing $pkg..."
            brew install --quiet "$pkg"
            log_ok "$pkg"
        fi
    done

    local casks=(font-hack-nerd-font)

    for cask in "${casks[@]}"; do
        if brew list --cask "$cask" &>/dev/null 2>&1; then
            log_ok "$cask already installed"
        else
            log_info "Installing $cask..."
            brew install --quiet --cask "$cask"
            log_ok "$cask"
        fi
    done

    log_info "Setting fish paths for macOS..."
    fish -c "fish_add_path /opt/homebrew/bin /opt/homebrew/sbin"
    log_ok "fish paths set"
}

install_linux() {
    log_step "Installing packages via apt"

    sudo apt-get update -qq

    local packages=(git tmux curl stow fish gpg wget bat fzf gh)

    for pkg in "${packages[@]}"; do
        if dpkg -s "$pkg" &>/dev/null 2>&1; then
            log_ok "$pkg already installed"
        else
            log_info "Installing $pkg..."
            sudo apt-get install -y --no-install-recommends "$pkg"
            log_ok "$pkg"
        fi
    done

    # Go — latest stable from go.dev
    if command -v go &>/dev/null; then
        log_ok "go already installed"
    else
        log_info "Installing go..."
        local go_version
        go_version=$(curl -s "https://go.dev/dl/?mode=json" | grep -Po '"version": "go\K[^"]*' | head -1)
        curl -sLo go.tar.gz "https://go.dev/dl/go${go_version}.linux-amd64.tar.gz"
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf go.tar.gz
        rm go.tar.gz
        log_ok "go"
    fi

    # Neovim — latest stable from GitHub releases
    if command -v nvim &>/dev/null; then
        log_ok "neovim already installed"
    else
        log_info "Installing neovim..."
        curl -sLO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
        sudo rm -rf /opt/nvim-linux-x86_64
        sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
        rm nvim-linux-x86_64.tar.gz
        log_ok "neovim"
    fi

    # lazygit — latest stable from GitHub releases
    if command -v lazygit &>/dev/null; then
        log_ok "lazygit already installed"
    else
        log_info "Installing lazygit..."
        local lg_version
        lg_version=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -sLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${lg_version}/lazygit_${lg_version}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit -D -t /usr/local/bin/
        rm lazygit lazygit.tar.gz
        log_ok "lazygit"
    fi

    # lazydocker — latest stable from GitHub releases
    if command -v lazydocker &>/dev/null; then
        log_ok "lazydocker already installed"
    else
        log_info "Installing lazydocker..."
        local ld_version
        ld_version=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -sLo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/download/v${ld_version}/lazydocker_${ld_version}_Linux_x86_64.tar.gz"
        tar xf lazydocker.tar.gz lazydocker
        sudo install lazydocker -D -t /usr/local/bin/
        rm lazydocker lazydocker.tar.gz
        log_ok "lazydocker"
    fi

    # eza — official apt repo
    if command -v eza &>/dev/null; then
        log_ok "eza already installed"
    else
        log_info "Installing eza..."
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
            | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
            | sudo tee /etc/apt/sources.list.d/gierens.list
        sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
        sudo apt-get update -qq
        sudo apt-get install -y --no-install-recommends eza
        log_ok "eza"
    fi

    # starship
    if command -v starship &>/dev/null; then
        log_ok "starship already installed"
    else
        log_info "Installing starship..."
        curl -sS https://starship.rs/install.sh | sh -s -- --yes
        log_ok "starship"
    fi

    # Hack Nerd Font
    local font_dir="$HOME/.local/share/fonts"
    if fc-list | grep -qi "hack nerd font"; then
        log_ok "font-hack-nerd-font already installed"
    else
        log_info "Installing Hack Nerd Font..."
        mkdir -p "$font_dir"
        curl -sLo /tmp/HackNerdFont.zip \
            "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip"
        unzip -qo /tmp/HackNerdFont.zip -d "$font_dir"
        rm /tmp/HackNerdFont.zip
        fc-cache -f "$font_dir"
        log_ok "font-hack-nerd-font"
    fi

    # Rust toolchain (required for tree-sitter-cli)
    if command -v cargo &>/dev/null; then
        log_ok "rust already installed"
    else
        log_info "Installing Rust toolchain..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
        log_ok "rust"
    fi
    # shellcheck source=/dev/null
    source "$HOME/.cargo/env"

    # mongosh — latest stable from MongoDB releases
    if command -v mongosh &>/dev/null; then
        log_ok "mongosh already installed"
    else
        log_info "Installing mongosh..."
        local ms_version
        ms_version=$(curl -s "https://api.github.com/repos/mongodb-js/mongosh/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -sLo mongosh.tgz "https://github.com/mongodb-js/mongosh/releases/download/v${ms_version}/mongosh-${ms_version}-linux-x64.tgz"
        tar xf mongosh.tgz
        sudo install "mongosh-${ms_version}-linux-x64/bin/mongosh" -D -t /usr/local/bin/
        rm -rf "mongosh-${ms_version}-linux-x64" mongosh.tgz
        log_ok "mongosh"
    fi

    # tree-sitter-cli — compiled from source via cargo
    if command -v tree-sitter &>/dev/null; then
        log_ok "tree-sitter-cli already installed"
    else
        log_info "Compiling tree-sitter-cli..."
        cargo install tree-sitter-cli
        log_ok "tree-sitter-cli"
    fi

    # himalaya — compiled from source via cargo
    if command -v himalaya &>/dev/null; then
        log_ok "himalaya already installed"
    else
        log_info "Compiling himalaya..."
        cargo install himalaya
        log_ok "himalaya"
    fi

    log_info "Setting fish paths for Linux..."
    fish -c "fish_add_path /usr/local/bin /usr/local/go/bin $HOME/.local/bin /opt/nvim-linux-x86_64/bin"
    log_ok "fish paths set"
}

# ---------------------------------------------------------------------------
# Stow
# ---------------------------------------------------------------------------

stow_all() {
    log_step "Stowing packages"

    local os="$1"

    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ "$line" =~ ^#.*$ || -z "${line// }" ]] && continue

        local name target_os
        read -r name target_os <<< "$line"

        if [[ "$target_os" != "both" && "$target_os" != "$os" ]]; then
            log_info "skipping $name (${target_os}-only)"
            continue
        fi

        if stow --dir="$DOTFILES_DIR" --target="$HOME" --restow "$name" 2>&1; then
            log_ok "$name"
        else
            log_warn "$name — stow failed, check for conflicts"
        fi
    done < "$DOTFILES_DIR/packages.config"
}

# ---------------------------------------------------------------------------
# Post-install
# ---------------------------------------------------------------------------

post_install() {
    log_step "Post-install"

    # SDKMAN
    if [[ -d "$HOME/.sdkman" ]]; then
        log_ok "sdkman already installed"
    else
        log_info "Installing SDKMAN..."
        curl -s "https://get.sdkman.io" | bash
        log_ok "sdkman"
    fi

    local tpm_dir="$HOME/.tmux/plugins/tpm"
    if [[ ! -d "$tpm_dir" ]]; then
        log_info "Installing TPM (Tmux Plugin Manager)..."
        git clone --quiet https://github.com/tmux-plugins/tpm "$tpm_dir"
        log_ok "TPM installed — press Prefix+I inside tmux to load plugins"
    else
        log_ok "tpm already installed"
    fi

    # Claude Code — distributed via npm only, no binary or cargo alternative
    if command -v claude &>/dev/null; then
        log_ok "claude-code already installed"
    else
        log_warn "claude-code: install manually via npm install -g @anthropic-ai/claude-code"
    fi

    # GitHub Copilot CLI extension
    if gh extension list 2>/dev/null | grep -q "gh-copilot"; then
        log_ok "gh copilot already installed"
    else
        log_info "Installing gh copilot extension..."
        gh extension install github/gh-copilot
        log_ok "gh copilot"
    fi

    if [[ "$(basename "${SHELL:-}")" != "fish" ]]; then
        local fish_bin
        fish_bin="$(command -v fish 2>/dev/null || true)"
        [[ -n "$fish_bin" ]] && log_warn "Fish is not your default shell — run: chsh -s $fish_bin"
    else
        log_ok "fish is default shell"
    fi
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

main() {
    local os
    os="$(detect_os)"

    echo -e "${BOLD}Dotfiles Setup${NC}"
    log_info "os:       $os"
    log_info "dotfiles: $DOTFILES_DIR"
    log_info "home:     $HOME"

    if [[ "$os" == "macos" ]]; then
        install_macos
    else
        install_linux
    fi

    stow_all "$os"
    post_install

    echo ""
    log_ok "Done. Open a new shell to apply all changes."
}

main "$@"
