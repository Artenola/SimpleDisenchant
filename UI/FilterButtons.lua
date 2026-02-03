-- SimpleDisenchant Filter Buttons
local addonName, addon = ...

local C = addon.Constants

addon.FilterButtons = {}
local FilterButtons = addon.FilterButtons

-- Active filters (true = shown)
local qualityFilters = {
    [2] = true,  -- Green
    [3] = true,  -- Blue
    [4] = true,  -- Purple
}

-- Callback when filter changes
local onFilterChanged = nil

function FilterButtons:SetCallback(callback)
    onFilterChanged = callback
end

function FilterButtons:IsQualityEnabled(quality)
    return qualityFilters[quality]
end

function FilterButtons:CreateButton(parent, quality, label, xOffset)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(60, 22)
    btn:SetPoint("TOP", parent, "TOP", xOffset, -110)

    local color = C.QUALITY_COLORS[quality]

    -- Background
    btn.inner = btn:CreateTexture(nil, "BACKGROUND")
    btn.inner:SetAllPoints()
    btn.inner:SetColorTexture(0.1, 0.1, 0.1, 0.9)

    -- Text
    btn.text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    btn.text:SetPoint("CENTER")
    btn.text:SetText(label)
    btn.text:SetTextColor(color[1], color[2], color[3], 1)

    -- Store quality
    btn.quality = quality

    btn:SetScript("OnClick", function(self)
        qualityFilters[self.quality] = not qualityFilters[self.quality]

        -- Update appearance
        if qualityFilters[self.quality] then
            self.inner:SetColorTexture(0.1, 0.1, 0.1, 0.9)
            self.text:SetAlpha(1)
        else
            self.inner:SetColorTexture(0.05, 0.05, 0.05, 0.9)
            self.text:SetAlpha(0.4)
        end

        -- Trigger callback
        if onFilterChanged and not InCombatLockdown() then
            onFilterChanged()
        end
    end)

    btn:SetScript("OnEnter", function(self)
        self.inner:SetColorTexture(0.2, 0.2, 0.2, 0.9)
    end)

    btn:SetScript("OnLeave", function(self)
        if qualityFilters[self.quality] then
            self.inner:SetColorTexture(0.1, 0.1, 0.1, 0.9)
        else
            self.inner:SetColorTexture(0.05, 0.05, 0.05, 0.9)
        end
    end)

    return btn
end

function FilterButtons:CreateAll(parent)
    local L = addon.currentLocale
    local green = self:CreateButton(parent, 2, L.QUALITY_GREEN, -70)
    local blue = self:CreateButton(parent, 3, L.QUALITY_BLUE, 0)
    local purple = self:CreateButton(parent, 4, L.QUALITY_PURPLE, 70)

    return green, blue, purple
end
