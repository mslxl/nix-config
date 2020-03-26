#!/usr/bin/env bash

if [ -f "$HOME/.wallpaper.png" ]; then
  nitrogen --set-auto ~/.wallpaper.png
else
  echo "Could not find ~/.wallpaper.png , skipped."
fi
