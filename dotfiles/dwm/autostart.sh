#!/bin/sh
picom -b &
feh --bg-fill $HOME/Pictures/87326553_p0.jpg &
$HOME/.dwm/dwm-status.sh &

# Wait
sleep 5
pulseaudio --start &
nm-applet &
fcitx5 -d
