#!/usr/bin/env zsh

function l(){
    echo Load pkg...
    echo ---
    cat ~/.zsh/pkg/$1.zsh | highlight --src-lang=zsh --out-format=xterm256
    echo ---
    source ~/.zsh/pkg/$1.zsh
    echo Fin
}

# EDITOR
alias vim="nvim"
alias vi="nvim"

alias e="emacsclient -a \"\" -c"
alias en="emacsclient -a \"\" -c -nw"
alias ec="emacs"
alias ecn="emacs -nw"
alias todo="emacs -nw ~/org/todo.org"

# Basic
alias ls="ls --color"
alias ll="ls -l"
alias la="ls -al"
alias rm="trash"
alias mkdir="mkdir -p"
alias grep="grep --color"
alias cp="cp -i"
alias df="df -h"
alias free="free -m"
alias more=less
alias ~="cd ~"
alias :q="exit"

# Misc Program
alias ra="ranger"
alias dotdrop="~/.dotfile/dotdrop.sh --cfg=~/.dotfile/config.yaml"
alias g="git"
alias docker="sudo docker"
alias pcs="proxychains"
alias qrsd="qrcp send"
alias qrrv="qrcp receive"

alias setpro="ALL_PROXY=socks5://127.0.0.1:1080 ; http_proxy=http://127.0.0.1:1081 ; https_proxy=http://127.0.0.1:1081"
alias unsetpro="unset ALL_PROXY http_proxy https_proxy"

# ps
alias ps.find="ps aux | grep -v 'grep' | grep"
alias ps.find.cmd="ps aux | grep -v 'grep' | awk '{print \$11\" \"\$12}' | grep"
alias ps.fzf="ps aux | fzf"
alias ps.fzf.cmd="ps.fzf | awk '{print \$11\" \"\$12}'"
alias ps.fzf.pid="ps.fzf | awk '{print \$2}'"
alias ps.fzf.kill="ps.fzf.pid | xargs kill"

# Tmux
alias t="tmux"
alias tls="tmux ls"
alias tatt="tmux attach -t"
alias tnew="tmux new -t"
