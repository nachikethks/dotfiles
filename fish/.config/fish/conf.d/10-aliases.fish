# eza
if command -q eza
    alias l 'eza --icons --group-directories-first'
    alias ls 'eza --icons --group-directories-first'
    alias la 'eza --icons --all --group-directories-first'
    alias ll 'eza --icons --long --header --group-directories-first'
    alias lla 'eza --icons --long --header --all --group-directories-first'
    alias ltr 'eza --icons --long --header --sort=modified --group-directories-first'
    alias ltrh ltr
    alias ltra 'eza --icons --long --header --sort=modified --all --group-directories-first'
    alias ltrha ltra
    alias lsd 'eza --icons --long --header --only-dirs'
    alias lsf 'eza --icons --long --header --only-files'
end

# Editor
if command -q nvim
    alias vim nvim
    alias vi nvim
    alias v nvim
end

# HTTP client
if command -q xh
    alias http xh
    alias https xhs
end

# Cat
if command -q batcat
    alias cat batcat
else if command -q bat
    alias cat bat
end

# Csvlens
if command -q csvlens
    alias csvlens 'csvlens --color-columns'
end

# Misc
alias claude-mem "$HOME/.bun/bin/bun \"$HOME/.claude/plugins/marketplaces/thedotmack/plugin/scripts/worker-service.cjs\""

# bat-extras
if command -q batman
    alias man batman
end
function help -d 'Run command --help through bat'
    $argv --help 2>&1 | command bat --language=help --style=plain --color=always
end

# Abbreviations — expand in-place so you see the full command before running
abbr -a gs 'git status'
abbr -a gap 'git add -p'
abbr -a gc 'git commit'
abbr -a gca 'git commit --amend'

# Directory navigation
abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a .... 'cd ../../..'
