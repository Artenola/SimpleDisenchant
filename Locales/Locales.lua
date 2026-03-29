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
    COMBAT_WARNING = "Not available in combat",
    COMBAT_OVERLAY = "In combat...",

    -- Filter panel
    FILTER_BUTTON = "Filter",
    FILTER_RARITY = "Rarity",
    FILTER_ITEM_LEVEL = "Item Level",
    FILTER_VENDOR_PRICE = "Vendor Price",
    FILTER_MIN = "Min:",
    FILTER_MAX = "Max:",
    FILTER_RESET = "Reset",
    FILTER_ILVL_SHORT = "iLvl ",

    -- Filtered items frame
    FILTERED_TITLE = "Filtered Items",
    FILTERED_COUNT = "%d item(s) filtered",
    FILTERED_OVER_ILVL = "Item Level",
    FILTERED_OVER_GOLD = "Vendor Price",
    FILTERED_SELECT_HINT = "Click to disenchant anyway",
    FILTERED_TOOLTIP_HINT = "Items excluded by filters",

    -- Filter tooltips
    FILTER_RARITY_TOOLTIP = "Include or exclude items by rarity",
    FILTER_ILVL_TOOLTIP = "Set min/max item level. Leave empty for no limit.",
    FILTER_GOLD_TOOLTIP = "Set min/max vendor price in gold. Leave empty for no limit.",

    -- Binding type filter
    FILTER_BINDING_TYPE = "Binding Type",
    FILTER_BINDING_TYPE_TOOLTIP = "Include or exclude items by binding type",
    FILTER_BINDING_BOE = "Bind on Equip",
    FILTER_BINDING_BOP = "Bind on Pickup",

    -- Reset positions
    RESET_POSITIONS_MSG = "All window positions have been reset.",
    -- Equipment set filter
    FILTER_HIDE_EQUIPMENT_SET = "Hide Equipment Set items",
    FILTER_EQUIPMENT_SET_TOOLTIP = "Hide items that belong to an equipment set to prevent accidental disenchanting.",
    FILTERED_EQUIPMENT_SET = "Equipment Set",

    -- Minimap button
    MINIMAP_TOOLTIP_LEFT = "Left-click to toggle window",
    MINIMAP_TOOLTIP_RIGHT = "Right-click for blacklist",
    MINIMAP_TOOLTIP_DRAG = "Drag to move",
    MINIMAP_TOOLTIP_HIDE = "Shift-click to hide",
    MINIMAP_HIDDEN_MSG = "Minimap button hidden. Type /sde minimap to show it again.",
}

-- English GB uses same as US
L["enGB"] = L["enUS"]

-- Keybinding labels (WoW global strings for the Keybindings UI)
_G.BINDING_HEADER_SIMPLEDISENCHANT = "Simple Disenchant"
_G.BINDING_NAME_SDEBTN = "Disenchant next item"
_G.BINDING_NAME_SDETOGGLE = "Toggle window"
_G.BINDING_NAME_SDEBLACKLIST = "Toggle blacklist"
_G.BINDING_NAME_SDEALL = "Toggle all windows"

-- Store player locale for later use
addon.playerLocale = GetLocale()

-- Set default currentLocale to English (will be updated in main file after all locales load)
addon.currentLocale = L["enUS"]
