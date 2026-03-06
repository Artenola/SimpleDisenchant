-- SimpleDisenchant Minimap Button
local addonName, addon = ...

addon.MinimapButton = {}
local MinimapButton = addon.MinimapButton

local button = nil
local BUTTON_SIZE = 31

-- Calculate radius from actual minimap size + small offset to sit on the edge
local function GetButtonRadius()
    local w = Minimap:GetWidth() or 140
    return (w / 2) + 10
end

-- Update button position from angle (degrees)
local function UpdatePosition(angle)
    if not button then return end
    local radius = GetButtonRadius()
    local rads = math.rad(angle)
    local x = math.cos(rads) * radius
    local y = math.sin(rads) * radius
    button:ClearAllPoints()
    button:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

-- Calculate angle from cursor position relative to minimap center
local function GetAngleFromCursor()
    local mx, my = Minimap:GetCenter()
    local cx, cy = GetCursorPosition()
    local scale = Minimap:GetEffectiveScale()
    cx, cy = cx / scale, cy / scale
    return math.deg(math.atan2(cy - my, cx - mx))
end

function MinimapButton:Create()
    if button then return button end

    local L = addon.currentLocale

    button = CreateFrame("Button", "SimpleDisenchantMinimapButton", Minimap)
    button:SetSize(BUTTON_SIZE, BUTTON_SIZE)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(8)
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:RegisterForDrag("LeftButton")

    -- Icon
    button.icon = button:CreateTexture(nil, "ARTWORK")
    button.icon:SetSize(18, 18)
    button.icon:SetPoint("CENTER", 0, 0)
    button.icon:SetTexture("Interface\\Icons\\INV_Enchant_Disenchant")

    -- Minimap button border (texture is offset, anchor TOPLEFT to center visually)
    button.border = button:CreateTexture(nil, "OVERLAY")
    button.border:SetSize(52, 52)
    button.border:SetPoint("TOPLEFT", 0, 0)
    button.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

    -- Background
    button.background = button:CreateTexture(nil, "BACKGROUND")
    button.background:SetSize(21, 21)
    button.background:SetPoint("CENTER", 0, 0)
    button.background:SetTexture("Interface\\Minimap\\UI-Minimap-Background")

    -- Highlight
    button.highlight = button:CreateTexture(nil, "HIGHLIGHT")
    button.highlight:SetSize(21, 21)
    button.highlight:SetPoint("CENTER", 0, 0)
    button.highlight:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    button.highlight:SetBlendMode("ADD")

    -- Click handler
    button:SetScript("OnClick", function(self, btn)
        if InCombatLockdown() then
            addon.Utils:Print(addon.currentLocale.COMBAT_WARNING)
            return
        end
        if IsShiftKeyDown() then
            MinimapButton:Hide()
            addon.Utils:Print(addon.currentLocale.MINIMAP_HIDDEN_MSG)
            return
        end
        if btn == "RightButton" then
            addon.BlacklistFrame:Toggle()
        else
            addon.MainFrame:Toggle()
            if addon.MainFrame:IsShown() then
                addon.ItemList:ScanBags()
            end
        end
    end)

    -- Tooltip
    button:SetScript("OnEnter", function(self)
        local L = addon.currentLocale
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText(L.TITLE)
        GameTooltip:AddLine(L.MINIMAP_TOOLTIP_LEFT, 1, 1, 1)
        GameTooltip:AddLine(L.MINIMAP_TOOLTIP_RIGHT, 1, 1, 1)
        GameTooltip:AddLine(L.MINIMAP_TOOLTIP_DRAG, 0.7, 0.7, 0.7)
        GameTooltip:AddLine(L.MINIMAP_TOOLTIP_HIDE, 0.7, 0.7, 0.7)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", GameTooltip_Hide)

    -- Drag to reposition
    button:SetScript("OnDragStart", function(self)
        self:SetScript("OnUpdate", function()
            local angle = GetAngleFromCursor()
            UpdatePosition(angle)
            if SimpleDisenchantDB and SimpleDisenchantDB.minimap then
                SimpleDisenchantDB.minimap.angle = angle
            end
        end)
        GameTooltip:Hide()
    end)

    button:SetScript("OnDragStop", function(self)
        self:SetScript("OnUpdate", nil)
    end)

    -- Set initial position from saved angle
    local angle = 225
    if SimpleDisenchantDB and SimpleDisenchantDB.minimap then
        angle = SimpleDisenchantDB.minimap.angle or 225
        if SimpleDisenchantDB.minimap.hidden then
            button:Hide()
        end
    end
    UpdatePosition(angle)

    return button
end

function MinimapButton:Initialize()
    local loader = CreateFrame("Frame")
    loader:RegisterEvent("PLAYER_LOGIN")
    loader:SetScript("OnEvent", function(self, event)
        MinimapButton:Create()
        self:UnregisterEvent("PLAYER_LOGIN")
    end)
end

function MinimapButton:Show()
    if button then
        button:Show()
        if SimpleDisenchantDB and SimpleDisenchantDB.minimap then
            SimpleDisenchantDB.minimap.hidden = false
        end
    end
end

function MinimapButton:Hide()
    if button then
        button:Hide()
        if SimpleDisenchantDB and SimpleDisenchantDB.minimap then
            SimpleDisenchantDB.minimap.hidden = true
        end
    end
end

function MinimapButton:Toggle()
    if button and button:IsShown() then
        self:Hide()
    else
        self:Show()
    end
end
