#!/bin/bash
#
echo "Check ammonite depentences..."
hash amm 2>/dev/null || {
    echo "ammonite misssing. Installing..."
    hash pacman 2>/dev/null
    if [[ "$?" == "0" ]]; then
        sudo pacman -S ammonite
    else
        sudo sh -c '(echo "#!/usr/bin/env sh" && curl -L https://github.com/com-lihaoyi/Ammonite/releases/download/2.5.1/2.13-2.5.1) > /usr/local/bin/amm && chmod +x /usr/local/bin/amm'
    fi
}

echo "Execuate ammonite script..."
amm $HOME/.config/yadm/bootstrap.d/ammonite/init.sc
echo "Done"
