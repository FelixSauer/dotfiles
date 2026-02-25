if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Auto-start tmux
if status is-interactive
and not set -q TMUX
    # Attach to existing session or create new one
    if tmux has-session 2>/dev/null
        exec tmux attach
    else
        exec tmux
    end
end

#Setup
set fish_greeting

# General
alias c clear
alias l 'eza --long --header --all --color=auto'
alias ls l
alias V nvim
alias G lazygit
alias q exit
alias dev 'cd /Users/fesa/dev'
alias config 'cd ~/.config/'

# Start SSH agent if not running
if not pgrep -u $USER ssh-agent > /dev/null
    eval (ssh-agent -s | sed 's/^/set -gx /' | sed 's/=/ /')
end

# Add key if not already added
ssh-add -l >/dev/null 2>&1
or ssh-add ~/.ssh/id_ed25519 2>/dev/null

# NVM für Fish
set -x NVM_DIR $HOME/.nvm


# Function to reload all configs
function reload_all_configs
    # Reload fish config
    source ~/.config/fish/config.fish
    
    # Reload tmux config if in tmux
    if set -q TMUX
        tmux source-file ~/.config/tmux/tmux.conf
        tmux display-message "Fish & Tmux configs reloaded!"
    else
        echo "Fish config reloaded!"
    end
end

# Bind Ctrl+Alt+R to reload configs
if status is-interactive
    bind \e\cr reload_all_configs
end

starship init fish | source
