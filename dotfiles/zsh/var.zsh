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

