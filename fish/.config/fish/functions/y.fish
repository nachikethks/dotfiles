function y --description 'Yazi file manager with cwd sync'
    set -l tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"
    set -l cwd (cat $tmp 2>/dev/null)
    if test -n "$cwd"; and test "$cwd" != "$PWD"; and test -d "$cwd"
        cd "$cwd"
    end
    rm -f "$tmp"
end
