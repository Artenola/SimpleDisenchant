-- SimpleDisenchant Main Frame
local addonName, addon = ...

local L = addon.currentLocale
local C = addon.Constants
local Utils = addon.Utils

addon.MainFrame = {}
local MainFrame = addon.MainFrame

-- Main frame reference
local frame

function MainFrame:Create()
    if frame then return frame end

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
    if not frame then
        self:Create()
    end
    frame:Show()
end

function MainFrame:Hide()
    if frame then
        frame:Hide()
    end
end

function MainFrame:Toggle()
    if frame and frame:IsShown() then
        self:Hide()
    else
        self:Show()
    end
end

function MainFrame:IsShown()
    return frame and frame:IsShown()
end
