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

-- Format copper value as full price string with coin icons (gold + silver + copper)
function Utils:FormatGold(copper)
    if not copper or copper == 0 then
        return "0" .. CreateAtlasMarkup("coin-copper", 12, 12)
    end

    local gold = math.floor(copper / C.COPPER_PER_GOLD)
    local silver = math.floor((copper % C.COPPER_PER_GOLD) / C.COPPER_PER_SILVER)
    local cop = copper % C.COPPER_PER_SILVER

    local str = ""
    if gold > 0 then
        str = gold .. CreateAtlasMarkup("coin-gold", 12, 12)
    end
    if silver > 0 then
        if str ~= "" then str = str .. " " end
        str = str .. silver .. CreateAtlasMarkup("coin-silver", 12, 12)
    end
    if cop > 0 or str == "" then
        if str ~= "" then str = str .. " " end
        str = str .. cop .. CreateAtlasMarkup("coin-copper", 12, 12)
    end
    return str
end

-- Create aligned price columns (gold | silver | copper) on a list row button
function Utils:CreatePriceColumns(btn)
    btn.goldCol = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    btn.goldCol:SetJustifyH("RIGHT")
    btn.goldCol:SetTextColor(0.7, 0.7, 0.7)
    btn.goldCol:SetWidth(45)

    btn.silverCol = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    btn.silverCol:SetJustifyH("RIGHT")
    btn.silverCol:SetTextColor(0.7, 0.7, 0.7)
    btn.silverCol:SetWidth(28)

    btn.copperCol = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    btn.copperCol:SetJustifyH("RIGHT")
    btn.copperCol:SetTextColor(0.7, 0.7, 0.7)
    btn.copperCol:SetWidth(28)

    -- Each column anchored independently (no chaining) to avoid collapse when empty
    -- Positions from right: copper(-5) | silver(-35) | gold(-65)
    btn.copperCol:SetPoint("RIGHT", btn, "RIGHT", -5, 0)
    btn.copperCol:SetPoint("BOTTOM", btn.infoText, "BOTTOM", 0, 0)

    btn.silverCol:SetPoint("RIGHT", btn, "RIGHT", -35, 0)
    btn.silverCol:SetPoint("BOTTOM", btn.infoText, "BOTTOM", 0, 0)

    btn.goldCol:SetPoint("RIGHT", btn, "RIGHT", -65, 0)
    btn.goldCol:SetPoint("BOTTOM", btn.infoText, "BOTTOM", 0, 0)
end

-- Set aligned price columns from a copper value
function Utils:SetPriceColumns(btn, copper)
    if not copper or copper == 0 then
        btn.goldCol:SetText("00" .. CreateAtlasMarkup("coin-gold", 12, 12))
        btn.silverCol:SetText("00" .. CreateAtlasMarkup("coin-silver", 12, 12))
        btn.copperCol:SetText("00" .. CreateAtlasMarkup("coin-copper", 12, 12))
        return
    end

    local g = math.floor(copper / C.COPPER_PER_GOLD)
    local s = math.floor((copper % C.COPPER_PER_GOLD) / C.COPPER_PER_SILVER)
    local co = copper % C.COPPER_PER_SILVER

    -- Always show all 3 columns with 00 when value is 0 for consistent alignment
    btn.goldCol:SetText((g > 0 and g or "00") .. CreateAtlasMarkup("coin-gold", 12, 12))
    btn.silverCol:SetText((s > 0 and s or "00") .. CreateAtlasMarkup("coin-silver", 12, 12))
    btn.copperCol:SetText((co > 0 and co or "00") .. CreateAtlasMarkup("coin-copper", 12, 12))
end
