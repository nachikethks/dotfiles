# Vi mode
fish_vi_key_bindings

function fish_user_key_bindings
    fish_vi_key_bindings

    # Accept autosuggestion (full line)
    bind -M insert \cd forward-char
    # Accept autosuggestion word by word
    bind -M insert \cf forward-word

    # History search
    bind -M insert \cp history-search-backward
    bind -M insert \cn history-search-forward
    bind -M insert \ck history-search-backward
    bind -M insert \cj history-search-forward

    # Yank to system clipboard in vi mode
    bind -M visual y 'fish_clipboard_copy; commandline -f end-selection'
    bind -M normal yy fish_clipboard_copy

    # Re-apply autopair bindings after vi mode setup
    functions -q _autopair_fish_key_bindings && _autopair_fish_key_bindings
end
