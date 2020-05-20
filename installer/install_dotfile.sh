#!/usr/bin/env bash

echo "Clone..."
git clone https://github.com/mslxl/.dotfile.git ~/.dotfile
chmod a+x ~/.dotfile/dotdrop.sh
echo "Init..."
~/.dotfile/dotdrop.sh > /dev/null
echo "Install python package..."
pip3 install -r ~/.dotfile/dotdrop/requirements.txt --user

