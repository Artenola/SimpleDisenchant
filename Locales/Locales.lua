-- SimpleDisenchant Localization System
local addonName, addon = ...

-- Create locale table
addon.L = {}
local L = addon.L

-- Default locale (English US)
L["enUS"] = {
    TITLE = "Simple Disenchant",
    DISENCHANT = "Disenchant",
    DISENCHANT_SPELL = "Disenchant",
    NO_ITEM = "No item",
    ITEMS_COUNT = "%d item(s) to disenchant",
    QUALITY_GREEN = "Green",
    QUALITY_BLUE = "Blue",
    QUALITY_PURPLE = "Purple",
    LOADED_MSG = "/sde to open",
    DRAG_TO_ACTIONBAR = "Drag to action bar",
    BLACKLIST_ADDED = "%s added to blacklist",
    BLACKLIST_REMOVED = "%s removed from blacklist",
    BLACKLIST_CLEARED = "Blacklist cleared",
    BLACKLIST_HINT = "Right-click to blacklist",
    BLACKLIST_TITLE = "Blacklist",
    BLACKLIST_CLEAR_BTN = "Clear All",
    BLACKLIST_REMOVE_HINT = "Right-click to remove",
    BLACKLIST_COUNT = "%d item(s) blacklisted",
    BLACKLIST_EMPTY = "Blacklist is empty",
    BLACKLIST_HELP = "Usage: /sde blacklist [clear]",
    BLACKLIST_OPEN_HINT = "Right-click for blacklist",
}

-- English GB uses same as US
L["enGB"] = L["enUS"]

-- Store player locale for later use
addon.playerLocale = GetLocale()

-- Set default currentLocale to English (will be updated in main file after all locales load)
addon.currentLocale = L["enUS"]
