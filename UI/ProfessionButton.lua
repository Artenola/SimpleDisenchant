-- SimpleDisenchant Profession Button
local addonName, addon = ...

local C = addon.Constants

addon.ProfessionButton = {}
local ProfessionButton = addon.ProfessionButton

local professionButton = nil

local function CreateButton()
    if professionButton then return end
    if not ProfessionsFrame then return end

    professionButton = CreateFrame("Button", "SimpleDisenchantProfessionButton", ProfessionsFrame)
    professionButton:SetSize(36, 36)
    professionButton:SetPoint("LEFT", ProfessionsFrame.CraftingPage.ConcentrationDisplay, "RIGHT", 0, 0)
    professionButton:RegisterForClicks("LeftButtonUp")
    professionButton:RegisterForDrag("LeftButton")

    -- Icon
    professionButton.icon = professionButton:CreateTexture(nil, "ARTWORK")
    professionButton.icon:SetSize(36, 36)
    professionButton.icon:SetPoint("CENTER")
    professionButton.icon:SetTexture("Interface\\Icons\\INV_Enchant_Disenchant")

    -- Highlight
    professionButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")

    -- Click to open SimpleDisenchant
    professionButton:SetScript("OnClick", function()
        addon.MainFrame:Toggle()
        if addon.MainFrame:IsShown() then
            addon.ItemList:ScanBags()
        end
    end)

    -- Drag to create macro on action bar
    professionButton:SetScript("OnDragStart", function()
        if InCombatLockdown() then return end

        local macroName = "SimpleDE"
        local macroIndex = GetMacroIndexByName(macroName)

        if macroIndex == 0 then
            macroIndex = CreateMacro(macroName, "INV_Enchant_Disenchant", "/sde", false)
        end

        if macroIndex and macroIndex > 0 then
            PickupMacro(macroIndex)
        end
    end)

    professionButton:SetScript("OnEnter", function(self)
        local L = addon.currentLocale
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(L.TITLE)
        GameTooltip:AddLine(L.LOADED_MSG, 1, 1, 1)
        GameTooltip:AddLine(L.DRAG_TO_ACTIONBAR, 0.7, 0.7, 0.7)
        GameTooltip:Show()
    end)
    professionButton:SetScript("OnLeave", GameTooltip_Hide)
end

local function OnProfessionsFrameShow()
    -- Check if it's Enchanting (profession ID 333)
    local profInfo = C_TradeSkillUI.GetBaseProfessionInfo()
    if profInfo and profInfo.professionID == C.ENCHANTING_PROFESSION_ID then
        CreateButton()
        if professionButton then
            professionButton:Show()
        end
    elseif professionButton then
        professionButton:Hide()
    end
end

local function SetupProfessionsHook()
    if ProfessionsFrame then
        ProfessionsFrame:HookScript("OnShow", OnProfessionsFrameShow)
    end
end

function ProfessionButton:Initialize()
    -- Wait for Blizzard_Professions to load
    if C_AddOns.IsAddOnLoaded("Blizzard_Professions") then
        SetupProfessionsHook()
    else
        local loader = CreateFrame("Frame")
        loader:RegisterEvent("ADDON_LOADED")
        loader:SetScript("OnEvent", function(self, event, loadedAddon)
            if loadedAddon == "Blizzard_Professions" then
                SetupProfessionsHook()
                self:UnregisterEvent("ADDON_LOADED")
            end
        end)
    end
end
