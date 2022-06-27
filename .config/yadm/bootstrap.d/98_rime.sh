#!/bin/bash

PATH_DOWNLOAD="$HOME/.local/share/fcitx5"
URL_DOWNLOAD="http://ys-f.ysepan.com/116124349/318792795/TLsJx8l571H8N4GJ4PH26b/%E5%B0%8F%E9%B9%A4%E9%9F%B3%E5%BD%A2%E2%80%9C%E9%BC%A0%E9%A1%BB%E7%AE%A1%E2%80%9Dfor%20macOS.zip"

PATH_COMPRESS="$PATH_DOWNLOAD/flypy.zip"
if [[ ! -f "$PATH_COMPRESS" ]]; then
	wget "$URL_DOWNLOAD" -O "$PATH_COMPRESS"
fi

7z t "$PATH_COMPRESS" >/dev/null
PATH_RIME="$PATH_DOWNLOAD/rime"

mkdir -p "$PATH_RIME/build"

PATH_STAGE=$(pwd)

mkdir -p "$PATH_DOWNLOAD/flypy"
cd "$PATH_DOWNLOAD/flypy"
yes | 7z e $PATH_COMPRESS  > /dev/null


for entry in $(find "$PATH_DOWNLOAD/flypy/" -name "*.bin" -type f) ;
do
  if [[ -f "$entry" ]]; then
    ln -sf "$entry" "$PATH_RIME/build/"
  fi
done


ln -sf "$PATH_DOWNLOAD/flypy/flypy.schema.yaml" "$PATH_RIME/"


cd "$PATH_STAGE"
