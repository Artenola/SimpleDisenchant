-- SimpleDisenchant: Main Entry Point
local addonName, addon = ...

-- Update locale now that all locale files are loaded
addon.currentLocale = addon.L[addon.playerLocale] or addon.L["enUS"]

local L = addon.currentLocale
local Utils = addon.Utils
local MainFrame = addon.MainFrame
local FilterButtons = addon.FilterButtons
local ItemList = addon.ItemList
local ProfessionButton = addon.ProfessionButton

-- Initialize addon
local function Initialize()
    -- Create main frame
    local frame = MainFrame:Create()

    -- Create filter buttons
    FilterButtons:CreateAll(frame)

    -- Initialize item list
    ItemList:Initialize(frame)

    -- Initialize profession button
    ProfessionButton:Initialize()

    -- Register events
    frame:RegisterEvent("BAG_UPDATE_DELAYED")
    frame:RegisterEvent("PLAYER_REGEN_ENABLED")
    frame:SetScript("OnEvent", function(self, event)
        if MainFrame:IsShown() and not InCombatLockdown() then
            ItemList:ScanBags()
        end
    end)
end

-- Slash command
SLASH_SIMPLEDISENCHANT1 = "/sde"
SlashCmdList["SIMPLEDISENCHANT"] = function()
    MainFrame:Toggle()
    if MainFrame:IsShown() then
        ItemList:ScanBags()
    end
end

-- Addon compartment click handler
function SimpleDisenchant_OnAddonCompartmentClick(addonName, buttonName)
    MainFrame:Toggle()
    if MainFrame:IsShown() then
        ItemList:ScanBags()
    end
end

-- Initialize on load
Initialize()

-- Print load message
Utils:Print(L.LOADED_MSG)
