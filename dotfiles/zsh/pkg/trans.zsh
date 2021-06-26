#!/usr/bin/env zsh

alias te="trans :en"
alias tz="trans :zh"
alias t="trans"
alias aa="aspell -a -l en"
function a(){
    echo $* | aspell -a -l en
}
