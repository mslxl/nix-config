#!/bin/bash

hash code 2>/dev/null && {
  cat ~/.config/Code/User/vs_code_extensions_list.txt | xargs -n 1 code --install-extension
}
