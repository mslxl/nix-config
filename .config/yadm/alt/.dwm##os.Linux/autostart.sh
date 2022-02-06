#!/bin/sh

# screen lock
# linux-enable-ir-emitter run &
xss-lock -n $HOME/.dwm/dwm-dim.sh -- $HOME/.dwm/dwm-lockscreen.sh -n &

if [[ -f $HOME/.wallpaper_fill ]]; then
	feh --bg-fill $HOME/.wallpaper_fill
elif [[ -f $HOME/.wallpaper_scale ]]; then
	feh --bg-scale $HOME/.wallpaper_scale
fi

# picom -b &
python $HOME/.dwm/dwm-status-refresh.py loop &

# Wait
{
	sleep 3
  picom --experimental-backends -b &
  emacs --daemon --with-x-toolkit=lucid &
	pulseaudio --start &
	nm-applet &
	tmux new -d -s v2ray 'v2ray -c ~/v2ray.json' &
	fcitx5 -d &
	# pcmanfm -d &
	dunst -d &
	/usr/lib/kdeconnectd &
	kdeconnect-indicator &
	optimus-manager-qt &
	bash -c "sleep 20; xmodmap $HOME/.dwm/.xmodmap" &
	v2ray -c $HOME/.v2ray.json &
}&

