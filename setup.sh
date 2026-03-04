#!/usr/bin/env bash
# setup.sh — Dotfiles bootstrap for macOS and Linux
# Usage: bash setup.sh

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

_setup_failed() {
  cat <<'EOF'

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

log_info() { echo -e "${BLUE}[info]${NC}  $*"; }
log_ok() { echo -e "${GREEN}[ok]${NC}    $*"; }
log_warn() { echo -e "${YELLOW}[warn]${NC}  $*"; }
log_error() { echo -e "${RED}[error]${NC} $*" >&2; }
log_step() { echo -e "\n${BOLD}-- $* --${NC}"; }

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------
SDKMAN_DIR="$HOME/.sdkman"
TPM_DIR="$HOME/.tmux/plugins/tpm"
OMF_DIR="$HOME/.local/share/omf"
FONTS_DIR="$HOME/.local/share/fonts"
NVIM_DIR="/opt/nvim-linux-x86_64"

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
  "direnv:both:direnv"
  "biome:both:biome"
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

_in_list() {
  local pkg="$1"; shift
  local p
  for p in "$@"; do [[ "$p" == "$pkg" ]] && return 0; done
  return 1
}

SELECTED_PKGS=()
should_install()   { _in_list "$1" "${SELECTED_PKGS[@]+"${SELECTED_PKGS[@]}"}"; }

UNINSTALL_PKGS=()
should_uninstall() { _in_list "$1" "${UNINSTALL_PKGS[@]+"${UNINSTALL_PKGS[@]}"}"; }

# ---------------------------------------------------------------------------
# Package helpers
# ---------------------------------------------------------------------------

brew_install() {
  local pkg="$1"
  should_install "$pkg" || return 0
  if brew list --formula "$pkg" &>/dev/null 2>&1; then
    log_ok "$pkg already installed"
  else
    log_info "Installing $pkg..."
    brew install --quiet "$pkg" && log_ok "$pkg"
  fi
}

brew_cask_install() {
  local cask="$1"
  should_install "$cask" || return 0
  if brew list --cask "$cask" &>/dev/null 2>&1; then
    log_ok "$cask already installed"
  else
    log_info "Installing $cask..."
    brew install --quiet --cask "$cask" && log_ok "$cask"
  fi
}

brew_uninstall() {
  local pkg="$1"
  should_uninstall "$pkg" || return 0
  brew list --formula "$pkg" &>/dev/null 2>&1 || return 0
  log_info "Uninstalling $pkg..."
  brew uninstall "$pkg" && log_ok "$pkg removed" || log_warn "$pkg — uninstall failed"
}

brew_cask_uninstall() {
  local cask="$1"
  should_uninstall "$cask" || return 0
  brew list --cask "$cask" &>/dev/null 2>&1 || return 0
  log_info "Uninstalling cask $cask..."
  brew uninstall --cask "$cask" && log_ok "$cask removed" || log_warn "$cask — uninstall failed"
}

cargo_install() {
  local pkg="$1"
  should_install "$pkg" || return 0
  if command -v "$pkg" &>/dev/null; then
    log_ok "$pkg already installed"
  else
    log_info "Compiling $pkg..."
    cargo install "$pkg" && log_ok "$pkg"
  fi
}

cargo_uninstall() {
  local pkg="$1"
  should_uninstall "$pkg" || return 0
  command -v "$pkg" &>/dev/null || return 0
  log_info "Uninstalling $pkg via cargo..."
  cargo uninstall "$pkg" && log_ok "$pkg removed" || log_warn "$pkg — cargo uninstall failed"
}

pipx_install() {
  local pkg="$1"
  should_install "$pkg" || return 0
  if command -v "$pkg" &>/dev/null; then
    log_ok "$pkg already installed"
  else
    log_info "Installing $pkg..."
    pipx install "$pkg" && log_ok "$pkg"
  fi
}

pipx_uninstall() {
  local pkg="$1"
  should_uninstall "$pkg" || return 0
  command -v pipx &>/dev/null && pipx list 2>/dev/null | grep -q "$pkg" || return 0
  log_info "Uninstalling $pkg via pipx..."
  pipx uninstall "$pkg" && log_ok "$pkg removed" || log_warn "$pkg — pipx uninstall failed"
}

github_latest_version() {
  # $1: "owner/repo"  $2: tag prefix (default "v")
  local repo="$1" prefix="${2:-v}"
  curl -s "https://api.github.com/repos/${repo}/releases/latest" \
    | grep -Po "\"tag_name\": \"${prefix}\K[^\"]+"
}

select_packages() {
  local os="$1"
  local -a names=("__all__") labels=("Install all") selected=(1)
  local cursor=0 focus="list"
  local DIM='\033[2m'

  for entry in "${ALL_PACKAGES[@]}"; do
    local name target_os label
    IFS=: read -r name target_os label <<<"$entry"
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

  local -a installed=(0) # index 0 = "Install all" — always 0
  local i
  for ((i = 1; i < count; i++)); do
    local pkg="${names[$i]}" is_inst=0
    case "$pkg" in
    neovim) command -v nvim &>/dev/null && is_inst=1 || true ;;
    rustup) command -v cargo &>/dev/null && is_inst=1 || true ;;
    tree-sitter) command -v tree-sitter &>/dev/null && is_inst=1 || true ;;
    sdkman) [[ -d "$SDKMAN_DIR" ]] && is_inst=1 || true ;;
    tpm) [[ -d "$TPM_DIR" ]] && is_inst=1 || true ;;
    omf) [[ -d "$OMF_DIR" ]] && is_inst=1 || true ;;
    stow-dotfiles)
      [[ -L "$HOME/.config/fish/config.fish" ]] && is_inst=1 || true
      ;;
    font-hack-nerd-font)
      if [[ "$os" == "macos" ]]; then
        echo "$brew_casks" | grep -qx "font-hack-nerd-font" && is_inst=1 || true
      else
        fc-list 2>/dev/null | grep -qi "hack nerd font" && is_inst=1 || true
      fi
      ;;
    taproom)
      echo "$brew_casks" | grep -qx "taproom" && is_inst=1 || true
      ;;
    copilot)
      command -v gh &>/dev/null &&
        gh extension list 2>/dev/null | grep -q "gh-copilot" &&
        is_inst=1 || true
      ;;
    *)
      command -v "$pkg" &>/dev/null && is_inst=1 || true
      ;;
    esac
    installed+=($is_inst)
    selected[$i]=$is_inst
  done

  # ---------------------------------------------------------------------------
  # Render + input loop
  # ---------------------------------------------------------------------------
  printf '\033[?25l\033[?1000h\033[?1006h' # hide cursor, enable SGR mouse
  trap 'printf "\033[?25h\033[?1000l\033[?1006l"' RETURN EXIT
  clear
  while true; do
    local sz
    sz=$(stty size 2>/dev/null || echo "24 80")
    term_height=${sz% *}
    term_width=${sz#* }
    [[ $term_width -gt 120 ]] && term_width=120
    visible=$((term_height - 15))
    [[ $visible -lt 2 ]] && visible=2
    sep=$(printf '%*s' "$term_width" '' | tr ' ' '-')

    local all_on=1 sel_count=0
    for ((i = 1; i < count; i++)); do
      [[ "${selected[$i]}" -eq 1 ]] && sel_count=$((sel_count + 1)) || true
      [[ "${selected[$i]}" -eq 0 ]] && all_on=0 || true
    done

    # Keep cursor in viewport (scroll tracks offset within items 1..count-1)
    if [[ $cursor -gt 0 ]]; then
      if [[ $cursor -le $scroll ]]; then
        scroll=$((cursor - 1))
      elif [[ $cursor -gt $((scroll + visible)) ]]; then
        scroll=$((cursor - visible))
      fi
    fi

    printf '\033[H'

    # Banner (4 lines + 1 blank = 5)
    printf "${CYAN}%s\033[K\n" "    _     _    __ _ _"
    printf "${BLUE}%s\033[K\n" " __| |___| |_ / _(_) |___ ___"
    printf "${BLUE}%s\033[K\n" '/ _` / _ \  _|  _| | / -_|_-<'
    printf "${PURPLE}%s${NC}\033[K\n" '\__,_\___/\__|_| |_|_\___/__/'
    echo -e "\033[K"

    # Header (4 lines)
    echo -e "${BOLD} Package selection${NC}   ${DIM}${sel_count} / $((count - 1)) selected${NC}\033[K"
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
    local i_start=$((scroll + 1))
    local i_end=$((scroll + visible + 1))
    [[ $i_end -gt $count ]] && i_end=$count

    for ((i = i_start; i < i_end; i++)); do
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
    for ((j = i_end - i_start; j < visible; j++)); do echo -e "\033[K"; done

    # Footer (4 lines, last without \n to prevent terminal scroll)
    echo -e "\033[K"
    echo -e "${DIM}${sep}${NC}\033[K"
    echo -e "\033[K"

    local btn_install btn_cancel
    if [[ "$focus" == "install" ]]; then
      btn_install="${BOLD}${GREEN}> [ Apply ]${NC}"
      btn_cancel="${DIM}  [ Cancel ]${NC}"
    elif [[ "$focus" == "cancel" ]]; then
      btn_install="${DIM}  [ Apply ]${NC}"
      btn_cancel="${BOLD}${RED}> [ Cancel ]${NC}"
    else
      btn_install="${DIM}  [ Apply ]${NC}"
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
          IFS=';' read -r mb mcol mrow <<<"$mnums"
          if [[ "$mb" == '0' ]]; then
            local _install_all_row=9
            local _items_start=11
            local _items_end=$((10 + visible))
            local _buttons_row=$((10 + visible + 4))
            if [[ "$mrow" -eq "$_install_all_row" ]]; then
              focus="list"
              cursor=0
              local new_val=$((1 - all_on))
              for ((i = 1; i < count; i++)); do selected[$i]=$new_val; done
            elif [[ "$mrow" -ge "$_items_start" && "$mrow" -le "$_items_end" ]]; then
              local idx=$((scroll + mrow - _items_start + 1))
              if [[ $idx -ge 1 && $idx -lt $count ]]; then
                cursor=$idx
                focus="list"
                selected[$idx]=$((1 - selected[$idx]))
              fi
            elif [[ "$mrow" -eq "$_buttons_row" ]]; then
              if [[ "$mcol" -le 25 ]]; then
                break # click Install
              else
                clear
                exit 0 # click Cancel
              fi
            fi
          fi
        fi
      else
        case "$seq" in
        '[A')
          if [[ "$focus" == "list" ]]; then
            [[ $cursor -gt 0 ]] && cursor=$((cursor - 1)) || true
          else
            focus="list"
            cursor=$((count - 1))
          fi
          ;;
        '[B')
          if [[ "$focus" == "list" ]]; then
            if [[ $cursor -lt $((count - 1)) ]]; then
              cursor=$((cursor + 1))
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
        local new_val=$((1 - all_on))
        for ((i = 1; i < count; i++)); do selected[$i]=$new_val; done
      else
        selected[$cursor]=$((1 - selected[$cursor]))
      fi
    elif [[ "$key" == $'\t' ]]; then
      case "$focus" in
      list) focus="install" ;;
      install) focus="cancel" ;;
      cancel)
        focus="list"
        cursor=0
        scroll=0
        ;;
      esac
    elif [[ "$key" == 'a' && "$focus" == "list" ]]; then
      for ((i = 1; i < count; i++)); do selected[$i]=1; done
    elif [[ "$key" == 'n' && "$focus" == "list" ]]; then
      for ((i = 1; i < count; i++)); do selected[$i]=0; done
    elif [[ "$key" == 'k' && "$focus" == "list" ]]; then
      [[ $cursor -gt 0 ]] && cursor=$((cursor - 1)) || true
    elif [[ "$key" == 'j' && "$focus" == "list" ]]; then
      if [[ $cursor -lt $((count - 1)) ]]; then
        cursor=$((cursor + 1))
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
  UNINSTALL_PKGS=()
  for ((i = 1; i < count; i++)); do
    if [[ "${selected[$i]}" -eq 1 ]]; then
      SELECTED_PKGS+=("${names[$i]}")
    elif [[ "${installed[$i]:-0}" -eq 1 ]]; then
      UNINSTALL_PKGS+=("${names[$i]}")
    fi
  done
}

