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
local Blacklist = addon.Blacklist
local BlacklistFrame = addon.BlacklistFrame

-- Initialize addon
local function Initialize()
    -- Initialize blacklist (loads SavedVariables)
    Blacklist:Initialize()

    -- Create main frame
    local frame = MainFrame:Create()

    -- Create filter buttons
    FilterButtons:CreateAll(frame)

    -- Initialize item list
    ItemList:Initialize(frame)

    -- Initialize profession button
    ProfessionButton:Initialize()

    -- Apply keybinding to disenchant button
    local function ApplyKeybinding()
        local key = GetBindingKey("SDEBTN")
        ClearOverrideBindings(SimpleDisenchantButton)
        if key then
            SetOverrideBindingClick(SimpleDisenchantButton, true, key, "SimpleDisenchantButton", "LeftButton")
        end
    end

    -- Register events
    frame:RegisterEvent("BAG_UPDATE_DELAYED")
    frame:RegisterEvent("PLAYER_REGEN_ENABLED")
    frame:RegisterEvent("PLAYER_REGEN_DISABLED")
    frame:RegisterEvent("UPDATE_BINDINGS")
    frame:RegisterEvent("PLAYER_LOGIN")
    frame:SetScript("OnEvent", function(self, event)
        if event == "PLAYER_LOGIN" or event == "UPDATE_BINDINGS" then
            ApplyKeybinding()
        elseif event == "PLAYER_REGEN_DISABLED" then
            -- Entering combat: show overlay on visible frames
            MainFrame:SetCombatMode(true)
        elseif event == "PLAYER_REGEN_ENABLED" then
            -- Leaving combat: remove overlay and refresh
            MainFrame:SetCombatMode(false)
            if MainFrame:IsShown() then
                ItemList:ScanBags()
            end
        elseif event == "BAG_UPDATE_DELAYED" then
            if MainFrame:IsShown() and not InCombatLockdown() then
                ItemList:ScanBags()
            end
        end
    end)
end

-- Slash command
SLASH_SIMPLEDISENCHANT1 = "/sde"
SlashCmdList["SIMPLEDISENCHANT"] = function(msg)
    local cmd = msg:lower():trim()

    if cmd == "blacklist" or cmd == "bl" then
        -- Open blacklist frame
        BlacklistFrame:Toggle()
    elseif cmd == "blacklist clear" or cmd == "bl clear" then
        -- Clear blacklist
        Blacklist:Clear()
        if BlacklistFrame:IsShown() then
            BlacklistFrame:Refresh()
        end
        if MainFrame:IsShown() then
            ItemList:ScanBags()
        end
    else
        -- Default: toggle main frame
        MainFrame:Toggle()
        if MainFrame:IsShown() then
            ItemList:ScanBags()
        end
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
