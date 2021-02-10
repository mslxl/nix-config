#!/usr/bin/env zsh


# EDITOR
# alias vim="nvim"

_start_emacs_daemon(){
    ret=$(ps x | awk '{print $5$6}' | grep "emacs--daemon")
    if (( $? != 0 )) {
           echo "Wait for emacs daemon start..."
           emacs --daemon
    }
    return 0
}
alias e="_start_emacs_daemon && emacsclient"
alias ew="_start_emacs_daemon && emacsclient -nc"
alias ee="emacs -nw"
alias eew="emacs"

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

# Thefuck
# eval $(thefuck --alias)
# alias fix="fuck"

# Taskwarrior

# alias ta="task add"
# alias tah="task add priority:H"
# alias tam="task add priority:M"
# alias tal="task add priority:L"
# alias t="task next"

# td() {
#   if (($# == 1)) {
#     task $1 done
#   } else {
#     echo "Arguments wrong."
#   }
# }

# tx() {
#   if (($# == 1)) {
#     task $1 delete
#   } else {
#     echo "Arguments wrong."
#   }
# }

# Tmux
alias t="tmux"
alias tls="tmux ls"
alias ta="tmux attach -t"
alias tn="tmux new -t"
alias tk="tmux kill-session -t"
alias ts="tmux switch -t"
alias trename="tmux rename-session -t"
