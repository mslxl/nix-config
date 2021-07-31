#!/usr/bin/env python3

import os
import re
import sys
import time

from functools import reduce

SPLIT_CHAR = "|"
SPACE_CHAR = " "

def update():
    status = [ BatteryLine(),
               SPLIT_CHAR,
               VolumeLine(),
               MemLine(),
               SPLIT_CHAR,
               TimeLine()]
    os.system('xsetroot -name " ' + reduce(lambda acc, pre: acc + " " + pre , status) + ' "')
    print("Refreshed")

def TimeLine():
    return time.strftime("%a, %b %d - %H:%M", time.localtime())

def BatteryLine():
    battery = 0
    icons = ['', '', '', '', '', '', '', '', '', '', '']
    with open("/sys/class/power_supply/BAT0/capacity") as f:
        battery = int(f.read()[0:3])
    with open("/sys/class/power_supply/BAT0/status") as f:
        text = f.read()
        if text[0:8] == "Charging":
            return icons[10] + SPACE_CHAR + str(battery)
        elif text[0:4] == "Full":
            return icons[10] + SPACE_CHAR + "AC"
        elif text[0:7] == "Unknown":
            return "" + SPACE_CHAR + str(battery) 
        else:
            return icons[battery // 10 - 1] + SPACE_CHAR + str(battery)

def MemLine():
    memFree = 0
    icon=''
    with open("/proc/meminfo") as f:
        f.readline()
        memFree = int(f.readline()[9:-3].strip()) // 1024
    return icon + SPACE_CHAR + str(memFree) + "M"

def VolumeLine():
    icons=['墳', 'ﱝ']
    with os.popen("amixer get Master") as proc:
        text = proc.read()
        matched = re.search(r"\[(.*)%\].*\[(on|off)\]", text)
        if matched == None:
            return "Amixer Error"
        elif matched.group(2) == "on":
            return icons[0] + SPACE_CHAR + matched.group(1)
        else:
            return icons[1] + SPACE_CHAR + "Mute"




argv = sys.argv
if len(argv) > 1:
    if argv[1] == "loop":
        while True:
            update()
            time.sleep(30)

else:
    update()
