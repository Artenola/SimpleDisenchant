-- SimpleDisenchant Filtered Items Frame
local addonName, addon = ...

local C = addon.Constants
local Utils = addon.Utils

addon.FilteredItemsFrame = {}
local FilteredItemsFrame = addon.FilteredItemsFrame

local frame
local scrollBox, scrollBar
local countText
local pendingRefresh = false

function FilteredItemsFrame:Create()
    if frame then return frame end

    local L = addon.currentLocale

    frame = CreateFrame("Frame", "SimpleDisenchantFilteredFrame", UIParent, "PortraitFrameTemplate")
    frame:SetSize(C.FILTERED_FRAME_WIDTH, C.FILTERED_FRAME_HEIGHT)
    frame:SetPoint("CENTER", 350, 0)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:SetToplevel(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

    frame:SetTitle(L.FILTERED_TITLE)
    frame:SetPortraitToAsset("Interface\\Icons\\INV_Enchant_Disenchant")

    table.insert(UISpecialFrames, "SimpleDisenchantFilteredFrame")

    -- Count text
    countText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    countText:SetPoint("TOP", frame, "TOP", 0, -60)
    countText:SetText(string.format(L.FILTERED_COUNT, 0))

    -- Container for the scroll list
    local listContainer = CreateFrame("Frame", nil, frame)
    listContainer:SetPoint("TOPLEFT", 7, -80)
    listContainer:SetPoint("BOTTOMRIGHT", -7, 5)

    listContainer.bg = listContainer:CreateTexture(nil, "BACKGROUND")
    listContainer.bg:SetAllPoints()
    listContainer.bg:SetAtlas("Professions-background-summarylist")

    local inset = CreateFrame("Frame", nil, listContainer, "NineSlicePanelTemplate")
    inset:SetAllPoints()
    NineSliceUtil.ApplyLayoutByName(inset, "InsetFrameTemplate")

    scrollBox = CreateFrame("Frame", nil, listContainer, "WowScrollBoxList")
    scrollBox:SetPoint("TOPLEFT", listContainer, "TOPLEFT", 6, -3)
    scrollBox:SetPoint("BOTTOMRIGHT", listContainer, "BOTTOMRIGHT", -20, 5)

    scrollBar = CreateFrame("EventFrame", nil, listContainer, "MinimalScrollBar")
    scrollBar:SetPoint("TOPLEFT", scrollBox, "TOPRIGHT", 0, 0)
    scrollBar:SetPoint("BOTTOMLEFT", scrollBox, "BOTTOMRIGHT", 0, 0)

    local view = CreateScrollBoxListLinearView()
    view:SetElementExtent(C.ITEM_ROW_HEIGHT)

    view:SetElementInitializer("Button", function(btn, elementData)
        btn:SetSize(scrollBox:GetWidth(), C.ITEM_ROW_HEIGHT - 2)

        if not btn.bg then
            btn.bg = btn:CreateTexture(nil, "BACKGROUND")
            btn.bg:SetAllPoints()

            btn:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")

            btn.icon = btn:CreateTexture(nil, "ARTWORK")
            btn.icon:SetSize(24, 24)
            btn.icon:SetPoint("LEFT", btn, "LEFT", 4, 0)

            btn.text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            btn.text:SetPoint("TOPLEFT", btn.icon, "TOPRIGHT", 6, -1)
            btn.text:SetPoint("RIGHT", btn, "RIGHT", -5, 0)
            btn.text:SetJustifyH("LEFT")
            btn.text:SetWordWrap(false)

            btn.infoText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            btn.infoText:SetPoint("BOTTOMLEFT", btn.icon, "BOTTOMRIGHT", 6, 0)
            btn.infoText:SetJustifyH("LEFT")
            btn.infoText:SetTextColor(0.7, 0.7, 0.7)

            Utils:CreatePriceColumns(btn)

            btn.separator = btn:CreateTexture(nil, "BORDER")
            btn.separator:SetHeight(1)
            btn.separator:SetPoint("BOTTOMLEFT", btn, "BOTTOMLEFT", 2, -1)
            btn.separator:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -2, -1)
            btn.separator:SetColorTexture(0.3, 0.3, 0.3, 0.4)
        end

        if elementData.isHeader then
            -- Section header row
            btn.bg:SetColorTexture(0.2, 0.15, 0.05, 0.7)
            btn.icon:Hide()
            btn.text:ClearAllPoints()
            btn.text:SetPoint("LEFT", btn, "LEFT", 8, 0)
            btn.text:SetPoint("RIGHT", btn, "RIGHT", -5, 0)
            btn.text:SetText(elementData.headerText)
            btn.text:SetTextColor(1, 0.82, 0, 1)
            btn.infoText:SetText("")
            btn.goldCol:SetText("")
            btn.silverCol:SetText("")
            btn.copperCol:SetText("")
            btn:SetScript("OnEnter", nil)
            btn:SetScript("OnLeave", nil)
            btn:SetScript("OnClick", nil)
            btn:Disable()
        else
            -- Item row
            btn.bg:SetColorTexture(0.1, 0.1, 0.1, 0.5)
            btn.icon:Show()
            btn.icon:SetTexture(elementData.icon)

            btn.text:ClearAllPoints()
            btn.text:SetPoint("TOPLEFT", btn.icon, "TOPRIGHT", 8, -2)
            btn.text:SetPoint("RIGHT", btn, "RIGHT", -5, 0)
            btn.text:SetText(elementData.link)

            -- Show ilvl (left) and price columns (right-aligned)
            if elementData.itemLevel then
                btn.infoText:SetText(L.FILTER_ILVL_SHORT .. elementData.itemLevel)
            else
                btn.infoText:SetText("")
            end

            if elementData.sellPrice and elementData.sellPrice > 0 then
                Utils:SetPriceColumns(btn, elementData.sellPrice)
            else
                btn.goldCol:SetText("")
                btn.silverCol:SetText("")
                btn.copperCol:SetText("")
            end

            btn.itemBag = elementData.bag
            btn.itemSlot = elementData.slot
            btn.itemLink = elementData.link
            btn.itemName = elementData.name
            btn.itemID = elementData.itemID

            btn:Enable()
            btn:RegisterForClicks("LeftButtonUp")

            btn:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetBagItem(self.itemBag, self.itemSlot)
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine(L.FILTERED_SELECT_HINT, 0.7, 0.7, 0.7)
                GameTooltip:Show()
            end)
            btn:SetScript("OnLeave", GameTooltip_Hide)

            btn:SetScript("OnClick", function(self, button)
                if InCombatLockdown() then return end
                if button == "LeftButton" then
                    -- Insert item at position 1 of disenchant list
                    local mainList = addon.ItemList:GetList()
                    table.insert(mainList, 1, {
                        bag = self.itemBag,
                        slot = self.itemSlot,
                        link = self.itemLink,
                        name = self.itemName,
                        icon = elementData.icon,
                        quality = elementData.quality,
                        itemID = self.itemID,
                        itemLevel = elementData.itemLevel,
                        sellPrice = elementData.sellPrice,
                    })
                    addon.ItemList:UpdateDisenchantButton()
                    -- Re-scan to rebuild both lists
                    addon.ItemList:ScanBags()
                end
            end)
        end
    end)

    ScrollUtil.InitScrollBoxListWithScrollBar(scrollBox, scrollBar, view)

    -- Dock to MainFrame (or BlacklistFrame if shown)
    frame:HookScript("OnShow", function(self)
        local mainFrame = addon.MainFrame:GetFrame()
        if mainFrame and mainFrame:IsShown() then
            if addon.BlacklistFrame:IsShown() then
                local blFrame = addon.BlacklistFrame:GetFrame()
                if blFrame then
                    self:ClearAllPoints()
                    self:SetPoint("TOPLEFT", blFrame, "TOPRIGHT", 5, 0)
                    return
                end
            end
            self:ClearAllPoints()
            self:SetPoint("TOPLEFT", mainFrame, "TOPRIGHT", 5, 0)
        end
    end)

    -- Handle async item info loading
    frame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
    frame:SetScript("OnEvent", function(self, event)
        if event == "GET_ITEM_INFO_RECEIVED" and self:IsShown() and not pendingRefresh then
            pendingRefresh = true
            C_Timer.After(0.1, function()
                pendingRefresh = false
                if frame and frame:IsShown() then
                    FilteredItemsFrame:Refresh()
                end
            end)
        end
    end)

    frame:Hide()
    return frame
