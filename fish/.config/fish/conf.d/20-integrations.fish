# Cache eval-based init scripts to avoid spawning processes on every shell start.
# Regenerates automatically when the binary is updated.
function _cached_source
    set -l cmd $argv[1]
    set -l args $argv[2..]
    set -l cache_dir $HOME/.cache/fish
    set -l cache_file $cache_dir/(basename $cmd).fish
    set -l bin_path (command -v $cmd 2>/dev/null)

    if not test -f $cache_file; or test -n "$bin_path" -a "$bin_path" -nt "$cache_file"
        mkdir -p $cache_dir
        command $cmd $args >$cache_file 2>/dev/null
    end
    source $cache_file
end

# Starship prompt
if command -q starship
    _cached_source starship init fish
end

# Zoxide (aliased to cd)
if command -q zoxide
    _cached_source zoxide init --cmd cd fish
end

# Fzf
if command -q fzf
    _cached_source fzf --fish
end

# Navi cheatsheets
if command -q navi
    _cached_source navi widget fish
end

# Colored man pages via bat
if command -q bat
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p --color always'"
    set -gx MANROFFOPT -c
else if command -q batcat
    set -gx MANPAGER "sh -c 'col -bx | batcat -l man -p --color always'"
    set -gx MANROFFOPT -c
end

# Bun completions
if test -s "$HOME/.bun/_bun"
    source "$HOME/.bun/_bun"
end

# uv — lazy-load completions on first use
if command -q uv; and not functions -q __uv_original
    function uv --wraps uv
        functions -e uv
        uv generate-shell-completion fish | source
        command uv $argv
    end
end

# Docker completions — generate once
if command -q docker
    set -l _docker_comp $HOME/.config/fish/completions/docker.fish
    if not test -f $_docker_comp
        mkdir -p (dirname $_docker_comp)
        docker completion fish >$_docker_comp
    end
end

# AWS completions
if command -q aws_completer
    complete -c aws -f -a '(begin; set -lx COMP_SHELL fish; set -lx COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
end

# Print resolved path on zoxide fuzzy jumps
if command -q zoxide
    functions -q __zoxide_z; and functions -c __zoxide_z __zoxide_z_original

    function __zoxide_z --wraps __zoxide_z_original
        set -l prev_pwd $PWD
        __zoxide_z_original $argv
        # Print path when it changed via fuzzy query (not plain cd)
        if test "$PWD" != "$prev_pwd"; and test (count $argv) -gt 1
            echo "󱞩 "(string replace "$HOME" "~" $PWD)
        end
    end
end
