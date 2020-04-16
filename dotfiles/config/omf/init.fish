#!/usr/bin/env fish

alias vim="nvim"
alias mkdirs="mkdir -p"
alias untar.gz="tar -xzvf"
alias untar="tar -xvf"
alias ungz="gzip -d"
alias untar.bz2="tar -xjvf"

set -agx PATH "$HOME/.stack/programs/x86_64-linux/ghc-tinfo6-8.8.2/bin"
set -agx PATH "$HOME/bin"
set -gx EDITOR (which nvim)
set -gx BROWSER (which firefox)
set fish_greeting 'Fish shell with vi-mode v'$FISH_VERSION 

fish_vi_key_bindings
