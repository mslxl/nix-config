#!/usr/bin/env zsh

dunst &
nm-applet &


sleep 10
dwm-status "$HOME/.dwm/dwm-status.toml" &