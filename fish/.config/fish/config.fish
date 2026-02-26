# --- Homebrew ------------------------------------------------
if test -x /opt/homebrew/bin/brew
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
alias tree 'eza --tree --long --header --all --color=auto'
alias v    nvim
alias g    lazygit
alias d    laszydocker
alias k    k9s
alias q    exit


# --- Keybindings --------------------------------------------
if status is-interactive
    bind \e\cr reload_all_configs
end


# --- Prompt -------------------------------------------------
starship init fish | source
