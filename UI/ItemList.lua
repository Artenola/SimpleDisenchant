-- SimpleDisenchant Item List
local addonName, addon = ...

local C = addon.Constants
local Utils = addon.Utils
local FilterPanel = addon.FilterPanel
local Blacklist = addon.Blacklist

addon.ItemList = {}
local ItemList = addon.ItemList

-- List of disenchantable items
local disenchantList = {}

-- Filtered-out items (by ilvl/gold/equipment set filters)
local filteredItems = {
    overIlvl = {},
    overGold = {},
    equipmentSet = {},
}

-- UI elements
local scrollBox, scrollBar
local countText
local iconFrame, nextItemIcon, nextItemBorder
local deButton

-- Callback when item is selected
local onItemSelected = nil

function ItemList:SetCallback(callback)
    onItemSelected = callback
end

function ItemList:GetList()
    return disenchantList
end

function ItemList:GetFirstItem()
    return disenchantList[1]
end

function ItemList:GetFilteredItems()
    return filteredItems
end

function ItemList:CreateIconFrame(parent)
    -- Container for item icon
    iconFrame = CreateFrame("Frame", nil, parent)
    iconFrame:SetSize(44, 44)
    iconFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, -60)
    iconFrame:EnableMouse(true)

    -- Tooltip on hover
    iconFrame:SetScript("OnEnter", function(self)
        if #disenchantList > 0 then
            local firstItem = disenchantList[1]
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetBagItem(firstItem.bag, firstItem.slot)
            GameTooltip:Show()
        end
    end)
    iconFrame:SetScript("OnLeave", GameTooltip_Hide)

    -- Icon texture
    nextItemIcon = iconFrame:CreateTexture(nil, "ARTWORK")
    nextItemIcon:SetAllPoints()

    -- Border
    nextItemBorder = iconFrame:CreateTexture(nil, "OVERLAY")
    nextItemBorder:SetPoint("TOPLEFT", iconFrame, "TOPLEFT", -2, 2)
    nextItemBorder:SetPoint("BOTTOMRIGHT", iconFrame, "BOTTOMRIGHT", 2, -2)
    nextItemBorder:SetTexture("Interface\\Common\\WhiteIconFrame")
    nextItemBorder:SetVertexColor(1, 1, 1, 1)

    return iconFrame
end