# ---------------------------------------------------------------------------
# OS Detection
# ---------------------------------------------------------------------------

detect_os() {
  case "$(uname -s)" in
  Darwin) echo "macos" ;;
  Linux) echo "linux" ;;
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

  local formulae=(git neovim tmux curl stow fish starship eza bat fzf lazygit lazydocker gh go mongosh tree-sitter rustup posting zoxide direnv biome)
  for pkg in "${formulae[@]}"; do brew_install "$pkg"; done

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
  brew_install "ollama"

  # cmake — build dependency for some cargo packages
  if should_install "minesweep" || should_install "rebels" || should_install "cfspeedtest" || should_install "eilmeldung"; then
    if ! brew list --formula cmake &>/dev/null 2>&1; then
      log_info "Installing cmake (build dependency)..."
      brew install --quiet cmake
      log_ok "cmake"
    fi
  fi

  for pkg in minesweep rebels cfspeedtest eilmeldung; do cargo_install "$pkg"; done

  # pipx — dependency for spotui and posting
  if should_install "spotui" || should_install "posting"; then
    if ! brew list --formula pipx &>/dev/null 2>&1; then
      log_info "Installing pipx (dependency)..."
      brew install --quiet pipx
      log_ok "pipx"
    fi
  fi

  pipx_install "spotui"

  for cask in font-hack-nerd-font taproom; do brew_cask_install "$cask"; done

  log_step "Uninstalling deselected packages (macOS)"
  for pkg in git neovim tmux curl stow fish starship eza bat fzf lazygit lazydocker gh go mongosh tree-sitter rustup posting zoxide direnv biome; do
    brew_uninstall "$pkg"
  done
  for cask in font-hack-nerd-font taproom; do brew_cask_uninstall "$cask"; done
  for pkg in opencode ollama; do brew_uninstall "$pkg"; done
  for pkg in minesweep rebels cfspeedtest eilmeldung; do cargo_uninstall "$pkg"; done
  pipx_uninstall "spotui"   # posting is a brew formula on macOS, not pipx

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
      sudo rm -rf "$NVIM_DIR"
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
      lg_version=$(github_latest_version "jesseduffield/lazygit")
      curl -sLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${lg_version}/lazygit_${lg_version}_Linux_x86_64.tar.gz"
      local lg_tmp
      lg_tmp=$(mktemp -d)
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
      ld_version=$(github_latest_version "jesseduffield/lazydocker")
      curl -sLo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/download/v${ld_version}/lazydocker_${ld_version}_Linux_x86_64.tar.gz"
      local ld_tmp
      ld_tmp=$(mktemp -d)
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
      wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc |
        sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
      echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" |
        sudo tee /etc/apt/sources.list.d/gierens.list
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
    local font_dir="$FONTS_DIR"
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
      ms_version=$(github_latest_version "mongodb-js/mongosh")
      curl -sLo mongosh.tgz "https://github.com/mongodb-js/mongosh/releases/download/v${ms_version}/mongosh-${ms_version}-linux-x64.tgz"
      tar xf mongosh.tgz
      sudo install "mongosh-${ms_version}-linux-x64/bin/mongosh" -D -t /usr/local/bin/
      rm -rf "mongosh-${ms_version}-linux-x64" mongosh.tgz
      log_ok "mongosh"
    fi
  fi

  # cmake — build dependency for some cargo packages
  if should_install "minesweep" || should_install "rebels" || should_install "cfspeedtest" || should_install "eilmeldung"; then
    if ! dpkg -s cmake &>/dev/null 2>&1; then
      log_info "Installing cmake (build dependency)..."
      sudo apt-get install -y --no-install-recommends cmake
      log_ok "cmake"
    fi
  fi

  for pkg in tree-sitter minesweep rebels cfspeedtest eilmeldung; do cargo_install "$pkg"; done

  # pipx — dependency for spotui and posting
  if should_install "spotui" || should_install "posting"; then
    if ! dpkg -s pipx &>/dev/null 2>&1; then
      log_info "Installing pipx (dependency)..."
      sudo apt-get install -y --no-install-recommends pipx
      log_ok "pipx"
    fi
  fi

  for pkg in spotui posting; do pipx_install "$pkg"; done

  # biome — fast formatter and linter for web projects
  if should_install "biome"; then
    if command -v biome &>/dev/null; then
      log_ok "biome already installed"
    else
      log_info "Installing biome..."
      local biome_version
      biome_version=$(github_latest_version "biomejs/biome" "cli/v")
      curl -sLo /tmp/biome "https://github.com/biomejs/biome/releases/download/cli/v${biome_version}/biome-linux-x64"
      sudo install /tmp/biome -D -t /usr/local/bin/
      rm /tmp/biome
      log_ok "biome"
    fi
  fi

  log_step "Uninstalling deselected packages (Linux)"

  local apt_to_remove=(git tmux curl stow fish bat fzf gh zoxide direnv)
  for pkg in "${apt_to_remove[@]}"; do
    should_uninstall "$pkg" || continue
    if dpkg -s "$pkg" &>/dev/null 2>&1; then
      log_info "Removing $pkg via apt..."
      sudo apt-get remove -y "$pkg" && log_ok "$pkg removed" || log_warn "$pkg — apt remove failed"
    fi
  done

  if should_uninstall "go"; then
    if [[ -d /usr/local/go ]]; then
      log_info "Removing go..."
      sudo rm -rf /usr/local/go && log_ok "go removed" || log_warn "go — removal failed"
    fi
  fi

  if should_uninstall "neovim"; then
    if [[ -d "$NVIM_DIR" ]]; then
      log_info "Removing neovim..."
      sudo rm -rf "$NVIM_DIR" && log_ok "neovim removed" || log_warn "neovim — removal failed"
    fi
  fi

  if should_uninstall "lazygit"; then
    if command -v lazygit &>/dev/null; then
      log_info "Removing lazygit..."
      sudo rm -f /usr/local/bin/lazygit && log_ok "lazygit removed" || log_warn "lazygit — removal failed"
    fi
  fi

  if should_uninstall "lazydocker"; then
    if command -v lazydocker &>/dev/null; then
      log_info "Removing lazydocker..."
      sudo rm -f /usr/local/bin/lazydocker && log_ok "lazydocker removed" || log_warn "lazydocker — removal failed"
    fi
  fi

  if should_uninstall "mongosh"; then
    if command -v mongosh &>/dev/null; then
      log_info "Removing mongosh..."
      sudo rm -f /usr/local/bin/mongosh && log_ok "mongosh removed" || log_warn "mongosh — removal failed"
    fi
  fi

  if should_uninstall "starship"; then
    if command -v starship &>/dev/null; then
      log_info "Removing starship..."
      sudo rm -f /usr/local/bin/starship && log_ok "starship removed" || log_warn "starship — removal failed"
    fi
  fi

  if should_uninstall "biome"; then
    if command -v biome &>/dev/null; then
      log_info "Removing biome..."
      sudo rm -f /usr/local/bin/biome && log_ok "biome removed" || log_warn "biome — removal failed"
    fi
  fi

  if should_uninstall "rustup"; then
    if command -v rustup &>/dev/null; then
      log_info "Uninstalling Rust toolchain..."
      rustup self uninstall -y && log_ok "rust removed" || log_warn "rust — uninstall failed"
    fi
  fi

  for pkg in minesweep rebels cfspeedtest eilmeldung tree-sitter; do cargo_uninstall "$pkg"; done
  for pkg in spotui posting; do pipx_uninstall "$pkg"; done

  if should_uninstall "font-hack-nerd-font"; then
    local font_dir="$FONTS_DIR"
    if find "$font_dir" -name "Hack*.ttf" 2>/dev/null | grep -q .; then
      log_info "Removing Hack Nerd Font..."
      find "$font_dir" -name "Hack*.ttf" -delete && fc-cache -f "$font_dir" && log_ok "font-hack-nerd-font removed" || log_warn "font-hack-nerd-font — removal failed"
    fi
  fi

  log_info "Setting fish paths for Linux..."
  fish -c "fish_add_path /usr/local/bin /usr/local/go/bin $HOME/.local/bin ${NVIM_DIR}/bin $HOME/.cargo/bin"
  log_ok "fish paths set"
}

