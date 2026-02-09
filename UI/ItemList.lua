-- SimpleDisenchant Item List
local addonName, addon = ...

local C = addon.Constants
local Utils = addon.Utils
local FilterButtons = addon.FilterButtons
local Blacklist = addon.Blacklist

addon.ItemList = {}
local ItemList = addon.ItemList

-- List of disenchantable items
local disenchantList = {}

-- UI elements
local scrollFrame, scrollChild
local itemButtons = {}
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

    -- Disenchant button (SecureActionButton)
    deButton = CreateFrame("Button", "SimpleDisenchantButton", parent, "SecureActionButtonTemplate")
    deButton:SetSize(230, 40)
    deButton:SetPoint("LEFT", iconFrame, "RIGHT", 10, 0)
    deButton:RegisterForClicks("LeftButtonUp", "LeftButtonDown")

    -- Button textures
    deButton.ntex = deButton:CreateTexture()
    deButton.ntex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
    deButton.ntex:SetTexCoord(0, 0.625, 0, 0.6875)
    deButton.ntex:SetAllPoints()
    deButton:SetNormalTexture(deButton.ntex)

    deButton.htex = deButton:CreateTexture()
    deButton.htex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
    deButton.htex:SetTexCoord(0, 0.625, 0, 0.6875)
    deButton.htex:SetAllPoints()
    deButton:SetHighlightTexture(deButton.htex)

    deButton.ptex = deButton:CreateTexture()
    deButton.ptex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
    deButton.ptex:SetTexCoord(0, 0.625, 0, 0.6875)
    deButton.ptex:SetAllPoints()
    deButton:SetPushedTexture(deButton.ptex)

    -- Button text
    deButton.text = deButton:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    deButton.text:SetAllPoints(deButton)
    deButton.text:SetText(L.DISENCHANT)

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

function ItemList:CreateScrollFrame(parent)
    scrollFrame = CreateFrame("ScrollFrame", nil, parent, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 10, -160)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

    scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetSize(260, 1)
    scrollFrame:SetScrollChild(scrollChild)

    return scrollFrame
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
        deButton:SetAlpha(1)

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
        deButton:SetAlpha(0.5)
        iconFrame:Hide()
    end
end

function ItemList:ScanBags()
    local L = addon.currentLocale

    -- Clear list
    wipe(disenchantList)

    -- Hide old buttons
    for _, btn in ipairs(itemButtons) do
        btn:Hide()
    end

    local yOffset = 0
    local count = 0

    for bag = 0, 4 do
        local numSlots = C_Container.GetContainerNumSlots(bag)
        for slot = 1, numSlots do
            local info = C_Container.GetContainerItemInfo(bag, slot)
            if info and info.hyperlink then
                local itemName, _, quality = C_Item.GetItemInfo(info.hyperlink)
                local _, _, _, _, _, classID = C_Item.GetItemInfoInstant(info.hyperlink)

                -- Armor or Weapon, green+ quality, filter active, and not blacklisted
                local isBlacklisted = Blacklist and Blacklist:IsBlacklisted(info.itemID)
                if C.DISENCHANTABLE_CLASSES[classID] and quality and quality >= C.MIN_DISENCHANT_QUALITY and FilterButtons:IsQualityEnabled(quality) and not isBlacklisted then
                    count = count + 1

                    -- Add to list
                    table.insert(disenchantList, {
                        bag = bag,
                        slot = slot,
                        link = info.hyperlink,
                        name = itemName,
                        icon = info.iconFileID,
                        quality = quality,
                        itemID = info.itemID
                    })

                    local btn = itemButtons[count]
                    if not btn then
                        btn = CreateFrame("Button", nil, scrollChild)
                        btn:SetSize(260, 36)

                        -- Background
                        btn.bg = btn:CreateTexture(nil, "BACKGROUND")
                        btn.bg:SetAllPoints()
                        btn.bg:SetColorTexture(0.1, 0.1, 0.1, 0.5)

                        -- Highlight
                        btn:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")

                        -- Icon
                        btn.icon = btn:CreateTexture(nil, "ARTWORK")
                        btn.icon:SetSize(32, 32)
                        btn.icon:SetPoint("LEFT", btn, "LEFT", 2, 0)

                        -- Item name
                        btn.text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                        btn.text:SetPoint("LEFT", btn.icon, "RIGHT", 8, 0)
                        btn.text:SetPoint("RIGHT", btn, "RIGHT", -5, 0)
                        btn.text:SetJustifyH("LEFT")
                        btn.text:SetWordWrap(false)

                        itemButtons[count] = btn
                    end

                    -- Configure button
                    btn.icon:SetTexture(info.iconFileID)
                    btn.text:SetText(info.hyperlink)
                    btn:SetPoint("TOPLEFT", 0, -yOffset)
                    btn:Show()

                    -- Store data
                    btn.itemBag = bag
                    btn.itemSlot = slot
                    btn.itemID = info.itemID
                    btn.itemName = itemName

                    btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")

                    btn:SetScript("OnEnter", function(self)
                        local L = addon.currentLocale
                        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                        GameTooltip:SetBagItem(self.itemBag, self.itemSlot)
                        GameTooltip:AddLine(" ")
                        GameTooltip:AddLine(L.BLACKLIST_HINT or "Right-click to blacklist", 0.7, 0.7, 0.7)
                        GameTooltip:Show()
                    end)
                    btn:SetScript("OnLeave", GameTooltip_Hide)

                    -- Left-click to select, Right-click to blacklist
                    btn:SetScript("OnClick", function(self, button)
                        if InCombatLockdown() then return end

                        if button == "RightButton" then
                            -- Blacklist item
                            if Blacklist and self.itemID then
                                Blacklist:Add(self.itemID, self.itemName)
                                ItemList:ScanBags()
                            end
                        else
                            -- Select item as next to disenchant
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

                    yOffset = yOffset + C.ITEM_ROW_HEIGHT
                end
            end
        end
    end

    scrollChild:SetHeight(math.max(yOffset, 1))
    countText:SetText(string.format(L.ITEMS_COUNT, count))

    -- Update disenchant button
    self:UpdateDisenchantButton()
end

function ItemList:Initialize(parent)
    self:CreateIconFrame(parent)
    self:CreateDisenchantButton(parent)
    self:CreateCountText(parent)
    self:CreateScrollFrame(parent)

    -- Set filter callback
    FilterButtons:SetCallback(function()
        self:ScanBags()
    end)
end
