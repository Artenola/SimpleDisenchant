-- SimpleDisenchant Blacklist System
local addonName, addon = ...

addon.Blacklist = {}
local Blacklist = addon.Blacklist

-- Reference to saved variables (will be set on ADDON_LOADED)
local blacklistedItems = {}
local initialized = false

-- Helper to extract unique item string from item link
-- Format: item:itemID:enchantID:gemID1:gemID2:gemID3:gemID4:suffixID:uniqueID:linkLevel:specializationID:upgradeTypeID:instanceDifficultyID:numBonusIDs:bonusID1:bonusID2:...
local function GetItemStringFromLink(itemLink)
    if not itemLink then return nil end
    -- Extract the full item string from the link
    local itemString = itemLink:match("item[%-?%d:]+")
    return itemString
end

-- Get the blacklist key from an item link
local function GetBlacklistKey(itemLink)
    local itemString = GetItemStringFromLink(itemLink)
    if not itemString then return nil end
    return itemString
end

function Blacklist:Initialize()
    if initialized then return end

    -- Create event frame to wait for ADDON_LOADED
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("ADDON_LOADED")
    eventFrame:SetScript("OnEvent", function(self, event, loadedAddon)
        if loadedAddon == addonName then
            -- Now SavedVariables are available
            if not SimpleDisenchantDB then
                SimpleDisenchantDB = {}
            end
            if not SimpleDisenchantDB.blacklist then
                SimpleDisenchantDB.blacklist = {}
            end
            blacklistedItems = SimpleDisenchantDB.blacklist
            initialized = true
            self:UnregisterEvent("ADDON_LOADED")
        end
    end)
end

function Blacklist:IsBlacklisted(itemLink)
    if not itemLink then return false end
    local key = GetBlacklistKey(itemLink)
    if not key then return false end
    return blacklistedItems[key] ~= nil
end

function Blacklist:Add(itemLink, itemName, itemID)
    if not itemLink then return false end

    local key = GetBlacklistKey(itemLink)
    if not key then return false end

    blacklistedItems[key] = {
        name = itemName or "Unknown",
        itemID = itemID,
        link = itemLink,
        addedAt = time()
    }

    -- Ensure it's saved to DB
    if SimpleDisenchantDB then
        SimpleDisenchantDB.blacklist = blacklistedItems
    end

    local L = addon.currentLocale
    addon.Utils:Print(string.format(L.BLACKLIST_ADDED or "%s added to blacklist", itemName or key))

    -- Refresh blacklist frame if open
    if addon.BlacklistFrame and addon.BlacklistFrame:IsShown() then
        addon.BlacklistFrame:Refresh()
    end

    return true
end

function Blacklist:Remove(key)
    if not key or not blacklistedItems[key] then return false end

    local itemName = blacklistedItems[key].name
    blacklistedItems[key] = nil

    -- Ensure it's saved to DB
    if SimpleDisenchantDB then
        SimpleDisenchantDB.blacklist = blacklistedItems
    end

    local L = addon.currentLocale
    addon.Utils:Print(string.format(L.BLACKLIST_REMOVED or "%s removed from blacklist", itemName or key))

    -- Refresh blacklist frame if open
    if addon.BlacklistFrame and addon.BlacklistFrame:IsShown() then
        addon.BlacklistFrame:Refresh()
    end

    return true
end

function Blacklist:Toggle(itemLink, itemName, itemID)
    if self:IsBlacklisted(itemLink) then
        local key = GetBlacklistKey(itemLink)
        return self:Remove(key)
    else
        return self:Add(itemLink, itemName, itemID)
    end
end

function Blacklist:GetAll()
    return blacklistedItems
end

function Blacklist:GetCount()
    local count = 0
    for _ in pairs(blacklistedItems) do
        count = count + 1
    end
    return count
end

function Blacklist:Clear()
    wipe(blacklistedItems)
    if SimpleDisenchantDB then
        SimpleDisenchantDB.blacklist = blacklistedItems
    end

    local L = addon.currentLocale
    addon.Utils:Print(L.BLACKLIST_CLEARED or "Blacklist cleared")

    -- Refresh blacklist frame if open
    if addon.BlacklistFrame and addon.BlacklistFrame:IsShown() then
        addon.BlacklistFrame:Refresh()
    end
end
