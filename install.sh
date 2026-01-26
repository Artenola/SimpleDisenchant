#!/bin/zsh
# SimpleDisenchant - Install script for macOS (zsh)

# Configuration - Modify this path if needed
WOW_ADDONS="/Applications/World of Warcraft/_retail_/Interface/AddOns/SimpleDisenchant"

# Source directory (where this script is located)
SOURCE="$(dirname "$0")"

# Check if WoW AddOns folder exists
if [[ ! -d "$(dirname "$WOW_ADDONS")" ]]; then
    echo "ERROR: WoW AddOns folder not found: $(dirname "$WOW_ADDONS")"
    echo "Please edit this script and set the correct WOW_ADDONS path."
    exit 1
fi

# Create addon folder if it doesn't exist
mkdir -p "$WOW_ADDONS"

echo "Installing SimpleDisenchant to WoW..."
echo "From: $SOURCE"
echo "To:   $WOW_ADDONS"
echo ""

# Copy main files
cp "$SOURCE/SimpleDisenchant.toc" "$WOW_ADDONS/"
cp "$SOURCE/SimpleDisenchant.lua" "$WOW_ADDONS/"

# Copy media folder if exists
if [[ -d "$SOURCE/media" ]]; then
    mkdir -p "$WOW_ADDONS/media"
    cp -R "$SOURCE/media/"* "$WOW_ADDONS/media/"
fi

echo "Done! Addon installed successfully."
echo "Reload your UI in-game with /reload"
