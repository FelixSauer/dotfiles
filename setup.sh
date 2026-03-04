#!/usr/bin/env bash
# setup.sh — Dotfiles bootstrap for macOS and Linux
# Usage: bash setup.sh

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

_setup_failed() {
    cat << 'EOF'

                                   _
 _   _  ___  _   _ _ __   ___  ___| |_ _   _ _ __
| | | |/ _ \| | | | '__| / __|/ _ \ __| | | | '_ \
| |_| | (_) | |_| | |    \__ \  __/ |_| |_| | |_) |
 \__, |\___/ \__,_|_|    |___/\___|\__|\__,_| .__/
 |___/          _            _          __  |_|
 / _|_   _  ___| | _____  __| |   ___  / _|/ _|
| |_| | | |/ __| |/ / _ \/ _` |  / _ \| |_| |_
|  _| |_| | (__|   <  __/ (_| | | (_) |  _|  _|
|_|  \__,_|\___|_|\_\___|\__,_|  \___/|_| |_|
EOF
}
trap _setup_failed ERR

RED='\033[38;2;239;89;111m'     # #ef596f
GREEN='\033[38;2;137;202;120m'  # #89ca78
YELLOW='\033[38;2;229;192;123m' # #e5c07b
BLUE='\033[38;2;97;175;239m'    # #61afef
CYAN='\033[38;2;43;186;197m'    # #2bbac5
PURPLE='\033[38;2;213;95;222m'  # #d55fde
BOLD='\033[1m'
NC='\033[0m'

log_info()  { echo -e "${BLUE}[info]${NC}  $*"; }
log_ok()    { echo -e "${GREEN}[ok]${NC}    $*"; }
log_warn()  { echo -e "${YELLOW}[warn]${NC}  $*"; }
log_error() { echo -e "${RED}[error]${NC} $*" >&2; }
log_step()  { echo -e "\n${BOLD}-- $* --${NC}"; }

# ---------------------------------------------------------------------------
# Package Definitions
# ---------------------------------------------------------------------------

# Format: "name:os:label"
ALL_PACKAGES=(
    "git:both:git"
    "neovim:both:neovim"
    "tmux:both:tmux"
    "curl:both:curl"
    "stow:both:stow"
    "fish:both:fish"
    "starship:both:starship"
    "eza:both:eza"
    "bat:both:bat"
    "fzf:both:fzf"
    "lazygit:both:lazygit"
    "lazydocker:both:lazydocker"
    "gh:both:gh (GitHub CLI)"
    "go:both:go"
    "mongosh:both:mongosh"
    "tree-sitter:both:tree-sitter-cli"
    "rustup:both:rustup / cargo"
    "posting:both:posting"
    "zoxide:both:zoxide"
    "glow:both:glow"
    "direnv:both:direnv"
    "biome:both:biome"
    "himalaya:both:himalaya (email)"
    "minesweep:both:minesweep"
    "rebels:both:rebels-in-the-sky"
    "cfspeedtest:both:cfspeedtest"
    "eilmeldung:both:eilmeldung (RSS)"
    "spotui:both:spotui"
    "font-hack-nerd-font:both:Hack Nerd Font"
    "opencode:macos:opencode"
    "ollama:macos:ollama"
    "taproom:macos:taproom"
    "sdkman:both:SDKMAN"
    "tpm:both:TPM (Tmux Plugin Manager)"
    "omf:both:oh-my-fish"
    "copilot:both:gh copilot extension"
    "stow-dotfiles:both:stow dotfiles (symlinks)"
)

SELECTED_PKGS=()

should_install() {
    local pkg="$1"
    for p in "${SELECTED_PKGS[@]}"; do
        [[ "$p" == "$pkg" ]] && return 0
    done
    return 1
}

select_packages() {
    local os="$1"
    local -a names=("__all__") labels=("Install all") selected=(1)
    local cursor=0 focus="list"
    local DIM='\033[2m'

    for entry in "${ALL_PACKAGES[@]}"; do
        local name target_os label
        IFS=: read -r name target_os label <<< "$entry"
        [[ "$target_os" != "both" && "$target_os" != "$os" ]] && continue
        names+=("$name")
        labels+=("$label")
        selected+=(1)
    done

    local count=${#names[@]}
    local term_height term_width visible sep scroll=0

    # ---------------------------------------------------------------------------
    # Detect which packages are already installed
    # ---------------------------------------------------------------------------
    echo -e "${DIM} Detecting installed packages...${NC}"

    local brew_formulae="" brew_casks=""
    if [[ "$os" == "macos" ]] && command -v brew &>/dev/null; then
        brew_formulae=$(brew list --formula 2>/dev/null || echo "")
        brew_casks=$(brew list --cask 2>/dev/null || echo "")
    fi

    local -a installed=(0)  # index 0 = "Install all" — always 0
    local i
    for (( i=1; i<count; i++ )); do
        local pkg="${names[$i]}" is_inst=0
        case "$pkg" in
            neovim)      command -v nvim &>/dev/null        && is_inst=1 || true ;;
            rustup)      command -v cargo &>/dev/null       && is_inst=1 || true ;;
            tree-sitter) command -v tree-sitter &>/dev/null && is_inst=1 || true ;;
            sdkman)      [[ -d "$HOME/.sdkman" ]]           && is_inst=1 || true ;;
            tpm)         [[ -d "$HOME/.tmux/plugins/tpm" ]] && is_inst=1 || true ;;
            omf)         [[ -d "$HOME/.local/share/omf" ]]  && is_inst=1 || true ;;
            stow-dotfiles)
                [[ -L "$HOME/.config/fish/config.fish" ]] && is_inst=1 || true ;;
            font-hack-nerd-font)
                if [[ "$os" == "macos" ]]; then
                    echo "$brew_casks" | grep -qx "font-hack-nerd-font" && is_inst=1 || true
                else
                    fc-list 2>/dev/null | grep -qi "hack nerd font" && is_inst=1 || true
                fi ;;
            taproom)
                echo "$brew_casks" | grep -qx "taproom" && is_inst=1 || true ;;
            copilot)
                command -v gh &>/dev/null \
                    && gh extension list 2>/dev/null | grep -q "gh-copilot" \
                    && is_inst=1 || true ;;
            *)
                command -v "$pkg" &>/dev/null && is_inst=1 || true ;;
        esac
        installed+=($is_inst)
    done

    # ---------------------------------------------------------------------------
    # Render + input loop
    # ---------------------------------------------------------------------------
    printf '\033[?25l\033[?1000h\033[?1006h'  # hide cursor, enable SGR mouse
    trap 'printf "\033[?25h\033[?1000l\033[?1006l"' RETURN EXIT
    clear
    while true; do
        local sz
        sz=$(stty size 2>/dev/null || echo "24 80")
        term_height=${sz% *}
        term_width=${sz#* }
        [[ $term_width -gt 120 ]] && term_width=120
        visible=$(( term_height - 15 ))
        [[ $visible -lt 2 ]] && visible=2
        sep=$(printf '%*s' "$term_width" '' | tr ' ' '-')

        local all_on=1 sel_count=0
        for (( i=1; i<count; i++ )); do
            [[ "${selected[$i]}" -eq 1 ]] && sel_count=$(( sel_count + 1 )) || true
            [[ "${selected[$i]}" -eq 0 ]] && all_on=0 || true
        done

        # Keep cursor in viewport (scroll tracks offset within items 1..count-1)
        if [[ $cursor -gt 0 ]]; then
            if [[ $cursor -le $scroll ]]; then
                scroll=$(( cursor - 1 ))
            elif [[ $cursor -gt $(( scroll + visible )) ]]; then
                scroll=$(( cursor - visible ))
            fi
        fi

        printf '\033[H'

        # Banner (4 lines + 1 blank = 5)
        printf "${CYAN}%s\033[K\n"   "    _     _    __ _ _"
        printf "${BLUE}%s\033[K\n"   " __| |___| |_ / _(_) |___ ___"
        printf "${BLUE}%s\033[K\n"   '/ _` / _ \  _|  _| | / -_|_-<'
        printf "${PURPLE}%s${NC}\033[K\n" '\__,_\___/\__|_| |_|_\___/__/'

        # Header (4 lines)
        echo -e "${BOLD} Package selection${NC}   ${DIM}${sel_count} / $(( count - 1 )) selected${NC}\033[K"
        echo -e "${DIM}${sep}${NC}\033[K"
        echo -e "${DIM} space=toggle  a=all  n=none  j/k or arrows=navigate  tab=buttons${NC}\033[K"
        echo -e "\033[K"

        # "Install all" — fixed, always visible (2 lines)
        local mark0
        [[ $all_on -eq 1 ]] && mark0="${GREEN}[x]${NC}" || mark0="${DIM}[ ]${NC}"
        if [[ "$focus" == "list" && $cursor -eq 0 ]]; then
            echo -e "  ${BOLD}>${NC} $mark0 ${BOLD}${labels[0]}${NC}\033[K"
        elif [[ $all_on -eq 1 ]]; then
            echo -e "    $mark0 ${labels[0]}\033[K"
        else
            echo -e "    $mark0 ${DIM}${labels[0]}${NC}\033[K"
        fi
        echo -e "${DIM}${sep}${NC}\033[K"

        # Scrollable package list — exactly `visible` lines (items + padding)
        local i_start=$(( scroll + 1 ))
        local i_end=$(( scroll + visible + 1 ))
        [[ $i_end -gt $count ]] && i_end=$count

        for (( i=i_start; i<i_end; i++ )); do
            local mark inst_tag=""
            [[ "${installed[$i]:-0}" -eq 1 ]] && inst_tag="${DIM}(installed)${NC}"
            if [[ "${selected[$i]}" -eq 1 ]]; then
                mark="${GREEN}[x]${NC}"
            else
                mark="${DIM}[ ]${NC}"
            fi
            if [[ "$focus" == "list" && $i -eq $cursor ]]; then
                echo -e "  ${BOLD}>${NC} $mark ${BOLD}${labels[$i]}${NC}  $inst_tag\033[K"
            elif [[ "${selected[$i]}" -eq 1 ]]; then
                echo -e "    $mark ${labels[$i]}  $inst_tag\033[K"
            else
                echo -e "    $mark ${DIM}${labels[$i]}${NC}  $inst_tag\033[K"
            fi
        done

        local j
        for (( j=i_end-i_start; j<visible; j++ )); do echo -e "\033[K"; done

        # Footer (4 lines, last without \n to prevent terminal scroll)
        echo -e "\033[K"
        echo -e "${DIM}${sep}${NC}\033[K"
        echo -e "\033[K"

        local btn_install btn_cancel
        if [[ "$focus" == "install" ]]; then
            btn_install="${BOLD}${GREEN}> [ Install ]${NC}"
            btn_cancel="${DIM}  [ Cancel ]${NC}"
        elif [[ "$focus" == "cancel" ]]; then
            btn_install="${DIM}  [ Install ]${NC}"
            btn_cancel="${BOLD}${RED}> [ Cancel ]${NC}"
        else
            btn_install="${DIM}  [ Install ]${NC}"
            btn_cancel="${DIM}  [ Cancel ]${NC}"
        fi
        echo -en "     $btn_install       $btn_cancel"

        local key="" seq=""
        IFS= read -rsn1 key

        if [[ "$key" == $'\x1b' ]]; then
            IFS= read -rsn2 -t 0.1 seq || seq=""

            if [[ "$seq" == '[<' ]]; then
                # SGR mouse event: read remainder until M (press) or m (release)
                local mseq="" mc
                while IFS= read -rsn1 -t 0.1 mc; do
                    mseq+="$mc"
                    [[ "$mc" == 'M' || "$mc" == 'm' ]] && break
                done
                # Only act on left-button press
                if [[ "${mseq: -1}" == 'M' ]]; then
                    local mnums="${mseq%?}"
                    local mb mcol mrow
                    IFS=';' read -r mb mcol mrow <<< "$mnums"
                    if [[ "$mb" == '0' ]]; then
                        local _install_all_row=9
                        local _items_start=11
                        local _items_end=$(( 10 + visible ))
                        local _buttons_row=$(( 10 + visible + 4 ))
                        if [[ "$mrow" -eq "$_install_all_row" ]]; then
                            focus="list"; cursor=0
                            local new_val=$(( 1 - all_on ))
                            for (( i=1; i<count; i++ )); do selected[$i]=$new_val; done
                        elif [[ "$mrow" -ge "$_items_start" && "$mrow" -le "$_items_end" ]]; then
                            local idx=$(( scroll + mrow - _items_start + 1 ))
                            if [[ $idx -ge 1 && $idx -lt $count ]]; then
                                cursor=$idx; focus="list"
                                selected[$idx]=$(( 1 - selected[$idx] ))
                            fi
                        elif [[ "$mrow" -eq "$_buttons_row" ]]; then
                            if [[ "$mcol" -le 25 ]]; then
                                break  # click Install
                            else
                                clear; exit 0  # click Cancel
                            fi
                        fi
                    fi
                fi
            else
                case "$seq" in
                    '[A')
                        if [[ "$focus" == "list" ]]; then
                            [[ $cursor -gt 0 ]] && cursor=$(( cursor - 1 )) || true
                        else
                            focus="list"
                            cursor=$(( count - 1 ))
                        fi
                        ;;
                    '[B')
                        if [[ "$focus" == "list" ]]; then
                            if [[ $cursor -lt $(( count - 1 )) ]]; then
                                cursor=$(( cursor + 1 ))
                            else
                                focus="install"
                            fi
                        fi
                        ;;
                    '[C') [[ "$focus" == "install" ]] && focus="cancel" || true ;;
                    '[D') [[ "$focus" == "cancel" ]] && focus="install" || true ;;
                esac
            fi
        elif [[ "$key" == ' ' && "$focus" == "list" ]]; then
            if [[ $cursor -eq 0 ]]; then
                local new_val=$(( 1 - all_on ))
                for (( i=1; i<count; i++ )); do selected[$i]=$new_val; done
            else
                selected[$cursor]=$(( 1 - selected[$cursor] ))
            fi
        elif [[ "$key" == $'\t' ]]; then
            case "$focus" in
                list)    focus="install" ;;
                install) focus="cancel" ;;
                cancel)  focus="list"; cursor=0; scroll=0 ;;
            esac
        elif [[ "$key" == 'a' && "$focus" == "list" ]]; then
            for (( i=1; i<count; i++ )); do selected[$i]=1; done
        elif [[ "$key" == 'n' && "$focus" == "list" ]]; then
            for (( i=1; i<count; i++ )); do selected[$i]=0; done
        elif [[ "$key" == 'k' && "$focus" == "list" ]]; then
            [[ $cursor -gt 0 ]] && cursor=$(( cursor - 1 )) || true
        elif [[ "$key" == 'j' && "$focus" == "list" ]]; then
            if [[ $cursor -lt $(( count - 1 )) ]]; then
                cursor=$(( cursor + 1 ))
            else
                focus="install"
            fi
        elif [[ "$key" == '' ]]; then
            if [[ "$focus" == "install" ]]; then
                break
            elif [[ "$focus" == "cancel" ]]; then
                clear
                exit 0
            fi
        fi
    done

    clear
    SELECTED_PKGS=()
    for (( i=1; i<count; i++ )); do
        [[ "${selected[$i]}" -eq 1 ]] && SELECTED_PKGS+=("${names[$i]}")
    done
}

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

    local packages=(git neovim tmux curl stow fish starship eza bat fzf lazygit lazydocker gh go mongosh tree-sitter rustup posting zoxide glow direnv biome)

    for pkg in "${packages[@]}"; do
        should_install "$pkg" || continue
        if brew list --formula "$pkg" &>/dev/null 2>&1; then
            log_ok "$pkg already installed"
        else
            log_info "Installing $pkg..."
            brew install --quiet "$pkg"
            log_ok "$pkg"
        fi
    done

    # opencode — SST tap
    if should_install "opencode"; then
        if command -v opencode &>/dev/null; then
            log_ok "opencode already installed"
        else
            log_info "Installing opencode..."
            brew tap sst/tap
            brew install --quiet opencode
            log_ok "opencode"
        fi
    fi

    # ollama — local LLM runtime
    if should_install "ollama"; then
        if command -v ollama &>/dev/null; then
            log_ok "ollama already installed"
        else
            log_info "Installing ollama..."
            brew install --quiet ollama
            log_ok "ollama"
        fi
    fi

    # cmake — build dependency for some cargo packages
    if should_install "himalaya" || should_install "minesweep" || should_install "rebels" || should_install "cfspeedtest" || should_install "eilmeldung"; then
        if ! brew list --formula cmake &>/dev/null 2>&1; then
            log_info "Installing cmake (build dependency)..."
            brew install --quiet cmake
            log_ok "cmake"
        fi
    fi

    # himalaya — needs oauth2 feature, compile via cargo
    if should_install "himalaya"; then
        if command -v himalaya &>/dev/null; then
            log_ok "himalaya already installed"
        else
            log_info "Compiling himalaya..."
            cargo install himalaya --features oauth2 --locked
            log_ok "himalaya"
        fi
    fi

    # minesweep-rs — terminal minesweeper
    if should_install "minesweep"; then
        if command -v minesweep &>/dev/null; then
            log_ok "minesweep already installed"
        else
            log_info "Compiling minesweep..."
            cargo install minesweep
            log_ok "minesweep"
        fi
    fi

    # rebels-in-the-sky — terminal space game
    if should_install "rebels"; then
        if command -v rebels &>/dev/null; then
            log_ok "rebels already installed"
        else
            log_info "Compiling rebels..."
            cargo install rebels
            log_ok "rebels"
        fi
    fi

    # cfspeedtest — Cloudflare network speed test
    if should_install "cfspeedtest"; then
        if command -v cfspeedtest &>/dev/null; then
            log_ok "cfspeedtest already installed"
        else
            log_info "Compiling cfspeedtest..."
            cargo install cfspeedtest
            log_ok "cfspeedtest"
        fi
    fi

    # eilmeldung — TUI RSS reader
    if should_install "eilmeldung"; then
        if command -v eilmeldung &>/dev/null; then
            log_ok "eilmeldung already installed"
        else
            log_info "Compiling eilmeldung..."
            cargo install eilmeldung
            log_ok "eilmeldung"
        fi
    fi

    # pipx — dependency for spotui and posting
    if should_install "spotui" || should_install "posting"; then
        if ! brew list --formula pipx &>/dev/null 2>&1; then
            log_info "Installing pipx (dependency)..."
            brew install --quiet pipx
            log_ok "pipx"
        fi
    fi

    # spotui — Spotify TUI via pipx
    if should_install "spotui"; then
        if command -v spotui &>/dev/null; then
            log_ok "spotui already installed"
        else
            log_info "Installing spotui..."
            pipx install spotui
            log_ok "spotui"
        fi
    fi

    local casks=(font-hack-nerd-font taproom)

    for cask in "${casks[@]}"; do
        should_install "$cask" || continue
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

    local packages=(git tmux curl stow fish gpg wget bat fzf gh zoxide unzip zip build-essential libclang-dev zstd libasound2-dev perl libssl-dev pkg-config libxml2-dev libsqlite3-dev direnv)

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
    if should_install "go"; then
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
    fi

    # Neovim — latest stable from GitHub releases
    if should_install "neovim"; then
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
    fi

    # lazygit — latest stable from GitHub releases
    if should_install "lazygit"; then
        if command -v lazygit &>/dev/null; then
            log_ok "lazygit already installed"
        else
            log_info "Installing lazygit..."
            local lg_version
            lg_version=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
            curl -sLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${lg_version}/lazygit_${lg_version}_Linux_x86_64.tar.gz"
            local lg_tmp; lg_tmp=$(mktemp -d)
            tar xf lazygit.tar.gz -C "$lg_tmp"
            sudo install "$lg_tmp/lazygit" -D -t /usr/local/bin/
            rm -rf "$lg_tmp" lazygit.tar.gz
            log_ok "lazygit"
        fi
    fi

    # lazydocker — latest stable from GitHub releases
    if should_install "lazydocker"; then
        if command -v lazydocker &>/dev/null; then
            log_ok "lazydocker already installed"
        else
            log_info "Installing lazydocker..."
            local ld_version
            ld_version=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
            curl -sLo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/download/v${ld_version}/lazydocker_${ld_version}_Linux_x86_64.tar.gz"
            local ld_tmp; ld_tmp=$(mktemp -d)
            tar xf lazydocker.tar.gz -C "$ld_tmp"
            sudo install "$ld_tmp/lazydocker" -D -t /usr/local/bin/
            rm -rf "$ld_tmp" lazydocker.tar.gz
            log_ok "lazydocker"
        fi
    fi

    # eza — official apt repo
    if should_install "eza"; then
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
    fi

    # starship
    if should_install "starship"; then
        if command -v starship &>/dev/null; then
            log_ok "starship already installed"
        else
            log_info "Installing starship..."
            curl -sS https://starship.rs/install.sh | sh -s -- --yes
            log_ok "starship"
        fi
    fi

    # Hack Nerd Font
    if should_install "font-hack-nerd-font"; then
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
    fi

    # Rust toolchain (required for tree-sitter-cli)
    if should_install "rustup"; then
        if command -v cargo &>/dev/null; then
            log_ok "rust already installed"
        else
            log_info "Installing Rust toolchain..."
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
            log_ok "rust"
        fi
    fi
    # shellcheck source=/dev/null
    [[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

    # mongosh — latest stable from MongoDB releases
    if should_install "mongosh"; then
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
    fi

    # tree-sitter-cli — compiled from source via cargo
    if should_install "tree-sitter"; then
        if command -v tree-sitter &>/dev/null; then
            log_ok "tree-sitter-cli already installed"
        else
            log_info "Compiling tree-sitter-cli..."
            cargo install tree-sitter-cli
            log_ok "tree-sitter-cli"
        fi
    fi

    # cmake — build dependency for some cargo packages
    if should_install "himalaya" || should_install "minesweep" || should_install "rebels" || should_install "cfspeedtest" || should_install "eilmeldung"; then
        if ! dpkg -s cmake &>/dev/null 2>&1; then
            log_info "Installing cmake (build dependency)..."
            sudo apt-get install -y --no-install-recommends cmake
            log_ok "cmake"
        fi
    fi

    # himalaya — compiled from source via cargo
    if should_install "himalaya"; then
        if command -v himalaya &>/dev/null; then
            log_ok "himalaya already installed"
        else
            log_info "Compiling himalaya..."
            cargo install himalaya --features oauth2 --locked
            log_ok "himalaya"
        fi
    fi

    # minesweep-rs — terminal minesweeper
    if should_install "minesweep"; then
        if command -v minesweep &>/dev/null; then
            log_ok "minesweep already installed"
        else
            log_info "Compiling minesweep..."
            cargo install minesweep
            log_ok "minesweep"
        fi
    fi

    # rebels-in-the-sky — terminal space game
    if should_install "rebels"; then
        if command -v rebels &>/dev/null; then
            log_ok "rebels already installed"
        else
            log_info "Compiling rebels..."
            cargo install rebels
            log_ok "rebels"
        fi
    fi

    # cfspeedtest — Cloudflare network speed test
    if should_install "cfspeedtest"; then
        if command -v cfspeedtest &>/dev/null; then
            log_ok "cfspeedtest already installed"
        else
            log_info "Compiling cfspeedtest..."
            cargo install cfspeedtest
            log_ok "cfspeedtest"
        fi
    fi

    # eilmeldung — TUI RSS reader
    if should_install "eilmeldung"; then
        if command -v eilmeldung &>/dev/null; then
            log_ok "eilmeldung already installed"
        else
            log_info "Compiling eilmeldung..."
            cargo install eilmeldung
            log_ok "eilmeldung"
        fi
    fi

    # pipx — dependency for spotui and posting
    if should_install "spotui" || should_install "posting"; then
        if ! dpkg -s pipx &>/dev/null 2>&1; then
            log_info "Installing pipx (dependency)..."
            sudo apt-get install -y --no-install-recommends pipx
            log_ok "pipx"
        fi
    fi

    # spotui — Spotify TUI via pipx
    if should_install "spotui"; then
        if command -v spotui &>/dev/null; then
            log_ok "spotui already installed"
        else
            log_info "Installing spotui..."
            pipx install spotui
            log_ok "spotui"
        fi
    fi

    # glow — markdown renderer from GitHub releases
    if should_install "glow"; then
        if command -v glow &>/dev/null; then
            log_ok "glow already installed"
        else
            log_info "Installing glow..."
            local glow_version
            glow_version=$(curl -s "https://api.github.com/repos/charmbracelet/glow/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
            curl -sLo glow.tar.gz "https://github.com/charmbracelet/glow/releases/download/v${glow_version}/glow_${glow_version}_linux_x86_64.tar.gz"
            local glow_tmp; glow_tmp=$(mktemp -d)
            tar xf glow.tar.gz -C "$glow_tmp"
            find "$glow_tmp" -name glow -type f -executable -exec sudo install {} -D -t /usr/local/bin/ \;
            rm -rf "$glow_tmp" glow.tar.gz
            log_ok "glow"
        fi
    fi

    # biome — fast formatter and linter for web projects
    if should_install "biome"; then
        if command -v biome &>/dev/null; then
            log_ok "biome already installed"
        else
            log_info "Installing biome..."
            local biome_version
            biome_version=$(curl -s "https://api.github.com/repos/biomejs/biome/releases/latest" | grep -Po '"tag_name": "cli/v\K[^"]*')
            curl -sLo /tmp/biome "https://github.com/biomejs/biome/releases/download/cli/v${biome_version}/biome-linux-x64"
            sudo install /tmp/biome -D -t /usr/local/bin/
            rm /tmp/biome
            log_ok "biome"
        fi
    fi

    # posting — TUI HTTP client via pipx
    if should_install "posting"; then
        if command -v posting &>/dev/null; then
            log_ok "posting already installed"
        else
            log_info "Installing posting..."
            pipx install posting
            log_ok "posting"
        fi
    fi

    log_info "Setting fish paths for Linux..."
    fish -c "fish_add_path /usr/local/bin /usr/local/go/bin $HOME/.local/bin /opt/nvim-linux-x86_64/bin $HOME/.cargo/bin"
    log_ok "fish paths set"
}

# ---------------------------------------------------------------------------
# Stow
# ---------------------------------------------------------------------------

stow_all() {
    should_install "stow-dotfiles" || return 0

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
    if should_install "sdkman"; then
        if [[ -d "$HOME/.sdkman" ]]; then
            log_ok "sdkman already installed"
        else
            log_info "Installing SDKMAN..."
            curl -s "https://get.sdkman.io" | bash
            log_ok "sdkman"
        fi
    fi

    # TPM
    if should_install "tpm"; then
        local tpm_dir="$HOME/.tmux/plugins/tpm"
        if [[ ! -d "$tpm_dir" ]]; then
            log_info "Installing TPM (Tmux Plugin Manager)..."
            git clone --quiet https://github.com/tmux-plugins/tpm "$tpm_dir"
            log_ok "TPM installed — press Prefix+I inside tmux to load plugins"
        else
            log_ok "tpm already installed"
        fi
    fi

    # oh-my-fish — Fish shell framework
    if should_install "omf"; then
        if [[ -d "$HOME/.local/share/omf" ]]; then
            log_ok "oh-my-fish already installed"
        else
            log_info "Installing oh-my-fish..."
            curl -sL https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
            log_ok "oh-my-fish"
        fi
    fi

    # Ollama — apply custom Modelfiles
    if command -v ollama &>/dev/null; then
        log_info "Applying Ollama Modelfiles..."
        for modelfile in "$DOTFILES_DIR"/ollama/*.Modelfile; do
            [[ -f "$modelfile" ]] || continue
            local base model_tag
            base=$(basename "$modelfile" .Modelfile)
            model_tag="${base%-*}:${base##*-}"
            ollama create "$model_tag" -f "$modelfile" &>/dev/null && log_ok "ollama: $model_tag" || log_warn "ollama: $model_tag failed"
        done
    else
        log_warn "ollama not found — skipping Modelfiles"
    fi

    # Claude Code — distributed via npm only, no binary or cargo alternative
    if command -v claude &>/dev/null; then
        log_ok "claude-code already installed"
    else
        log_warn "claude-code: install manually via npm install -g @anthropic-ai/claude-code"
    fi

    # GitHub Copilot CLI extension
    if should_install "copilot"; then
        if gh extension list 2>/dev/null | grep -q "gh-copilot"; then
            log_ok "gh copilot already installed"
        else
            if gh auth status &>/dev/null; then
                log_info "Installing gh copilot extension..."
                gh extension install github/gh-copilot
                log_ok "gh copilot"
            else
                log_warn "gh copilot: run 'gh auth login' first"
            fi
        fi
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

    select_packages "$os"

    if [[ "$os" == "macos" ]]; then
        install_macos
    else
        install_linux
    fi

    stow_all "$os"
    post_install

    cat << 'EOF'

                                                         _
  __ ___      _____  ___  ___  _ __ ___   ___   ___  ___| |_ _   _ _ __
 / _` \ \ /\ / / _ \/ __|/ _ \| '_ ` _ \ / _ \ / __|/ _ \ __| | | | '_ \
| (_| |\ V  V /  __/\__ \ (_) | | | | | |  __/ \__ \  __/ |_| |_| | |_) |
 \__,_| \_/\_/ \___||___/\___/|_| |_| |_|\___| |___/\___|\__|\__,_| .__/
                                                      __       _  |_|
__      ____ _ ___   ___ _   _  ___ ___ ___  ___ ___ / _|_   _| | | |
\ \ /\ / / _` / __| / __| | | |/ __/ __/ _ \/ __/ __| |_| | | | | | |
 \ V  V / (_| \__ \ \__ \ |_| | (_| (_|  __/\__ \__ \  _| |_| | | |_|
  \_/\_/ \__,_|___/ |___/\__,_|\___\___\___||___/___/_|  \__,_|_| (_)
EOF

    log_ok "Open a new shell to apply all changes."
}

main "$@"
