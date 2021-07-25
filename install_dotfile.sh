#!/usr/bin/env bash

type git >/dev/null 2>&1 || { echo >&2 "I require git but it's not installed.  Aborting."; exit 1; }
type pip >/dev/null 2>&1 || { echo >&2 "I require python and python-pip but it's not installed.  Aborting."; exit 1; }

if [ ! -d "~/.dotfile" ]; then
	echo "Clone..."
	git clone https://github.com/mslxl/.dotfile.git ~/.dotfile
fi
chmod a+x ~/.dotfile/dotdrop.sh

echo "Init..."
~/.dotfile/dotdrop.sh > /dev/null

echo "Install python package..."
pip3 install -r ~/.dotfile/dotdrop/requirements.txt --user

