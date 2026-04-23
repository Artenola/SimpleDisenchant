-- SimpleDisenchant: Main Entry Point
local addonName, addon = ...

-- Update locale now that all locale files are loaded
addon.currentLocale = addon.L[addon.playerLocale] or addon.L["enUS"]

local L = addon.currentLocale
local Utils = addon.Utils
local MainFrame = addon.MainFrame
local FilterPanel = addon.FilterPanel
local ItemList = addon.ItemList
local ProfessionButton = addon.ProfessionButton
local Blacklist = addon.Blacklist
local BlacklistFrame = addon.BlacklistFrame
local FilteredItemsFrame = addon.FilteredItemsFrame
local MinimapButton = addon.MinimapButton
local DataBroker = addon.DataBroker

-- Initialize addon
local function Initialize()
    -- Initialize blacklist (loads SavedVariables)
    Blacklist:Initialize()

    -- Create main frame
    local frame = MainFrame:Create()

    -- Create filter panel (replaces old quality filter buttons)
    FilterPanel:CreateAll(frame)

    -- Initialize item list
    ItemList:Initialize(frame)

    -- Initialize profession button
    ProfessionButton:Initialize()

    -- Initialize minimap button
    MinimapButton:Initialize()

    -- Initialize LDB launcher (optional, requires LibDataBroker)
    DataBroker:Initialize()

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
            ItemList:OnBagUpdateDelayed()
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
    elseif cmd == "filtered" or cmd == "filter" then
        -- Open filtered items frame
        FilteredItemsFrame:Toggle()
    elseif cmd == "minimap" then
        MinimapButton:Toggle()
    elseif cmd == "reset" then
        -- Reset all window positions to defaults
        MainFrame:ResetPosition()
        BlacklistFrame:ResetPosition()
        FilteredItemsFrame:ResetPosition()
        Utils:Print(L.RESET_POSITIONS_MSG)
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
    if InCombatLockdown() then
        Utils:Print(L.COMBAT_WARNING)
        return
    end
    if IsShiftKeyDown() then
        MinimapButton:Toggle()
        return
    end
    if buttonName == "RightButton" then
        BlacklistFrame:Toggle()
    else
        MainFrame:Toggle()
        if MainFrame:IsShown() then
            ItemList:ScanBags()
        end
    end
end

-- Addon compartment tooltip
function SimpleDisenchant_OnAddonCompartmentEnter(addonName, button)
    GameTooltip:SetOwner(button, "ANCHOR_NONE")
    GameTooltip:SetPoint("TOPRIGHT", button, "BOTTOMRIGHT", 0, 0)
    GameTooltip:SetText(L.TITLE)
    GameTooltip:AddLine(L.MINIMAP_TOOLTIP_LEFT, 1, 1, 1)
    GameTooltip:AddLine(L.MINIMAP_TOOLTIP_RIGHT, 1, 1, 1)
    GameTooltip:AddLine(L.MINIMAP_TOOLTIP_HIDE, 0.7, 0.7, 0.7)
    GameTooltip:Show()
end

function SimpleDisenchant_OnAddonCompartmentLeave(addonName, button)
    GameTooltip:Hide()
end

-- Keybinding toggle handlers (called from Bindings.xml)
function SimpleDisenchant_ToggleFrame()
    MainFrame:Toggle()
    if MainFrame:IsShown() then
        ItemList:ScanBags()
    end
end

function SimpleDisenchant_ToggleBlacklist()
    BlacklistFrame:Toggle()
end

function SimpleDisenchant_ToggleAll()
    -- If any window is shown, close all. Otherwise, open all.
    local anyShown = MainFrame:IsShown() or BlacklistFrame:IsShown()
    if anyShown then
        if MainFrame:IsShown() then MainFrame:Toggle() end
        if BlacklistFrame:IsShown() then BlacklistFrame:Toggle() end
    else
        MainFrame:Toggle()
        BlacklistFrame:Toggle()
        if MainFrame:IsShown() then
            ItemList:ScanBags()
        end
    end
end

-- Initialize on load
Initialize()

-- Print load message
Utils:Print(L.LOADED_MSG)
