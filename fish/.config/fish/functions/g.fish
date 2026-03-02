function g --description 'lazygit in git repos, hint outside'
    if git rev-parse --git-dir >/dev/null 2>&1
        lazygit $argv
    else
        echo "not a git repository"
    end
end
