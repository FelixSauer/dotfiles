if status is-interactive
    # Commands to run in interactive sessions can go here
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
    eval (ssh-agent -c)
end

# Add key if not already added
ssh-add -l >/dev/null 2>&1; or ssh-add ~/.ssh/id_ed25519

# NVM für Fish
set -x NVM_DIR $HOME/.nvm


starship init fish | source
