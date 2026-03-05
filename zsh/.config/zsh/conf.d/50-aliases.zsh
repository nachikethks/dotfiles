if (( $+commands[eza] )); then
    alias l='eza --icons'
    alias ls='eza --icons'
    alias la='eza --icons --all'
    alias ll='eza --icons --long --header'
    alias lla='eza --icons --long --header --all'
    alias ltr='eza --icons --long --header --sort=modified'
    alias ltrh='ltr'
    alias ltra='eza --icons --long --header --sort=modified --all'
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

if (( $+commands[rg] && $+commands[fzf] && ($+commands[bat] || $+commands[batcat]) && $+commands[nvim] )); then
    function rgf() {
        local bat_cmd
        (( $+commands[batcat] )) && bat_cmd=batcat || bat_cmd=bat
        rg --color=always --line-number --no-heading --smart-case "${*:-}" |
        fzf --ansi \
            --color "hl:-1:underline,hl+:-1:underline:reverse" \
            --delimiter : \
            --preview "$bat_cmd --color=always {1} --highlight-line {2}" \
            --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
            --bind 'enter:become(nvim {1} +{2})'
    }
fi
