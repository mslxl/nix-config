@echo off


set h=0
set m=0
set s=0

:input
cls
echo Type the countdown of time which windowns will shutdown
set /p h=H(0):
set /p m=M(0):
set /p s=S(0):

set /a sec=%h% * 60 * 60 + %m% * 60 + %s%

choice /m "Make windowns shutdown after %h%:%m%:%s% (%sec%s late)?" 
if %errorlevel%==2 goto input
shutdown -a >nul
shutdown -s -t %sec% /f
echo.
pause
