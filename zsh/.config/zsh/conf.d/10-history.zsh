HISTSIZE=50000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_reduce_blanks
setopt hist_verify
setopt inc_append_history

setopt auto_cd
setopt correct
setopt no_case_glob
setopt numeric_glob_sort
setopt complete_in_word
setopt always_to_end
setopt list_packed
setopt no_list_beep
setopt no_complete_aliases
