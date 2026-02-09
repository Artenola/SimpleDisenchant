-- SimpleDisenchant Blacklist System
local addonName, addon = ...

addon.Blacklist = {}
local Blacklist = addon.Blacklist

-- Reference to saved variables (will be set on ADDON_LOADED)
local blacklistedItems = {}
local initialized = false

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

function Blacklist:IsBlacklisted(itemID)
    return blacklistedItems[itemID] ~= nil
end

function Blacklist:Add(itemID, itemName)
    if not itemID then return false end

    blacklistedItems[itemID] = {
        name = itemName or "Unknown",
        addedAt = time()
    }

    -- Ensure it's saved to DB
    if SimpleDisenchantDB then
        SimpleDisenchantDB.blacklist = blacklistedItems
    end

    local L = addon.currentLocale
    addon.Utils:Print(string.format(L.BLACKLIST_ADDED or "%s added to blacklist", itemName or itemID))

    -- Refresh blacklist frame if open
    if addon.BlacklistFrame and addon.BlacklistFrame:IsShown() then
        addon.BlacklistFrame:Refresh()
    end

    return true
end

function Blacklist:Remove(itemID)
    if not itemID or not blacklistedItems[itemID] then return false end

    local itemName = blacklistedItems[itemID].name
    blacklistedItems[itemID] = nil

    -- Ensure it's saved to DB
    if SimpleDisenchantDB then
        SimpleDisenchantDB.blacklist = blacklistedItems
    end

    local L = addon.currentLocale
    addon.Utils:Print(string.format(L.BLACKLIST_REMOVED or "%s removed from blacklist", itemName or itemID))

    -- Refresh blacklist frame if open
    if addon.BlacklistFrame and addon.BlacklistFrame:IsShown() then
        addon.BlacklistFrame:Refresh()
    end

    return true
end

function Blacklist:Toggle(itemID, itemName)
    if self:IsBlacklisted(itemID) then
        return self:Remove(itemID)
    else
        return self:Add(itemID, itemName)
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
