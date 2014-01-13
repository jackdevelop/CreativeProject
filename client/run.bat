@echo off
SET SCRIPTS_DIR=%~dp0

START /B %SCRIPTS_DIR%\player\bin\win32\quick-x-player.exe -workdir %SCRIPTS_DIR%\src -file %SCRIPTS_DIR%\src\scripts\main.lua -size 960x640
