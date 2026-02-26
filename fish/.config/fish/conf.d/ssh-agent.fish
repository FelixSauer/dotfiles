if status is-interactive
    if not pgrep -u $USER ssh-agent > /dev/null
        eval (ssh-agent -s | sed 's/^/set -gx /' | sed 's/=/ /')
    end

    ssh-add -l >/dev/null 2>&1
    or ssh-add ~/.ssh/id_ed25519 2>/dev/null
end
