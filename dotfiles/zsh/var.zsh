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

#secret[senstive data]{jA0EBwMCJAnRazPeJZr/0sCLAdd3cGjCeKeKCd0Q99iFfafVIKH/+EDHV+Q+Yuhv8R+556mk1kHhUlaU676e/+c2IW7YQSZy0mRA5MSqFyyF5MhUvL3VG8IOOotuTqS+80prABgHL0MWxCvdYTGQiE7z/Gzwwavvgeu6cAuKE3j5o7KzT36Kg7ggfh9nsYKMGbUGOQanJfNfHcucb/gTzjiFKeXcYMRBVAyw2WDEZrpd2pfZrd4OJKIqOFO0bAoDYuzzKjtrat+iSVWw7r8lpusp4+IaIlZgmHNocVzpSnQHbTcs7+gMwlIF83RnPJ8YWEYqorTR7ZJRJEfhbYD7JHkaOaVLRNeO9FQ/mqAM3twIFkcy0F+eS1aiABQcxbZBFWNnY1fWRd4vkYb8PS5BkdCZcxiOEJoK7n3sKwfsN9LQbpJnu9wf/dDV9AwyaKN5WrTi9K0klHExut2PrA==}
