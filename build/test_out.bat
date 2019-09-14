@echo off
set "myHex=0A"
set /a decimal=0x%myHex%
set "decimal=%1"
cmd /c exit /b %decimal%
echo "%=ExitCodeAscii%"