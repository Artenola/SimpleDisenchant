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
}

-- English GB uses same as US
L["enGB"] = L["enUS"]

-- Store player locale for later use
addon.playerLocale = GetLocale()

-- Set default currentLocale to English (will be updated in main file after all locales load)
addon.currentLocale = L["enUS"]
