-- SimpleDisenchant Main Frame
local addonName, addon = ...

local C = addon.Constants
local Utils = addon.Utils

addon.MainFrame = {}
local MainFrame = addon.MainFrame

-- Main frame reference
local frame
local combatOverlay

function MainFrame:Create()
    if frame then return frame end

    local L = addon.currentLocale

    -- Create main frame with Blizzard portrait template
    frame = CreateFrame("Frame", "SimpleDisenchantFrame", UIParent, "PortraitFrameTemplate")
    frame:SetSize(C.FRAME_WIDTH, C.FRAME_HEIGHT)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:Hide()

    -- Allow closing with Escape
    tinsert(UISpecialFrames, "SimpleDisenchantFrame")

    -- Set portrait icon
    frame:SetPortraitToAsset("Interface\\Icons\\INV_Enchant_Disenchant")

    -- Set title
    frame:SetTitle(L.TITLE)

    -- Blacklist button (top right corner)
    local blBtn = CreateFrame("Button", nil, frame)
    blBtn:SetSize(24, 24)
    blBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -30, -2)

    blBtn.icon = blBtn:CreateTexture(nil, "ARTWORK")
    blBtn.icon:SetAllPoints()
    blBtn.icon:SetTexture("Interface\\Icons\\INV_Misc_Cancel")
    blBtn.icon:SetDesaturated(false)

    blBtn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")

    blBtn:SetScript("OnClick", function()
        addon.BlacklistFrame:Toggle()
    end)

    blBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(L.BLACKLIST_TITLE or "Blacklist")
        GameTooltip:AddLine(L.BLACKLIST_HINT or "Right-click to blacklist", 1, 1, 1)
        GameTooltip:Show()
    end)
    blBtn:SetScript("OnLeave", GameTooltip_Hide)

    -- Dock to ProfessionsFrame when opened from there
    frame:HookScript("OnShow", function(self)
        if ProfessionsFrame and ProfessionsFrame:IsShown() then
            self:ClearAllPoints()
            self:SetPoint("TOPLEFT", ProfessionsFrame, "TOPRIGHT", 5, 0)
        end
    end)

    -- Store reference
    addon.frame = frame

    return frame
end

function MainFrame:GetFrame()
    return frame
end

function MainFrame:Show()
    if InCombatLockdown() then
        Utils:Print(addon.currentLocale.COMBAT_WARNING)
        return
    end
    if not frame then
        self:Create()
    end
    frame:Show()
end

function MainFrame:Hide()
    if InCombatLockdown() then return end
    if frame then
        frame:Hide()
    end
end

function MainFrame:Toggle()
    if InCombatLockdown() then
        Utils:Print(addon.currentLocale.COMBAT_WARNING)
        return
    end
    if frame and frame:IsShown() then
        self:Hide()
    else
        self:Show()
    end
end

function MainFrame:IsShown()
    return frame and frame:IsShown()
end

function MainFrame:SetCombatMode(inCombat)
    if not frame then return end

    -- Create overlay on first use
    if not combatOverlay then
        combatOverlay = CreateFrame("Frame", nil, frame)
        combatOverlay:SetAllPoints()
        combatOverlay:SetFrameLevel(frame:GetFrameLevel() + 100)
        combatOverlay:EnableMouse(true)

        combatOverlay.bg = combatOverlay:CreateTexture(nil, "BACKGROUND")
        combatOverlay.bg:SetAllPoints()
        combatOverlay.bg:SetColorTexture(0, 0, 0, 0.6)

        combatOverlay.text = combatOverlay:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        combatOverlay.text:SetPoint("CENTER", 0, 0)
        combatOverlay.text:SetTextColor(1, 0.3, 0.3, 1)

        combatOverlay:Hide()
    end

    local L = addon.currentLocale
    combatOverlay.text:SetText(L.COMBAT_OVERLAY)

    if inCombat then
        combatOverlay:Show()
    else
        combatOverlay:Hide()
    end
end
