@echo off
setlocal

:: Configuration - Modify this path if needed
set "WOW_ADDONS=D:\programs\World of Warcraft\_retail_\Interface\AddOns\SimpleDisenchant"

:: Source directory (where this script is located)
set "SOURCE=%~dp0"

:: Check if WoW AddOns folder exists
if not exist "%WOW_ADDONS%\..\" (
    echo ERROR: WoW AddOns folder not found: %WOW_ADDONS%
    echo Please edit this script and set the correct WOW_ADDONS path.
    pause
    exit /b 1
)

:: Create addon folder if it doesn't exist
if not exist "%WOW_ADDONS%" mkdir "%WOW_ADDONS%"

:: Copy addon files (excluding dev files)
echo Installing SimpleDisenchant to WoW...
echo From: %SOURCE%
echo To:   %WOW_ADDONS%
echo.

:: Copy main files
copy /Y "%SOURCE%SimpleDisenchant.toc" "%WOW_ADDONS%\" >nul
copy /Y "%SOURCE%SimpleDisenchant.lua" "%WOW_ADDONS%\" >nul

:: Copy media folder if exists
if exist "%SOURCE%media" (
    if not exist "%WOW_ADDONS%\media" mkdir "%WOW_ADDONS%\media"
    xcopy /Y /E "%SOURCE%media\*" "%WOW_ADDONS%\media\" >nul
)

echo Done! Addon installed successfully.
echo Reload your UI in-game with /reload
pause
