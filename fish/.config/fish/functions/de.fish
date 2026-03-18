function de --description 'Docker exec into a running container'
    set -l container (_docker_pick_container $argv[1]); or return 1
    docker exec -it $container /bin/bash -lc 'export TERM=xterm; exec /bin/bash'
end