# ---------------------------------------------------------------------------
# Stow
# ---------------------------------------------------------------------------

unstow_dotfiles() {
  should_uninstall "stow-dotfiles" || return 0
  log_step "Removing stow symlinks (deselected)"
  local os="$1"
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ "$line" =~ ^#.*$ || -z "${line// /}" ]] && continue
    local name target_os
    read -r name target_os <<<"$line"
    [[ "$target_os" != "both" && "$target_os" != "$os" ]] && continue
    stow --dir="$DOTFILES_DIR" --target="$HOME" --delete "$name" 2>&1 \
      && log_ok "$name unstowed" \
      || log_warn "$name — stow delete failed"
  done <"$DOTFILES_DIR/packages.config"
}

stow_all() {
  should_install "stow-dotfiles" || return 0

  log_step "Stowing packages"

  local os="$1"

  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ "$line" =~ ^#.*$ || -z "${line// /}" ]] && continue

    local name target_os
    read -r name target_os <<<"$line"

    if [[ "$target_os" != "both" && "$target_os" != "$os" ]]; then
      log_info "skipping $name (${target_os}-only)"
      continue
    fi

    if stow --dir="$DOTFILES_DIR" --target="$HOME" --restow "$name" 2>&1; then
      log_ok "$name"
    else
      log_warn "$name — stow failed, check for conflicts"
    fi
  done <"$DOTFILES_DIR/packages.config"
}

