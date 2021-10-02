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

#secret[senstive data]{jA0EBwMCBIGgNc7MWtD/0sAQAXv0miE7vHOj8a+x6PjD2tkhqIUpdxP9p4nOUoEj1tK6G2nF5yFmgNDQEgynrxADNiEzgIyGLtV26fzeLOWQPGCgV89+dsqm6LiRiPdE81ALglJW4yLZxAsJuc5tuiQCGhjHKiVdyShVH3xhCyOL35MGTSaNu/851iHrCh65WLmBJ+63sAzbCp31zDggpw0IHkivoZmf7nvQZo0zGXF2pIZScdZLJkNTzVpTVDXVJNw8FF5eq8OJIrxWImkvxHogw23YGInl4tx7imstnieOLA==}
