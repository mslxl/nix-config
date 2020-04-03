#!/usr/bin/env fish

set workspace_history "/tmp/workspace_history"

function isInList
  for val in $argv[2]
    if test "$argv[1]" = "$val"
      return 0
    end
  end
  return 1
end


function input
  #init history
  if test ! -f $workspace_history
    printf '%s\n' (string split "" "12345678") > $workspace_history
  end

  #read history
  set ws_history (string split '\n' (cat $workspace_history))
  
  #trim history
  set len (count $ws_history)
  for i in (seq $len)
    set ws_history[$i] (string trim $ws_history[$i])
  end

  #build items
  set -e items
  set items
  for i in $ws_history
    # not is empty and not is duplicated
    if test -n "$i" 
      isInList $i $items
      if test $status = 1
        set items $i $items
      end
    end
  end

  set name (printf '%s\n' $items | rofi -dmenu -p "$argv[1]")
  set name (string trim $name)

  #save history
  if test ! "$name" = ""
    isInList $name $ws_history
    if test $status = 1
      printf '%s\n' $name >> $workspace_history
    end
  end

  echo $name
end

switch "$argv[1]"
  case "switch"
    i3 workspace (input "Switch")
  case "move"
    i3 move container to workspace (input "Move container")
  case "ms" 
    set name (input "Move Focus")
    i3 move container to workspace $name
    i3 workspace $name
end
