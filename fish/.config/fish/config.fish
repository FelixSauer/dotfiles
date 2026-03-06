# --- Homebrew ------------------------------------------------
if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
end



# --- General -------------------------------------------------
set fish_greeting

# TrueColor support for all platforms (WSL, Mac, Arch)
if test "$TERM" = "xterm-color"
    set -gx TERM xterm-256color
end

alias c    clear
alias l    'eza --long --header --all --color=auto'
alias ls   'eza --long --header --all --color=auto'
alias tree 'eza --tree --long --header --all --color=auto'
alias v    nvim
alias d    lazydocker
alias q    exit

# --- Dev Tools -----------------------------------------------
alias cat  'bat --paging=never'
alias post 'posting'

# --- Games ---------------------------------------------------
alias mines 'minesweep'
alias rit   'rebels'
alias tron  'ssh sshtron.zachlatta.com'

# --- Network -------------------------------------------------
alias speedtest 'cfspeedtest'

# --- Media / News --------------------------------------------
alias spot 'spotui'
alias news 'eilmeldung'

# --- TMux Shortcuts -----------------------------------------
alias tn 'env TMUX= tmux new-session'
alias ta 'tmux attach-session -t'
alias tls 'tmux list-sessions'

# --- Keybindings --------------------------------------------
if status is-interactive
    bind \e\cr reload_all_configs
    bind \ez 'zi\n'
end


# --- Prompt -------------------------------------------------
starship init fish | source

zoxide init fish | source

direnv hook fish | source

fzf --fish | source

# --- FZF Configuration ---------------------------------------
set -gx FZF_DEFAULT_OPTS "--preview 'bat --color=always --style=numbers --line-range=:500 {}' --bind 'enter:become(nvim {})'"

# opencode
fish_add_path /Users/Felix.Sauer/.opencode/bin

# cargo
fish_add_path /Users/Felix.Sauer/.cargo/bin
