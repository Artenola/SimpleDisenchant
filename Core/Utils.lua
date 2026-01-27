-- SimpleDisenchant Utilities
local addonName, addon = ...

addon.Utils = {}
local Utils = addon.Utils
local C = addon.Constants

-- Check if an item can be disenchanted
function Utils:CanDisenchant(itemLink)
    if not itemLink then return false end

    local _, _, quality = C_Item.GetItemInfo(itemLink)
    local _, _, _, _, _, classID = C_Item.GetItemInfoInstant(itemLink)

    -- Must be weapon or armor
    if not C.DISENCHANTABLE_CLASSES[classID] then
        return false
    end

    -- Must be green quality or higher
    if not quality or quality < C.MIN_DISENCHANT_QUALITY then
        return false
    end

    return true, quality
end

-- Get quality color
function Utils:GetQualityColor(quality)
    return C.QUALITY_COLORS[quality] or {1, 1, 1}
end

-- Print addon message
function Utils:Print(msg)
    print("|cffFFD700[SimpleDisenchant]|r " .. msg)
end

-- Check if in combat
function Utils:InCombat()
    return InCombatLockdown()
end