function ItemList:CreateDisenchantButton(parent)
    local L = addon.currentLocale

    -- Custom button texture path (1024x64 strip: Normal | Hover | Pushed | Disabled)
    local BTN_TEXTURE = "Interface\\AddOns\\SimpleDisenchant\\media\\DeButton"

    -- TexCoords for each state in the horizontal strip
    local COORDS_NORMAL   = { 0,    0.25, 0, 1 }
    local COORDS_HIGHLIGHT = { 0.25, 0.5,  0, 1 }
    local COORDS_PUSHED   = { 0.5,  0.75, 0, 1 }
    local COORDS_DISABLED = { 0.75, 1,    0, 1 }

    -- Disenchant button (SecureActionButton for macro execution)
    deButton = CreateFrame("Button", "SimpleDisenchantButton", parent, "SecureActionButtonTemplate")
    deButton:SetSize(230, 40)
    deButton:SetPoint("LEFT", iconFrame, "RIGHT", 10, 0)
    deButton:RegisterForClicks("LeftButtonUp", "LeftButtonDown")

    -- Background texture (shows current state)
    deButton.bg = deButton:CreateTexture(nil, "BACKGROUND")
    deButton.bg:SetAllPoints()
    deButton.bg:SetTexture(BTN_TEXTURE)
    deButton.bg:SetTexCoord(unpack(COORDS_NORMAL))

    -- Highlight overlay (hover state, blended on top)
    local htex = deButton:CreateTexture(nil, "HIGHLIGHT")
    htex:SetAllPoints()
    htex:SetTexture(BTN_TEXTURE)
    htex:SetTexCoord(unpack(COORDS_HIGHLIGHT))
    htex:SetBlendMode("ADD")
    deButton:SetHighlightTexture(htex)

    -- Button text
    deButton.text = deButton:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    deButton.text:SetPoint("CENTER")
    deButton.text:SetText(L.DISENCHANT)

    -- State scripts (swap TexCoords on the background texture)
    deButton:HookScript("OnMouseDown", function(self)
        if self:IsEnabled() then
            self.bg:SetTexCoord(unpack(COORDS_PUSHED))
        end
    end)

    deButton:HookScript("OnMouseUp", function(self)
        if self:IsEnabled() then
            self.bg:SetTexCoord(unpack(COORDS_NORMAL))
        end
    end)

    deButton:HookScript("OnShow", function(self)
        if self:IsEnabled() then
            self.bg:SetTexCoord(unpack(COORDS_NORMAL))
        else
            self.bg:SetTexCoord(unpack(COORDS_DISABLED))
        end
    end)

    deButton:HookScript("OnEnable", function(self)
        self.bg:SetTexCoord(unpack(COORDS_NORMAL))
        self.text:SetFontObject("GameFontNormalLarge")
    end)

    deButton:HookScript("OnDisable", function(self)
        self.bg:SetTexCoord(unpack(COORDS_DISABLED))
        self.text:SetFontObject("GameFontDisableLarge")
    end)

    -- Configure as macro
    deButton:SetAttribute("type", "macro")

    -- Refresh after click
    deButton:HookScript("OnClick", function()
        C_Timer.After(2, function()
            if addon.MainFrame:IsShown() and not InCombatLockdown() then
                ItemList:ScanBags()
            end
        end)
    end)

    return deButton
end

function ItemList:CreateCountText(parent)
    countText = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    countText:SetPoint("TOP", parent, "TOP", 0, -140)
    countText:SetText("0 objet(s)")
    return countText
end

