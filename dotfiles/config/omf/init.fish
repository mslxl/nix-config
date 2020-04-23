#!/usr/bin/env fish


set -agx PATH "$HOME/.stack/programs/x86_64-linux/ghc-tinfo6-8.8.2/bin"
set -agx PATH "$HOME/bin"
set -g -x EDITOR (which nvim)
set -g -x BROWSER (which firefox)
set fish_greeting 'Fish shell with vi-mode v'$FISH_VERSION 

fish_vi_key_bindings
