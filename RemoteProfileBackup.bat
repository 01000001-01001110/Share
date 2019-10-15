@ECHO OFF

:: Change current directory to script location - useful for including .ps1 files
cd %~dp0

:: End batch - go to end of file
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "& '%~dpn0.ps1'"
PAUSE