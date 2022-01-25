#!/bin/bash

if [[ -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]]; then
    echo "Nvim packer.nvim already exists, skipped"
else
    git clone --depth 1 https://github.com/wbthomason/packer.nvim $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim
fi
