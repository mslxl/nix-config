#!/bin/sh
xmodmap $HOME/.dwm/.xmodmap

if [[ -f $HOME/.wallpaper_fill ]]; then
	feh --bg-fill $HOME/.wallpaper_fill
elif [[ -f $HOME/.wallpaper_scale ]]; then
	feh --bg-scale $HOME/.wallpaper_scale
fi

picom -b &
$HOME/.dwm/dwm-status.sh &

# Wait
{
	sleep 3
	pulseaudio --start &
	nm-applet &
	tmux new -d -s v2ray 'v2ray -c ~/v2ray.json' &
	fcitx5 -d &
	pcmanfm -d &
}&
