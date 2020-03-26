#!/usr/bin/env fish

alias vim="nvim"
set -x EDITOR (which nvim)
set -x BROWSER (which firefox)
set fish_greeting 'Fish shell v'$FISH_VERSION

neofetch
