# SimpleDisenchant - Install script for Windows (PowerShell)

# Configuration - Modify this path if needed
$WOW_ADDONS = "D:\programs\World of Warcraft\_retail_\Interface\AddOns\SimpleDisenchant"

# Source directory (where this script is located)
$SOURCE = $PSScriptRoot

# Check if WoW AddOns folder exists
$AddOnsParent = Split-Path $WOW_ADDONS -Parent
if (-not (Test-Path $AddOnsParent)) {
    Write-Host "ERROR: WoW AddOns folder not found: $AddOnsParent" -ForegroundColor Red
    Write-Host "Please edit this script and set the correct WOW_ADDONS path."
    exit 1
}

# Create addon folder if it doesn't exist
if (-not (Test-Path $WOW_ADDONS)) {
    New-Item -ItemType Directory -Path $WOW_ADDONS | Out-Null
}

Write-Host "Installing SimpleDisenchant to WoW..." -ForegroundColor Cyan
Write-Host "From: $SOURCE"
Write-Host "To:   $WOW_ADDONS"
Write-Host ""

# Copy main files
Copy-Item "$SOURCE\SimpleDisenchant.toc" -Destination $WOW_ADDONS -Force
Copy-Item "$SOURCE\SimpleDisenchant.lua" -Destination $WOW_ADDONS -Force

# Copy media folder if exists
if (Test-Path "$SOURCE\media") {
    if (-not (Test-Path "$WOW_ADDONS\media")) {
        New-Item -ItemType Directory -Path "$WOW_ADDONS\media" | Out-Null
    }
    Copy-Item "$SOURCE\media\*" -Destination "$WOW_ADDONS\media" -Recurse -Force
}

Write-Host "Done! Addon installed successfully." -ForegroundColor Green
Write-Host "Reload your UI in-game with /reload"
