bindkey -v
KEYTIMEOUT=1

# Fix backspace after returning from vicmd mode
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char

# bindkey '^E' edit-command-line

bindkey '^r' history-incremental-search-backward
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^k' history-search-backward
bindkey '^j' history-search-forward
bindkey '^I' complete-word

# Accept autosuggestion (full line)
bindkey '^d' forward-char
# Accept autosuggestion word by word
bindkey '^f' forward-word
