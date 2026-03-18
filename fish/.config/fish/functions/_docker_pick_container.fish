function _docker_pick_container
    set -l query $argv[1]
    set -l names (docker ps --format '{{.Names}}')

    if test (count $names) -eq 0
        echo "No running containers found."
        return 1
    end

    if test -n "$query"
        # Exact match
        if contains -- $query $names
            echo $query
            return 0
        end

        # Partial match
        set -l matches
        for n in $names
            if string match -q "*$query*" $n
                set -a matches $n
            end
        end

        if test (count $matches) -eq 1
            echo $matches[1]
            return 0
        end

        if test (count $matches) -gt 1
            if command -q fzf
                set -l selected (printf '%s\n' $matches | fzf --prompt='container> ' --select-1 --exit-0)
                if test -n "$selected"
                    echo $selected
                    return 0
                end
                return 1
            end
            echo "Multiple containers match '$query': $matches"
            return 1
        end
    end

    if command -q fzf
        set -l selected (printf '%s\n' $names | fzf --prompt='container> ' --select-1 --exit-0)
        if test -n "$selected"
            echo $selected
            return 0
        end
        return 1
    end

    echo "No exact container match for '$query'. Install fzf or use an exact name."
    return 1
end
