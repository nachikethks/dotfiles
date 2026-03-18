function dl --description 'Docker logs for a running container'
    set -l container (_docker_pick_container $argv[1]); or return 1
    set -l lines (test -n "$argv[2]"; and echo $argv[2]; or echo 100)
    docker logs -f --tail=$lines $container
end
