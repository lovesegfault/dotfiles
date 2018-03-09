if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    exec startx > ~/.xorg.log 2>&1
fi
