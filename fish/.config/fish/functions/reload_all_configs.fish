function reload_all_configs
    source ~/.config/fish/config.fish

    if set -q TMUX
        tmux source-file ~/.config/tmux/tmux.conf
        tmux display-message "Fish & Tmux configs reloaded!"
    else
        echo "Fish config reloaded!"
    end
end
