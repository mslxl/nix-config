#!/usr/bin/env bash

if [ -f "$HOME/.wallpaper" ]; then
  # nitrogen --set-zoom-fill ~/.wallpaper
  feh --bg-fill ~/.wallpaper
else
  echo "Could not find ~/.wallpaper , skipped."
fi
