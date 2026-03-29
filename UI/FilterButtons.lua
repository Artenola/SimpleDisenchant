-- SimpleDisenchant Filter Panel (search box + filter dropdown)
-- Uses WoW's native menu API (SetupMenu, CreateCheckbox, CreateTemplate)
local addonName, addon = ...

local C = addon.Constants

addon.FilterPanel = {}
local FilterPanel = addon.FilterPanel

-- UI references
local filterButton
local searchBox

-- Callback when any filter changes
local onFilterChanged = nil

-- Debounce timer for range inputs
local rangeTimer = nil

-- Get current filter settings from SavedVariables
local function GetFilters()
    if SimpleDisenchantDB and SimpleDisenchantDB.filters then
        return SimpleDisenchantDB.filters
    end
    return C.DEFAULT_FILTERS
end

-- Save filter settings to SavedVariables
local function SaveFilters(filters)
    if SimpleDisenchantDB then
        SimpleDisenchantDB.filters = filters
    end
end

-- =====================
-- Public API
-- =====================

function FilterPanel:SetCallback(callback)
    onFilterChanged = callback
end

function FilterPanel:IsQualityEnabled(quality)
    local filters = GetFilters()
    return filters.quality[quality]
end

function FilterPanel:GetIlvlMin()
    return GetFilters().ilvlMin
end

function FilterPanel:GetIlvlMax()
    return GetFilters().ilvlMax
end

function FilterPanel:GetGoldMin()
    return GetFilters().goldMin
end

function FilterPanel:GetGoldMax()
    return GetFilters().goldMax
end

function FilterPanel:GetSearchText()
    if searchBox then
        return searchBox:GetText()
    end
    return ""
end

-- Check if an item passes the ilvl/gold filters
-- Returns: passesIlvl, passesGold
function FilterPanel:CheckItemFilters(itemLevel, sellPrice)
    local filters = GetFilters()
    local passesIlvl = true
    local passesGold = true

    -- Item Level check
    if filters.ilvlMin and itemLevel and itemLevel < filters.ilvlMin then
        passesIlvl = false
    end
    if filters.ilvlMax and itemLevel and itemLevel > filters.ilvlMax then
        passesIlvl = false
    end

    -- Gold check (stored in copper)
    if filters.goldMin and sellPrice and sellPrice < filters.goldMin then
        passesGold = false
    end
    if filters.goldMax and sellPrice and sellPrice > filters.goldMax then
        passesGold = false
    end

    return passesIlvl, passesGold
end

-- Check if any filter differs from defaults
function FilterPanel:HasActiveFilters()
    local filters = GetFilters()

    -- Check equipment set filter (default: true = hidden, so false = active filter change)
    if filters.hideEquipmentSets == false then
        return true
    end

    -- Check quality (default: all true)
    if not filters.quality[2] or not filters.quality[3] or not filters.quality[4] then
        return true
    end

    -- Check ilvl (default: nil)
    if filters.ilvlMin or filters.ilvlMax then
        return true
    end

    -- Check gold (default: nil)
    if filters.goldMin or filters.goldMax then
        return true
    end

    return false
end

-- =====================
-- Internal helpers
-- =====================

function FilterPanel:NotifyChange()
    if onFilterChanged and not InCombatLockdown() then
        onFilterChanged()
    end
    if filterButton then
        filterButton:ValidateResetState()
    end
end

-- Debounced notify for range input changes (avoid excessive ScanBags on each keystroke)
local function ScheduleRangeUpdate()
    if rangeTimer then rangeTimer:Cancel() end
    rangeTimer = C_Timer.NewTimer(0.5, function()
        FilterPanel:NotifyChange()
    end)
end

function FilterPanel:ResetFilters()
    local filters = {
        quality = { [2] = true, [3] = true, [4] = true },
        ilvlMin = nil,
        ilvlMax = nil,
        goldMin = nil,
        goldMax = nil,
        hideEquipmentSets = true,
    }
    SaveFilters(filters)

    -- Clear search box
    if searchBox then
        searchBox:SetText("")
    end

    self:NotifyChange()
end

-- =====================
-- Search box + Filter dropdown (WoW profession style)
-- =====================

