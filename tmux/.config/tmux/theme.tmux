#!/usr/bin/env bash
THEME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load colors
source "${THEME_DIR}/catppuccin-mocha.tmuxtheme"

# Status bar
tmux set-option -gq status on
tmux set-option -gq status-position bottom
tmux set-option -gq status-style "bg=${thm_bg}"
tmux set-option -gq status-justify left
tmux set-option -gq status-left-length 100
tmux set-option -gq status-right-length 100

# Left: session name
tmux set-option -gq status-left "#[fg=${thm_bg},bg=${thm_magenta},bold] #S #[fg=${thm_magenta},bg=${thm_bg},nobold]"

# Right: window + user
tmux set-option -gq status-right "#[fg=${thm_gray},bg=${thm_bg}]#[fg=${thm_fg},bg=${thm_gray}]  #W #[fg=${thm_blue},bg=${thm_gray}]#[fg=${thm_bg},bg=${thm_blue},bold]  #(whoami) "

# Inactive windows
tmux set-window-option -gq window-status-style "fg=${thm_black4},bg=${thm_bg}"
tmux set-window-option -gq window-status-format "#[fg=${thm_bg},bg=${thm_gray}] #I #[fg=${thm_fg},bg=${thm_bg}] #W "
tmux set-window-option -gq window-status-separator ""

# Active window
tmux set-window-option -gq window-status-current-format "#[fg=${thm_bg},bg=${thm_orange},bold] #I #[fg=${thm_fg},bg=${thm_gray}] #W "

# Panes
tmux set-option -gq pane-border-style "fg=${thm_gray}"
tmux set-option -gq pane-active-border-style "fg=${thm_blue}"

# Messages
tmux set-option -gq message-style "fg=${thm_cyan},bg=${thm_gray}"
tmux set-option -gq message-command-style "fg=${thm_cyan},bg=${thm_gray}"

# Clock & selection
tmux set-window-option -gq clock-mode-colour "${thm_blue}"
tmux set-window-option -gq mode-style "fg=${thm_bg},bg=${thm_magenta},bold"
