# SimpleDisenchant - Install script for Windows (PowerShell)

$SOURCE = $PSScriptRoot
$CONFIG_FILE = "$SOURCE\install.config"
$CONFIG_EXAMPLE = "$SOURCE\install.config.example"

# Check if config exists, if not create from example
if (-not (Test-Path $CONFIG_FILE)) {
    if (Test-Path $CONFIG_EXAMPLE) {
        Copy-Item $CONFIG_EXAMPLE -Destination $CONFIG_FILE
        Write-Host "Created install.config from example. Please edit it with your WoW path." -ForegroundColor Yellow
        Write-Host "Then run this script again."
        exit 0
    } else {
        Write-Host "ERROR: install.config.example not found" -ForegroundColor Red
        exit 1
    }
}

# Parse config file
$config = @{}
Get-Content $CONFIG_FILE | ForEach-Object {
    if ($_ -match '^\s*([^#][^=]+)=(.*)$') {
        $config[$matches[1].Trim()] = $matches[2].Trim()
    }
}

$WOW_PATH = $config['WOW_PATH']
$WOW_VERSION = $config['WOW_VERSION']
$ADDON_NAME = $config['ADDON_NAME']

# Build destination path
$WOW_ADDONS = "$WOW_PATH\$WOW_VERSION\Interface\AddOns\$ADDON_NAME"

# Validate config
if (-not $WOW_PATH -or -not $WOW_VERSION -or -not $ADDON_NAME) {
    Write-Host "ERROR: Missing configuration in install.config" -ForegroundColor Red
    exit 1
}

# Check if WoW folder exists
if (-not (Test-Path "$WOW_PATH\$WOW_VERSION")) {
    Write-Host "ERROR: WoW folder not found: $WOW_PATH\$WOW_VERSION" -ForegroundColor Red
    Write-Host "Please edit install.config with the correct path."
    exit 1
}

# Create addon folder if it doesn't exist
if (-not (Test-Path $WOW_ADDONS)) {
    New-Item -ItemType Directory -Path $WOW_ADDONS | Out-Null
}

Write-Host "Installing $ADDON_NAME to WoW..." -ForegroundColor Cyan
Write-Host "From: $SOURCE"
Write-Host "To:   $WOW_ADDONS"
Write-Host ""

# Copy main files
Copy-Item "$SOURCE\$ADDON_NAME.toc" -Destination $WOW_ADDONS -Force
Copy-Item "$SOURCE\$ADDON_NAME.lua" -Destination $WOW_ADDONS -Force

# Copy media folder if exists
if (Test-Path "$SOURCE\media") {
    if (-not (Test-Path "$WOW_ADDONS\media")) {
        New-Item -ItemType Directory -Path "$WOW_ADDONS\media" | Out-Null
    }
    Copy-Item "$SOURCE\media\*" -Destination "$WOW_ADDONS\media" -Recurse -Force
}

Write-Host "Done! Addon installed successfully." -ForegroundColor Green
Write-Host "Reload your UI in-game with /reload"