function FilterPanel:CreateSearchAndFilterBar(parent)
    local L = addon.currentLocale

    -- Search box (Blizzard SearchBoxTemplate)
    searchBox = CreateFrame("EditBox", "SimpleDisenchantSearchBox", parent, "SearchBoxTemplate")
    searchBox:SetSize(210, 20)
    searchBox:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, -112)

    -- Instant search on each keystroke
    searchBox:HookScript("OnTextChanged", function(self, userInput)
        FilterPanel:NotifyChange()
    end)

    -- Filter dropdown button (WoW profession style)
    filterButton = CreateFrame("DropdownButton", "SimpleDisenchantFilterButton", parent, "WowStyle1FilterDropdownTemplate")
    filterButton.resizeToText = false
    filterButton:SetWidth(80)
    filterButton.Text:SetText(L.FILTER_BUTTON)
    filterButton:SetPoint("LEFT", searchBox, "RIGHT", 3, 0)

    -- Reset callback (built-in reset button on the dropdown)
    filterButton:SetDefaultCallback(function()
        FilterPanel:ResetFilters()
    end)

    -- Check if filters are at default (controls reset button visibility)
    filterButton:SetIsDefaultCallback(function()
        return not FilterPanel:HasActiveFilters()
    end)

    -- Build the filter menu using WoW's native menu API
    filterButton:SetupMenu(function(dropdown, rootDescription)
        rootDescription:SetTag("MENU_SIMPLEDISENCHANT_FILTER")

        -- === Rarity section (colored quality names like AH) ===
        local rarityTitle = rootDescription:CreateTitle(L.FILTER_RARITY)
        rarityTitle:SetTooltip(function(tooltip, elementDescription)
            GameTooltip_SetTitle(tooltip, L.FILTER_RARITY)
            GameTooltip_AddNormalLine(tooltip, L.FILTER_RARITY_TOOLTIP)
        end)
        for _, quality in ipairs({ 2, 3, 4 }) do
            local hex = select(4, C_Item.GetItemQualityColor(quality))
            local text = _G["ITEM_QUALITY" .. quality .. "_DESC"]
            local label = "|c" .. hex .. text .. "|r"
            rootDescription:CreateCheckbox(label, function()
                return FilterPanel:IsQualityEnabled(quality)
            end, function()
                local f = GetFilters()
                f.quality[quality] = not f.quality[quality]
                SaveFilters(f)
                FilterPanel:NotifyChange()
            end)
        end

        rootDescription:CreateSpacer()

        -- === Item Level Range ===
        local ilvlTitle = rootDescription:CreateTitle(L.FILTER_ITEM_LEVEL)
        ilvlTitle:SetTooltip(function(tooltip, elementDescription)
            GameTooltip_SetTitle(tooltip, L.FILTER_ITEM_LEVEL)
            GameTooltip_AddNormalLine(tooltip, L.FILTER_ILVL_TOOLTIP)
        end)
        local ilvlRange = rootDescription:CreateTemplate("LevelRangeFrameTemplate")
        ilvlRange:AddInitializer(function(frame, elementDescription, menu)
            frame:Reset()
            frame.MinLevel:SetMaxLetters(4)
            frame.MaxLevel:SetMaxLetters(4)

            local filters = GetFilters()
            if filters.ilvlMin and filters.ilvlMin > 0 then
                frame:SetMinLevel(filters.ilvlMin)
            end
            if filters.ilvlMax and filters.ilvlMax > 0 then
                frame:SetMaxLevel(filters.ilvlMax)
            end

            frame:SetLevelRangeChangedCallback(function(minLevel, maxLevel)
                local f = GetFilters()
                f.ilvlMin = (minLevel > 0) and minLevel or nil
                f.ilvlMax = (maxLevel > 0) and maxLevel or nil
                SaveFilters(f)
                filterButton:ValidateResetState()
                ScheduleRangeUpdate()
            end)
        end)

        rootDescription:CreateSpacer()

        -- === Vendor Price Range (in gold) ===
        local goldTitle = rootDescription:CreateTitle(L.FILTER_VENDOR_PRICE .. " " .. CreateAtlasMarkup("coin-gold", 12, 12))
        goldTitle:SetTooltip(function(tooltip, elementDescription)
            GameTooltip_SetTitle(tooltip, L.FILTER_VENDOR_PRICE)
            GameTooltip_AddNormalLine(tooltip, L.FILTER_GOLD_TOOLTIP)
        end)
        local goldRange = rootDescription:CreateTemplate("LevelRangeFrameTemplate")
        goldRange:AddInitializer(function(frame, elementDescription, menu)
            frame:Reset()
            frame.MinLevel:SetMaxLetters(6)
            frame.MaxLevel:SetMaxLetters(6)
            frame.MinLevel:SetWidth(40)
            frame.MaxLevel:SetWidth(40)

            local filters = GetFilters()
            if filters.goldMin then
                frame:SetMinLevel(math.floor(filters.goldMin / C.COPPER_PER_GOLD))
            end
            if filters.goldMax then
                frame:SetMaxLevel(math.floor(filters.goldMax / C.COPPER_PER_GOLD))
            end

            frame:SetLevelRangeChangedCallback(function(minGold, maxGold)
                local f = GetFilters()
                f.goldMin = (minGold > 0) and (minGold * C.COPPER_PER_GOLD) or nil
                f.goldMax = (maxGold > 0) and (maxGold * C.COPPER_PER_GOLD) or nil
                SaveFilters(f)
                filterButton:ValidateResetState()
                ScheduleRangeUpdate()
            end)
        end)

        rootDescription:CreateSpacer()

        -- === Equipment Set filter ===
        local equipSetCheckbox = rootDescription:CreateCheckbox(L.FILTER_HIDE_EQUIPMENT_SET, function()
            local f = GetFilters()
            return f.hideEquipmentSets ~= false
        end, function()
            local f = GetFilters()
            f.hideEquipmentSets = not (f.hideEquipmentSets ~= false)
            SaveFilters(f)
            FilterPanel:NotifyChange()
        end)
        equipSetCheckbox:SetTooltip(function(tooltip, elementDescription)
            GameTooltip_SetTitle(tooltip, L.FILTER_HIDE_EQUIPMENT_SET)
            GameTooltip_AddNormalLine(tooltip, L.FILTER_EQUIPMENT_SET_TOOLTIP)
        end)
    end)

    return searchBox, filterButton
end

-- Main entry point (called from SimpleDisenchant.lua)
function FilterPanel:CreateAll(parent)
    self:CreateSearchAndFilterBar(parent)
end
