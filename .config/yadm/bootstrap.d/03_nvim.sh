#!/bin/bash

INSTALL_DIR="$HOME/.local/share/lunarvim"

if [[ ! -d "$INSTALL_DIR" ]]; then
  bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
fi
