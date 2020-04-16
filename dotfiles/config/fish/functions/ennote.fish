#!/usr/bin/env fish

function ennote
  if test (count $argv) -eq 0
    echo "help: ennote <NOTE_FILE_NAME>"
    return 1
  end

  set note $argv[1]

  set input (read)

  while test "$input" != ":q"

    set len (string length $input)
    if test $len -ne 0
      echo $input >> $note
      trans :zh $input
    end
    set input (read)

  end

end

