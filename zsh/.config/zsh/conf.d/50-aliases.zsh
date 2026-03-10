
if (( $+commands[eza] )); then
    alias l='eza --icons --group-directories-first'
    alias ls='eza --icons --group-directories-first'
    alias la='eza --icons --all --group-directories-first'
    alias ll='eza --icons --long --header --group-directories-first'
    alias lla='eza --icons --long --header --all --group-directories-first'
    alias ltr='eza --icons --long --header --sort=modified --group-directories-first'
    alias ltrh='ltr'
    alias ltra='eza --icons --long --header --sort=modified --all --group-directories-first'
    alias ltrha='ltra'
    alias lsd='eza --icons --long --header --only-dirs'
    alias lsf='eza --icons --long --header --only-files'
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

alias -g -- --help='--help 2>&1 | cat --language=help --style=plain --color always'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
(( $+commands[git] )) && alias gs='git status'
(( $+commands[git] )) && alias gap='git add -p'
(( $+commands[git] )) && alias gc='git commit'
(( $+commands[git] )) && alias gca='git commit --amend'
(( $+commands[csvlens] )) && alias csvlens='csvlens --color-columns'

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

# SSH port forwarding utilities
# fip — forward input ports: ssh -f (background) -N (no commands) -L (local forward)
fip() {
    (( $# < 2 )) && echo "Usage: fip <host> <port1> [port2] ..." && return 1
    local host="$1"
    shift
    for port in "$@"; do
        ssh -f -N -L "$port:localhost:$port" "$host" && echo "Forwarding localhost:$port -> $host:$port"
    done
}

# dip — delete/disconnect input ports: kill the ssh processes doing the forwarding
dip() {
    (( $# == 0 )) && echo "Usage: dip <port1> [port2] ..." && return 1
    for port in "$@"; do
        pkill -f "ssh.*-L $port:localhost:$port" && echo "Stopped forwarding port $port" || echo "No forwarding on port $port"
    done
}

# lip — list input ports: show active ssh port forwards
lip() {
    pgrep -af "ssh.*-L [0-9]+:localhost:[0-9]+" || echo "No active forwards"
}

# yazi — file manager that can change shell's working directory on exit
y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    command yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}