end

function FilteredItemsFrame:Refresh()
    local L = addon.currentLocale
    local filtered = addon.ItemList:GetFilteredItems()

    local dataProvider = CreateDataProvider()
    local totalCount = 0

    -- Group: Over Item Level
    if #filtered.overIlvl > 0 then
        dataProvider:Insert({
            isHeader = true,
            headerText = L.FILTERED_OVER_ILVL .. " (" .. #filtered.overIlvl .. ")",
        })
        for _, item in ipairs(filtered.overIlvl) do
            dataProvider:Insert(item)
            totalCount = totalCount + 1
        end
    end

    -- Group: Over Gold Limit
    if #filtered.overGold > 0 then
        dataProvider:Insert({
            isHeader = true,
            headerText = L.FILTERED_OVER_GOLD .. " (" .. #filtered.overGold .. ")",
        })
        for _, item in ipairs(filtered.overGold) do
            dataProvider:Insert(item)
            totalCount = totalCount + 1
        end
    end

    scrollBox:SetDataProvider(dataProvider)
    countText:SetText(string.format(L.FILTERED_COUNT, totalCount))
end

function FilteredItemsFrame:Toggle()
    if InCombatLockdown() then
        addon.Utils:Print(addon.currentLocale.COMBAT_WARNING)
        return
    end
    if not frame then self:Create() end
    if frame:IsShown() then
        frame:Hide()
    else
        self:Refresh()
        frame:Show()
    end
end

function FilteredItemsFrame:IsShown()
    return frame and frame:IsShown()
end

function FilteredItemsFrame:Show()
    if InCombatLockdown() then
        addon.Utils:Print(addon.currentLocale.COMBAT_WARNING)
        return
    end
    if not frame then self:Create() end
    self:Refresh()
    frame:Show()
end

function FilteredItemsFrame:Hide()
    if InCombatLockdown() then return end
    if frame then frame:Hide() end
end

function FilteredItemsFrame:GetFrame()
    return frame
end
