#!/usr/bin/env bash

if [ -f "$HOME/.wallpaper.png" ]; then
  nitrogen --set-zoom-fill ~/.wallpaper.png
else
  echo "Could not find ~/.wallpaper.png , skipped."
fi
