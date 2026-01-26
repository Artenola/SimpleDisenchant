#!/bin/zsh
# SimpleDisenchant - Install script for macOS (zsh)

SOURCE="$(dirname "$0")"
CONFIG_FILE="$SOURCE/install.config"
CONFIG_EXAMPLE="$SOURCE/install.config.example"

# Check if config exists, if not create from example
if [[ ! -f "$CONFIG_FILE" ]]; then
    if [[ -f "$CONFIG_EXAMPLE" ]]; then
        cp "$CONFIG_EXAMPLE" "$CONFIG_FILE"
        echo "Created install.config from example. Please edit it with your WoW path."
        echo "Then run this script again."
        exit 0
    else
        echo "ERROR: install.config.example not found"
        exit 1
    fi
fi

# Parse config file
WOW_PATH=""
WOW_VERSION=""
ADDON_NAME=""

while IFS='=' read -r key value; do
    # Skip comments and empty lines
    [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | xargs)
    case "$key" in
        WOW_PATH) WOW_PATH="$value" ;;
        WOW_VERSION) WOW_VERSION="$value" ;;
        ADDON_NAME) ADDON_NAME="$value" ;;
    esac
done < "$CONFIG_FILE"

# Build destination path
WOW_ADDONS="$WOW_PATH/$WOW_VERSION/Interface/AddOns/$ADDON_NAME"

# Validate config
if [[ -z "$WOW_PATH" || -z "$WOW_VERSION" || -z "$ADDON_NAME" ]]; then
    echo "ERROR: Missing configuration in install.config"
    exit 1
fi

# Check if WoW folder exists
if [[ ! -d "$WOW_PATH/$WOW_VERSION" ]]; then
    echo "ERROR: WoW folder not found: $WOW_PATH/$WOW_VERSION"
    echo "Please edit install.config with the correct path."
    exit 1
fi

# Create addon folder if it doesn't exist
mkdir -p "$WOW_ADDONS"

echo "Installing $ADDON_NAME to WoW..."
echo "From: $SOURCE"
echo "To:   $WOW_ADDONS"
echo ""

# Copy main files
cp "$SOURCE/$ADDON_NAME.toc" "$WOW_ADDONS/"
cp "$SOURCE/$ADDON_NAME.lua" "$WOW_ADDONS/"

# Copy media folder if exists
if [[ -d "$SOURCE/media" ]]; then
    mkdir -p "$WOW_ADDONS/media"
    cp -R "$SOURCE/media/"* "$WOW_ADDONS/media/"
fi

echo "Done! Addon installed successfully."
echo "Reload your UI in-game with /reload"
