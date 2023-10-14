#!/usr/bin/env bash

STORE="$(xdg-user-dir PICTURES)/Screenshot"
mkdir -p "$STORE"

FILE="$STORE/$(date +'shot_%s.png')"

REGION=$(slurp -b 1B1F28CC -c E06B74ff -s C778DD0D -w 2)
if [[ "$?" == "0" ]]; then
    grim -g "$REGION" - | tee "$FILE" | wl-copy
    notify-send -a Grim -t 2000 "Screen saved" "$FILE"
    feh "$FILE"
fi