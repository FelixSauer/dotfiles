# ============================================================
# Fish Config — Cross-platform (macOS & Linux)
# ============================================================

# --- System Detection ----------------------------------------
set -l OS (uname -s)
set -gx IS_MAC false
set -gx IS_LINUX false

switch $OS
    case Darwin
        set -gx IS_MAC true
    case Linux
        set -gx IS_LINUX true
end


# --- Homebrew (macOS only) -----------------------------------
if $IS_MAC && test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
end


# --- Tmux Auto-start -----------------------------------------
if status is-interactive && not set -q TMUX
    if tmux has-session 2>/dev/null
        exec tmux attach
    else
        exec tmux
    end
end


# --- General -------------------------------------------------
set fish_greeting

alias c    clear
alias l    'eza --long --header --all --color=auto'
alias ls   l
alias V    nvim
alias G    lazygit
alias q    exit
alias config 'cd ~/.config/'


# --- SSH Agent ----------------------------------------------
if not pgrep -u $USER ssh-agent > /dev/null
    eval (ssh-agent -s | sed 's/^/set -gx /' | sed 's/=/ /')
end

# Add key if not already added
ssh-add -l >/dev/null 2>&1
or ssh-add ~/.ssh/id_ed25519 2>/dev/null


# --- NVM ----------------------------------------------------
set -gx NVM_DIR $HOME/.nvm

if $IS_MAC
    # macOS: nvm via Homebrew or manual install
    set -l nvm_script /opt/homebrew/opt/nvm/nvm.sh
    if test -s $nvm_script
        bass source $nvm_script
    end
else if $IS_LINUX
    # Linux: nvm via fisher plugin or bass
    if test -s $NVM_DIR/nvm.sh
        bass source $NVM_DIR/nvm.sh
    end
end


# --- Paths (platform-specific) ------------------------------
if $IS_MAC
    fish_add_path /opt/homebrew/bin
    fish_add_path /opt/homebrew/sbin
else if $IS_LINUX
    fish_add_path /usr/local/bin
    fish_add_path $HOME/.local/bin
end


# --- Reload Config Function ---------------------------------
function reload_all_configs
    source ~/.config/fish/config.fish

    if set -q TMUX
        tmux source-file ~/.config/tmux/tmux.conf
        tmux display-message "Fish & Tmux configs reloaded!"
    else
        echo "Fish config reloaded!"
    end
end

if status is-interactive
    bind \e\cr reload_all_configs
end


# --- Prompt -------------------------------------------------
starship init fish | source