# ---------------------------------------------------------------------------
# Post-install
# ---------------------------------------------------------------------------

post_install() {
  log_step "Post-install"

  # SDKMAN
  if should_install "sdkman"; then
    if [[ -d "$SDKMAN_DIR" ]]; then
      log_ok "sdkman already installed"
    else
      log_info "Installing SDKMAN..."
      curl -s "https://get.sdkman.io" | bash
      log_ok "sdkman"
    fi
  elif should_uninstall "sdkman"; then
    if [[ -d "$SDKMAN_DIR" ]]; then
      log_info "Removing SDKMAN..."
      rm -rf "$SDKMAN_DIR" && log_ok "sdkman removed" || log_warn "sdkman — removal failed"
    fi
  fi

  # TPM
  if should_install "tpm"; then
    if [[ ! -d "$TPM_DIR" ]]; then
      log_info "Installing TPM (Tmux Plugin Manager)..."
      git clone --quiet https://github.com/tmux-plugins/tpm "$TPM_DIR"
      log_ok "TPM installed — press Prefix+I inside tmux to load plugins"
    else
      log_ok "tpm already installed"
    fi
  elif should_uninstall "tpm"; then
    if [[ -d "$TPM_DIR" ]]; then
      log_info "Removing TPM..."
      rm -rf "$TPM_DIR" && log_ok "tpm removed" || log_warn "tpm — removal failed"
    fi
  fi

  # oh-my-fish — Fish shell framework
  if should_install "omf"; then
    if [[ -d "$OMF_DIR" ]]; then
      log_ok "oh-my-fish already installed"
    else
      log_info "Installing oh-my-fish..."
      curl -sL https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
      log_ok "oh-my-fish"
    fi
  elif should_uninstall "omf"; then
    if [[ -d "$OMF_DIR" ]]; then
      log_info "Removing oh-my-fish..."
      rm -rf "$OMF_DIR" && log_ok "omf removed" || log_warn "omf — removal failed"
    fi
  fi

  # Fisher — Fish plugin manager
  if fish -c "type -q fisher" 2>/dev/null; then
    log_ok "fisher already installed"
  else
    log_info "Installing Fisher..."
    fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
    log_ok "fisher"
  fi

  # Fisher plugins
  if fish -c "fisher list | grep -q pnpm-shell-completion" 2>/dev/null; then
    log_ok "pnpm-shell-completion already installed"
  else
    log_info "Installing pnpm-shell-completion..."
    fish -c "fisher install g-plane/pnpm-shell-completion"
    log_ok "pnpm-shell-completion"
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
  elif should_uninstall "copilot"; then
    if gh extension list 2>/dev/null | grep -q "gh-copilot"; then
      log_info "Removing gh copilot extension..."
      gh extension remove github/gh-copilot && log_ok "gh copilot removed" || log_warn "gh copilot — removal failed"
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
  unstow_dotfiles "$os"
  post_install

  cat <<'EOF'

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
