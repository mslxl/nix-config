#!/usr/bin/env fish

alias vim="nvim"

set -agx PATH "/home/mslxl/.stack/programs/x86_64-linux/ghc-tinfo6-8.8.2/bin"
set -gx EDITOR (which nvim)
set -gx BROWSER (which firefox)
set fish_greeting 'Fish shell v'$FISH_VERSION
