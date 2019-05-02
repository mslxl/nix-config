@echo off

rem "纯属是放学懒得自己关电脑了"

set h=%time:~0,2%
set m=%time:~3,2%
set s=%time:~6,2%
set /a cur=%h%*60*60+%m%*60+%s%

if %h% geq 12 set /a aim=22*60*60
if %h% lss 12 set /a aim=12*60*60

set /a count=%aim%-%cur%

shutdown -a
shutdown -s -t %count% /f
