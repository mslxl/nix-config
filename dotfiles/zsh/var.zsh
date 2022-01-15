#!/bin/zsh

# Misc
hash emacs 2>/dev/null && {
    export EDITOR="emacs -nw"
}
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
hash yarn 2>/dev/null && {
    export PATH=$(yarn global bin):$PATH
}

# Android SDK
export ANDROID_SDK_ROOT=$HOME/Android/Sdk

# Hide GStreamer warnings
export OPENCV_LOG_LEVEL=ERROR

#secret[senstive data]{jA0EBwMCGXzylEtnQm7/0sCKAci7NxLQdY5La9oecQiCXoPyfL2GJxZI/p2L11/38HPYnfJOHMPjR9guehBG+8ZxOJunHfgNKHv23E7ghzAfI6uKVYTnW4k65FElg27yYOU1C3I3jgro29255GkDLGJz/r5m50OfpAdIPTj7jmzoO/bF1G3tDQ8w3pDYwm23wxkG97figsDXPFP2apYqcoXtoN/h3PLCxuk8iwkn7ORvJSgba4YjcmWPdDSIJG/nmylaju3mlxc3lJGC5quRsQ7uVK8k1R6eqWovXXKnZ34Pf36x39oxYtKbDLBsK+mQKkLjpkU1oKkwvHgHGzarLKPm3fqO1DAR+zivPIbtRs8d1lBs+ropytM7CeL3yAHvJXGEo2ETyZwASnknf5dpoMniIgWdBZmDQFK7fTe+m2BC1GRJGvmnVvI4zxsQdQGz3OQlO/hqU4JiDoOz}
