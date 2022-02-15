#!/bin/sh

if [[ -f $HOME/.wallpaper_fill ]]; then
  feh --bg-fill $HOME/.wallpaper_fill
elif [[ -f $HOME/.wallpaper_scale ]]; then
  feh --bg-scale $HOME/.wallpaper_scale
fi

python $HOME/.dwm/dwm-status-refresh.py loop &

# Wait
{
  sleep 3
  picom --experimental-backends -b &
  emacs --daemon --with-x-toolkit=lucid &
  pulseaudio --start &
  nm-applet &
  fcitx5 -d &
  # pcmanfm -d &
  dunst -d &

  if [[ -f "/usr/lib/kdeconnectd" ]]; then
    /usr/lib/kdeconnectd &
    kdeconnect-indicator &
  fi

  type dida >/dev/null 2>&1 && dida &
  type optimus-manager-qt >/dev/null 2>&1 && optimus-manager-qt &
  type v2ray >/dev/null 2>&1 && v2ray -c $HOME/.v2ray.json &
}&
