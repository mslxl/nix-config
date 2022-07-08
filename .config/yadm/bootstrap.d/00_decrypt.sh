#!/bin/bash

hash yadm 2>/dev/null && {
  flag_file="~/.local/share/yadm_decrypted"
  if [[ ! -f "$flag_file" ]]; then
    echo "Run command 'yadm decrypt'? [yes/no]"
    read option
    if [[ "$option" == "yes " ]]; then
      yadm decrypt
      touch "$flag_file"
    fi
  fi 
}


