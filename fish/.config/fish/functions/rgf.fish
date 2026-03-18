function rgf --description 'Ripgrep + fzf + bat preview, open in nvim'
    if not command -q rg; or not command -q fzf; or not command -q nvim
        echo "rgf requires rg, fzf, and nvim"
        return 1
    end

    set -l bat_cmd
    if command -q batcat
        set bat_cmd batcat
    else if command -q bat
        set bat_cmd bat
    else
        echo "rgf requires bat or batcat"
        return 1
    end

    rg --color=always --line-number --no-heading --smart-case $argv | \
        fzf --ansi \
            --color "hl:-1:underline,hl+:-1:underline:reverse" \
            --delimiter : \
            --preview "$bat_cmd --color=always {1} --highlight-line {2}" \
            --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
            --bind 'enter:become(nvim {1} +{2})'
end
