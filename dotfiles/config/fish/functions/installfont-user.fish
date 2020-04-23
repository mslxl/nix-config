#!/bin/fish

function installfont-user --wraps "cp -t $HOME/.local/share/fonts/"
    cp -v -t $HOME/.local/share/fonts/ $argv
    echo "Make font cache..."
    mkfontscale > /dev/null
    mkfontdir > /dev/null
    fc-cache -fv > /dev/null
    echo "Finish"
end
