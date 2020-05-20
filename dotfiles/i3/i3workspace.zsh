#!/usr/bin/env zsh

workspace_history="/tmp/workspace_history"
def_ws_name="123456789"

initHistoryFile() {
    for i ({1..$#def_ws_name}) {
            echo $def_ws_name[i] >> $workspace_history
        }
}

input() {
    if [[ ! -f $workspace_history ]] {
           initHistoryFile
       }

       ws=$(<$workspace_history | sort | uniq -c | sort -nr | awk '{print $2}' | sed '/^\s*$/d' | rofi -dmenu -p "$1" | sed '/^\s*$/d')
       echo $ws >> $workspace_history
       echo -n $ws
}

case $1 {
        (switch)
        i3 workspace $(input "Switch")
        ;;

        (move)
            i3 move container to workspace $(input "Move")
            ;;
        (ms)
            name=$(input "MS")
            i3 move container to workspace $name
            i3 workspace $name
            ;;

    }
