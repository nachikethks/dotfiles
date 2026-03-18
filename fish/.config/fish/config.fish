# Vi mode
fish_vi_key_bindings

function fish_user_key_bindings
    fish_vi_key_bindings

    # Fix backspace after returning from normal mode
    bind -M insert \x7f backward-delete-char
    bind -M insert \ch backward-delete-char

    # Accept autosuggestion (full line)
    bind -M insert \cd forward-char
    # Accept autosuggestion word by word
    bind -M insert \cf forward-word

    # History search
    bind -M insert \cp history-search-backward
    bind -M insert \cn history-search-forward
    bind -M insert \ck history-search-backward
    bind -M insert \cj history-search-forward
end
