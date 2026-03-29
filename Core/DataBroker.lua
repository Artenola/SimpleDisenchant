-- SimpleDisenchant LibDataBroker Launcher
-- Provides a data object for display addons (Bazooka, Titan Panel, ChocolateBar, etc.)
local addonName, addon = ...

addon.DataBroker = {}
local DataBroker = addon.DataBroker

function DataBroker:Initialize()
    -- LibDataBroker is optional: graceful fallback if not available
    local LDB = LibStub and LibStub("LibDataBroker-1.1", true)
    if not LDB then return end

    local launcher = LDB:NewDataObject("SimpleDisenchant", {
        type = "launcher",
        icon = "Interface\\Icons\\INV_Enchant_Disenchant",
        label = "SimpleDisenchant",

        OnClick = function(_, button)
            if InCombatLockdown() then
                addon.Utils:Print(addon.currentLocale.COMBAT_WARNING)
                return
            end

            if IsShiftKeyDown() then
                addon.MinimapButton:Toggle()
                return
            end

            if button == "RightButton" then
                addon.BlacklistFrame:Toggle()
            else
                addon.MainFrame:Toggle()
                if addon.MainFrame:IsShown() then
                    addon.ItemList:ScanBags()
                end
            end
        end,

        OnTooltipShow = function(tooltip)
            local L = addon.currentLocale
            tooltip:AddLine("SimpleDisenchant")
            tooltip:AddLine(L.MINIMAP_TOOLTIP_LEFT, 1, 1, 1)
            tooltip:AddLine(L.MINIMAP_TOOLTIP_RIGHT, 1, 1, 1)
            tooltip:AddLine(L.MINIMAP_TOOLTIP_HIDE, 0.7, 0.7, 0.7)
        end,
    })
end
