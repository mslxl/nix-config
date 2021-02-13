#!/usr/bin/env zsh


# EDITOR
alias vim="nvim"
alias vi="nvim"

alias e="emacsclient -a \"\" -c"
alias en="emacsclient -a \"\" -c -nw"
alias ec="emacs"
alias ecn="emacs -nw"
alias todo="emacs -nw ~/todo.org"

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

# Misc Program
alias ra="ranger"
alias dotdrop="~/.dotfile/dotdrop.sh --cfg=~/.dotfile/config.yaml"
alias g="git"
alias lg="lazygit"
alias pcs="proxychains"

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
alias ta="tmux attach -t"
alias tn="tmux new -t"
alias tk="tmux kill-session -t"
alias ts="tmux switch -t"
alias trename="tmux rename-session -t"
