#!/bin/zsh

# Misc
export EDITOR="emacsclient -a \"\" -c -nw"
export BROWSER="firefox"
export PATH=$HOME/.local/bin/:$PATH
export PATH=$HOME/bin:$PATH

# Flutter
export FLUTTER_STORAGE_BASE_URL="https://mirrors.tuna.tsinghua.edu.cn/flutter"
export PUB_HOSTED_URL="https://mirrors.tuna.tsinghua.edu.cn/dart-pub"

# Go
export GOPATH=~/.go
export GOPROXY=https://goproxy.cn

# Java (with arch-linux)
export JAVA_HOME=/usr/lib/jvm/default/

# Doom Emacs
export PATH=$HOME/.emacs.d/bin/:$PATH

# Ranger
export RANGER_LOAD_DEFAULT_RC=FALSE

# Nodejs
export PATH=$(yarn global bin):$PATH
