#!/usr/bin/env zsh


# EDITOR
alias vim="nvim"
alias em="emacs"
alias e="emacsclient"
alias ec="emacs -nw"

# Basic
alias ls="ls --color"
alias ll="ls -l"
alias la="ls -al"
alias rm="trash"
alias mkdir="mkdir -p"
alias grep="grep --color"
alias ~="cd ~"

# Misc Program
alias ra="ranger"
alias dotdrop="~/.dotfile/dotdrop.sh --cfg=~/.dotfile/config.yaml"
alias grepps='ps -aux | grep -v "grep" | grep '

# Thefuck
eval $(thefuck --alias)
alias fix="fuck"

# Taskwarrior

alias ta="task add"
alias tah="task add priority:H"
alias tam="task add priority:M"
alias tal="task add priority:L"
alias t="task next"

td() {
  if (($# == 1)) {
    task $1 done
  } else {
    echo "Arguments wrong."
  }
}

tx() {
  if (($# == 1)) {
    task $1 delete
  } else {
    echo "Arguments wrong."
  }
}

