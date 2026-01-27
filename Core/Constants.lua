-- SimpleDisenchant Constants
local addonName, addon = ...

addon.Constants = {}
local C = addon.Constants

-- Spell IDs
C.DISENCHANT_SPELL_ID = 13262

-- Profession IDs
C.ENCHANTING_PROFESSION_ID = 333

-- Quality colors (RGB values)
C.QUALITY_COLORS = {
    [2] = {0.12, 1.00, 0.00},    -- Green (Uncommon)
    [3] = {0.00, 0.44, 0.87},    -- Blue (Rare)
    [4] = {0.64, 0.21, 0.93},    -- Purple (Epic)
}

-- Item class IDs that can be disenchanted
C.DISENCHANTABLE_CLASSES = {
    [2] = true,  -- Weapons
    [4] = true,  -- Armor
}

-- Minimum quality for disenchanting
C.MIN_DISENCHANT_QUALITY = 2  -- Green

-- Frame dimensions
C.FRAME_WIDTH = 320
C.FRAME_HEIGHT = 450

-- Item list row height
C.ITEM_ROW_HEIGHT = 38
