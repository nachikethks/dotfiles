alias vim='nvim'
alias grep='grep --color=auto'
alias http='xh'
alias https='xhs'

if (( $+commands[batcat] )); then
    alias cat='batcat'
elif (( $+commands[bat] )); then
    alias cat='bat'
fi

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias gs='git status'

if (( $+commands[btop] )) && btop --help 2>&1 | grep -q 'utf-force'; then
    alias btop='btop --utf-force'
fi

alias openvpn_connect="sudo openvpn ~/Downloads/aihub-qa.ovpn"
alias claude-mem="$HOME/.bun/bin/bun \"$HOME/.claude/plugins/marketplaces/thedotmack/plugin/scripts/worker-service.cjs\""

function de() {
    docker exec -i -t $1 /bin/bash -c 'export TERM=xterm; /bin/bash'
}

rgf() {
    rg --color=always --line-number --no-heading --smart-case "${*:-}" |
    fzf --ansi \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become(nvim {1} +{2})'
}
