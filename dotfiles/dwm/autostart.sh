#!/bin/sh
xmodmap $HOME/.dwm/.xmodmap
feh --bg-fill $HOME/.wallpaper
picom -b &
$HOME/.dwm/dwm-status.sh &

# Wait
sleep 3
pulseaudio --start &
nm-applet &
fcitx5 -d &
pcmanfm -d &
