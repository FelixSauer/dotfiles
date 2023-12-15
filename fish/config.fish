if status is-interactive
    # Commands to run in interactive sessions can go here
end

#Setup
set fish_greeting

# General
alias ls 'l'
alias ll 'l'
alias l 'exa --long -a --header'
alias tree 'exa --tree --level=2'
alias vi 'nvim'
alias vim 'vi'
alias dev 'cd /Users/fesa/dev'

alias sfxone 'ssh sfxone@sfxone.ddns.net'

# Exxeta Agile Hub
alias agile 'cd /Library/Exxeta_Workspace/dev/agile-hub'

# MTP
alias mtp 'cd /Library/Exxeta_Workspace/dev/damilertruck'



#starship init fish | source


# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
