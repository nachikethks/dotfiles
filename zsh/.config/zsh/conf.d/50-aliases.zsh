if (( $+commands[eza] )); then
    alias l='eza --icons'
    alias ls='eza --icons'
    alias la='eza --icons --all'
    alias ll='eza --icons --long --header --total-size'
    alias lla='eza --icons --long --header --all --total-size'
    alias ltr='eza --icons --long --header --reverse --sort=modified --total-size'
    alias ltrh='ltr'
    alias ltra='eza --icons --long --header --reverse --sort=modified --total-size --all'
    alias ltrha='ltra'
fi

if (( $+commands[nvim] )); then
  alias vim='nvim'
  alias vi='nvim'
  alias v='nvim'
fi

if (( $+commands[xh] )); then
    alias http='xh'
    alias https='xhs'
fi

if (( $+commands[batcat] )); then
    alias cat='batcat'
elif (( $+commands[bat] )); then
    alias cat='bat'
fi

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
(( $+commands[git] )) && alias gs='git status'

if (( $+commands[btop] )) && btop --help 2>&1 | grep -q 'utf-force'; then
    alias btop='btop --utf-force'
fi

alias openvpn_connect="sudo openvpn ~/Downloads/aihub-qa.ovpn"
alias claude-mem="$HOME/.bun/bin/bun \"$HOME/.claude/plugins/marketplaces/thedotmack/plugin/scripts/worker-service.cjs\""

if (( $+commands[docker] )); then
    function de() {
        docker exec -i -t $1 /bin/bash -c 'export TERM=xterm; /bin/bash'
    }
fi

if (( $+commands[rg] && $+commands[fzf] && $+commands[bat] && $+commands[nvim] )); then
    function rgf() {
        rg --color=always --line-number --no-heading --smart-case "${*:-}" |
        fzf --ansi \
            --color "hl:-1:underline,hl+:-1:underline:reverse" \
            --delimiter : \
            --preview 'bat --color=always {1} --highlight-line {2}' \
            --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
            --bind 'enter:become(nvim {1} +{2})'
    }
fi
