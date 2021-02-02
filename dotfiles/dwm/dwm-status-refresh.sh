#!/bin/bash
print_volume() {
	volume="$(amixer get Master | tail -n1 | sed -r 's/.*\[(.*)%\].*/\1/')"
	if test "$volume" -gt 0
	then
		echo -e "墳 ${volume}%"
	else
		echo -e "ﱝ Mute"
	fi
}

print_mem(){
	memfree=$(($(grep -m1 'MemAvailable:' /proc/meminfo | awk '{print $2}') / 1024))
	echo -e " $memfree"
}



print_date(){
	date '+%a, %b %d - %H:%M'
}

xsetroot -name " $(print_mem)M $(print_volume) |  $(print_date) "

exit 0
