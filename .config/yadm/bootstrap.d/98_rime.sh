#!/bin/bash

RIME_CONFIG_DIR="$HOME/.config/yadm/alt/.local/share/fcitx5##os.Linux/rime"
XK_CONFIG_DIR="$RIME_CONFIG_DIR/xkinput"

echo "Rime config: $RIME_CONFIG_DIR"
echo "xkinput install: $XK_CONFIG_DIR"

if [[ ! -d "$XK_CONFIG_DIR" ]]; then
  git clone --depth 1 https://gitee.com/xkinput/Rime_JD.git "$XK_CONFIG_DIR" 
fi


# link basic config file
ln -sf "$XK_CONFIG_DIR/Tools/SystemTools/rime/Linux/xkjd6.schema.yaml" "$RIME_CONFIG_DIR/"
ln -sf "$XK_CONFIG_DIR/Tools/SystemTools/rime/Linux/xkjd6dz.schema.yaml" "$RIME_CONFIG_DIR/"
for entry in "$XK_CONFIG_DIR"/rime/xkjd6*
do
  if [[ -f "$entry" ]]; then
    ln -sf "$entry" "$RIME_CONFIG_DIR/"
  fi
done

# link lua
ln -sf "$XK_CONFIG_DIR/rime/rime.lua" "$RIME_CONFIG_DIR/lua/xkinput.lua"

for entry in "$XK_CONFIG_DIR"/rime/lua/*
do
  if [[ -f "$entry" ]]; then
    ln -sf "$entry" "$RIME_CONFIG_DIR/lua/"
  fi
done

# linke opencc

if [[ ! -d "$RIME_CONFIG_DIR/opencc/" ]]; then
  mkdir "$RIME_CONFIG_DIR/opencc/"
fi

for entry in "$XK_CONFIG_DIR"/rime/opencc/*
do
  if [[ -f "$entry" ]]; then
    ln -sf "$entry" "$RIME_CONFIG_DIR/opencc/"
  fi
done
