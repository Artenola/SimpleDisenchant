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

-- Get current locale with fallback to enUS
local locale = GetLocale()
addon.currentLocale = L[locale] or L["enUS"]