function ItemList:CreateScrollList(parent)
    -- Container for the scroll list (matches Blizzard recipe list style)
    local listContainer = CreateFrame("Frame", nil, parent)
    listContainer:SetPoint("TOPLEFT", 7, -155)
    listContainer:SetPoint("BOTTOMRIGHT", -7, 5)

    -- Dark background (same atlas as Blizzard recipe list)
    listContainer.bg = listContainer:CreateTexture(nil, "BACKGROUND")
    listContainer.bg:SetAllPoints()
    listContainer.bg:SetAtlas("Professions-background-summarylist")

    -- Inset border (NineSlice frame)
    local inset = CreateFrame("Frame", nil, listContainer, "NineSlicePanelTemplate")
    inset:SetAllPoints()
    NineSliceUtil.ApplyLayoutByName(inset, "InsetFrameTemplate")

    -- Modern ScrollBox (inside the container)
    scrollBox = CreateFrame("Frame", nil, listContainer, "WowScrollBoxList")
    scrollBox:SetPoint("TOPLEFT", listContainer, "TOPLEFT", 6, -3)
    scrollBox:SetPoint("BOTTOMRIGHT", listContainer, "BOTTOMRIGHT", -20, 5)

    -- Modern MinimalScrollBar
    scrollBar = CreateFrame("EventFrame", nil, listContainer, "MinimalScrollBar")
    scrollBar:SetPoint("TOPLEFT", scrollBox, "TOPRIGHT", 0, 0)
    scrollBar:SetPoint("BOTTOMLEFT", scrollBox, "BOTTOMRIGHT", 0, 0)

    -- Create linear view
    local view = CreateScrollBoxListLinearView()
    view:SetElementExtent(C.ITEM_ROW_HEIGHT)

    -- Element initializer: configure each row when it becomes visible
    view:SetElementInitializer("Button", function(btn, elementData)
        btn:SetSize(scrollBox:GetWidth(), C.ITEM_ROW_HEIGHT - 2)

        -- Background (create once)
        if not btn.bg then
            btn.bg = btn:CreateTexture(nil, "BACKGROUND")
            btn.bg:SetAllPoints()
            btn.bg:SetColorTexture(0.1, 0.1, 0.1, 0.5)

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

        -- Configure with item data
        btn.icon:SetTexture(elementData.icon)
        btn.text:SetText(elementData.link)

        -- Show ilvl (left) and price columns (right-aligned)
        local L = addon.currentLocale
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
        btn.itemID = elementData.itemID
        btn.itemName = elementData.name
        btn.itemLink = elementData.link

        btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")

        btn:SetScript("OnEnter", function(self)
            local LL = addon.currentLocale
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetBagItem(self.itemBag, self.itemSlot)
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(LL.BLACKLIST_HINT or "Right-click to blacklist", 0.7, 0.7, 0.7)
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", GameTooltip_Hide)

        btn:SetScript("OnClick", function(self, button)
            if InCombatLockdown() then return end

            if button == "RightButton" then
                if Blacklist and self.itemLink then
                    Blacklist:Add(self.itemLink, self.itemName, self.itemID)
                    ItemList:ScanBags()
                end
            else
                for i, item in ipairs(disenchantList) do
                    if item.bag == self.itemBag and item.slot == self.itemSlot then
                        table.remove(disenchantList, i)
                        table.insert(disenchantList, 1, item)
                        break
                    end
                end
                ItemList:UpdateDisenchantButton()
            end
        end)
    end)

    ScrollUtil.InitScrollBoxListWithScrollBar(scrollBox, scrollBar, view)
end

function ItemList:UpdateDisenchantButton()
    if InCombatLockdown() then return end

    local L = addon.currentLocale

    if #disenchantList > 0 then
        local firstItem = disenchantList[1]
        local macroText = "/cast " .. L.DISENCHANT_SPELL .. "\n/use " .. firstItem.bag .. " " .. firstItem.slot
        deButton:SetAttribute("macrotext", macroText)
        deButton.text:SetText(L.DISENCHANT)
        deButton:Enable()

        -- Update icon
        nextItemIcon:SetTexture(firstItem.icon)
        iconFrame:Show()

        -- Border color by quality
        local color = Utils:GetQualityColor(firstItem.quality)
        nextItemBorder:SetVertexColor(color[1], color[2], color[3], 1)
    else
        deButton:SetAttribute("macrotext", "")
        deButton.text:SetText(L.NO_ITEM)
        deButton:Disable()
        iconFrame:Hide()
    end
end

function ItemList:ScanBags()
    local L = addon.currentLocale

    -- Clear lists
    wipe(disenchantList)
    wipe(filteredItems.overIlvl)
    wipe(filteredItems.overGold)
    wipe(filteredItems.equipmentSet)

    local count = 0

    -- Build equipment set lookup table: equipSetLookup[bag][slot] = setName
    local equipSetLookup = {}
    local hideEquipSets = SimpleDisenchantDB and SimpleDisenchantDB.filters and SimpleDisenchantDB.filters.hideEquipmentSets
    if hideEquipSets then
        local setIDs = C_EquipmentSet.GetEquipmentSetIDs()
        for _, setID in ipairs(setIDs) do
            local name = C_EquipmentSet.GetEquipmentSetInfo(setID)
            local locations = C_EquipmentSet.GetItemLocations(setID)
            for _, location in pairs(locations) do
                if location and location > 0 then
                    local locData = EquipmentManager_GetLocationData(location)
                    if locData and locData.isBags and locData.bag and locData.slot then
                        equipSetLookup[locData.bag] = equipSetLookup[locData.bag] or {}
                        equipSetLookup[locData.bag][locData.slot] = name
                    end
                end
            end
        end
    end

    -- Get search text for name filtering
    local searchText = FilterPanel:GetSearchText()
    local hasSearch = searchText and searchText ~= ""
    if hasSearch then
        searchText = searchText:lower()
    end

    for bag = 0, 4 do
        local numSlots = C_Container.GetContainerNumSlots(bag)
        for slot = 1, numSlots do
            local info = C_Container.GetContainerItemInfo(bag, slot)
            if info and info.hyperlink then
                local itemName, _, quality, itemLevel, _, _, _, _, _, _, sellPrice, _, _, bindType = C_Item.GetItemInfo(info.hyperlink)
                local _, _, _, _, _, classID = C_Item.GetItemInfoInstant(info.hyperlink)

                -- Armor or Weapon, green+ quality, quality filter active, and not blacklisted
                local isBlacklisted = Blacklist and Blacklist:IsBlacklisted(info.hyperlink)
                if C.DISENCHANTABLE_CLASSES[classID] and quality and quality >= C.MIN_DISENCHANT_QUALITY and FilterPanel:IsQualityEnabled(quality) and FilterPanel:IsBindingTypeEnabled(bindType) and not isBlacklisted then

                    -- Search filter: skip items that don't match search text
                    local matchesSearch = true
                    if hasSearch then
                        matchesSearch = itemName and itemName:lower():find(searchText, 1, true) ~= nil
                    end

                    if matchesSearch then
                        local itemData = {
                            bag = bag,
                            slot = slot,
                            link = info.hyperlink,
                            name = itemName,
                            icon = info.iconFileID,
                            quality = quality,
                            itemID = info.itemID,
                            itemLevel = itemLevel,
                            sellPrice = sellPrice or 0,
                        }

                        -- Check equipment set filter
                        local inEquipSet = equipSetLookup[bag] and equipSetLookup[bag][slot]
                        if inEquipSet then
                            itemData.equipmentSetName = inEquipSet
                            table.insert(filteredItems.equipmentSet, itemData)
                        else
                            -- Check ilvl/gold filters
                            local passesIlvl, passesGold = FilterPanel:CheckItemFilters(itemLevel, sellPrice)

                            if passesIlvl and passesGold then
                                count = count + 1
                                table.insert(disenchantList, itemData)
                            else
                                -- Add to filtered-out lists (item can appear in both)
                                if not passesIlvl then
                                    table.insert(filteredItems.overIlvl, itemData)
                                end
                                if not passesGold then
                                    table.insert(filteredItems.overGold, itemData)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- Update ScrollBox with new data
    local dataProvider = CreateDataProvider()
    for _, item in ipairs(disenchantList) do
        dataProvider:Insert(item)
    end
    scrollBox:SetDataProvider(dataProvider)

    countText:SetText(string.format(L.ITEMS_COUNT, count))

    -- Update disenchant button
    self:UpdateDisenchantButton()

    -- Refresh filtered items frame if open
    if addon.FilteredItemsFrame and addon.FilteredItemsFrame:IsShown() then
        addon.FilteredItemsFrame:Refresh()
    end
end

function ItemList:RefreshDisplay()
    local L = addon.currentLocale
    local dataProvider = CreateDataProvider()
    for _, item in ipairs(disenchantList) do
        dataProvider:Insert(item)
    end
    scrollBox:SetDataProvider(dataProvider)
    countText:SetText(string.format(L.ITEMS_COUNT, #disenchantList))
    self:UpdateDisenchantButton()
end

function ItemList:Initialize(parent)
    self:CreateIconFrame(parent)
    self:CreateDisenchantButton(parent)
    self:CreateCountText(parent)
    self:CreateScrollList(parent)

    -- Set filter callback
    FilterPanel:SetCallback(function()
        self:ScanBags()
    end)

    -- Re-scan when equipment sets change (created, deleted, modified)
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("EQUIPMENT_SETS_CHANGED")
    eventFrame:SetScript("OnEvent", function()
        if addon.MainFrame:IsShown() and not InCombatLockdown() then
            self:ScanBags()
        end
    end)
end
