set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx EDITOR nvim
set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml
set -gx PNPM_HOME $HOME/.local/share/pnpm
set -gx BUN_INSTALL $HOME/.bun
set -gx CONDA_CHANGEPS1 false
set -gx LESS '-R --wheel-lines=1'

fish_add_path /opt/nvim-linux-x86_64/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.fzf/bin
fish_add_path /usr/local/go/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $PNPM_HOME
fish_add_path $BUN_INSTALL/bin
