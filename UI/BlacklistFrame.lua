-- SimpleDisenchant Blacklist Frame
local addonName, addon = ...

local C = addon.Constants

addon.BlacklistFrame = {}
local BlacklistFrame = addon.BlacklistFrame

local frame
local scrollBox, scrollBar
local countText

function BlacklistFrame:Create()
    if frame then return frame end

    local L = addon.currentLocale

    -- Create main frame
    frame = CreateFrame("Frame", "SimpleDisenchantBlacklistFrame", UIParent, "PortraitFrameTemplate")
    frame:SetSize(300, 400)
    frame:SetPoint("CENTER", 350, 0)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetFrameStrata("HIGH")

    -- Title
    frame:SetTitle(L.BLACKLIST_TITLE or "Blacklist")

    -- Portrait
    frame:SetPortraitToAsset("Interface\\Icons\\INV_Enchant_Disenchant")

    -- Close with Escape
    table.insert(UISpecialFrames, "SimpleDisenchantBlacklistFrame")

    -- Count text
    countText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    countText:SetPoint("TOP", frame, "TOP", 0, -60)
    countText:SetText("0 item(s)")

    -- Clear button
    local clearBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    clearBtn:SetSize(80, 22)
    clearBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -55)
    clearBtn:SetText(L.BLACKLIST_CLEAR_BTN or "Clear All")
    clearBtn:SetScript("OnClick", function()
        addon.Blacklist:Clear()
        BlacklistFrame:Refresh()
        if addon.MainFrame:IsShown() then
            addon.ItemList:ScanBags()
        end
    end)

    -- Inset background behind the scroll list
    local inset = CreateFrame("Frame", nil, frame, "InsetFrameTemplate")
    inset:SetPoint("TOPLEFT", 7, -80)
    inset:SetPoint("BOTTOMRIGHT", -7, 5)

    -- Modern ScrollBox (inside the inset)
    scrollBox = CreateFrame("Frame", nil, frame, "WowScrollBoxList")
    scrollBox:SetPoint("TOPLEFT", inset, "TOPLEFT", 3, -3)
    scrollBox:SetPoint("BOTTOMRIGHT", inset, "BOTTOMRIGHT", -3, 3)

    -- Modern MinimalScrollBar
    scrollBar = CreateFrame("EventFrame", nil, frame, "MinimalScrollBar")
    scrollBar:SetPoint("TOPLEFT", scrollBox, "TOPRIGHT", 4, 0)
    scrollBar:SetPoint("BOTTOMLEFT", scrollBox, "BOTTOMRIGHT", 4, 0)

    -- Create linear view
    local view = CreateScrollBoxListLinearView()
    view:SetElementExtent(32)

    -- Element initializer
    view:SetElementInitializer("Button", function(btn, elementData)
        btn:SetSize(scrollBox:GetWidth(), 30)

        -- Create UI elements once
        if not btn.bg then
            btn.bg = btn:CreateTexture(nil, "BACKGROUND")
            btn.bg:SetAllPoints()
            btn.bg:SetColorTexture(0.1, 0.1, 0.1, 0.5)

            btn:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")

            btn.icon = btn:CreateTexture(nil, "ARTWORK")
            btn.icon:SetSize(24, 24)
            btn.icon:SetPoint("LEFT", btn, "LEFT", 4, 0)

            btn.text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            btn.text:SetPoint("LEFT", btn.icon, "RIGHT", 8, 0)
            btn.text:SetPoint("RIGHT", btn, "RIGHT", -5, 0)
            btn.text:SetJustifyH("LEFT")
            btn.text:SetWordWrap(false)
        end

        -- Get item info
        local itemName, _, quality, _, _, _, _, _, _, itemTexture
        if elementData.link then
            itemName, _, quality, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(elementData.link)
        elseif elementData.itemID then
            itemName, _, quality, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(elementData.itemID)
        end

        btn.icon:SetTexture(itemTexture or "Interface\\Icons\\INV_Misc_QuestionMark")
        btn.text:SetText(itemName or elementData.name or ("Item " .. (elementData.itemID or "?")))

        -- Color by quality
        if quality then
            local color = ITEM_QUALITY_COLORS[quality]
            if color then
                btn.text:SetTextColor(color.r, color.g, color.b)
            end
        else
            btn.text:SetTextColor(1, 1, 1)
        end

        -- Store data
        btn.itemKey = elementData.itemKey
        btn.itemID = elementData.itemID
        btn.itemLink = elementData.link
        btn.itemName = itemName or elementData.name

        btn:RegisterForClicks("RightButtonUp")

        btn:SetScript("OnEnter", function(self)
            local L = addon.currentLocale
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            if self.itemLink then
                GameTooltip:SetHyperlink(self.itemLink)
            elseif self.itemID then
                GameTooltip:SetItemByID(self.itemID)
            end
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(L.BLACKLIST_REMOVE_HINT or "Right-click to remove", 0.7, 0.7, 0.7)
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", GameTooltip_Hide)

        btn:SetScript("OnClick", function(self, button)
            if button == "RightButton" then
                addon.Blacklist:Remove(self.itemKey)
                BlacklistFrame:Refresh()
                if addon.MainFrame:IsShown() then
                    addon.ItemList:ScanBags()
                end
            end
        end)
    end)

    ScrollUtil.InitScrollBoxListWithScrollBar(scrollBox, scrollBar, view)

    -- Dock to MainFrame when shown
    frame:HookScript("OnShow", function(self)
        local mainFrame = addon.MainFrame:GetFrame()
        if mainFrame and mainFrame:IsShown() then
            self:ClearAllPoints()
            self:SetPoint("TOPLEFT", mainFrame, "TOPRIGHT", 5, 0)
        end
    end)

    frame:Hide()
    return frame
end

function BlacklistFrame:Refresh()
    local L = addon.currentLocale
    local Blacklist = addon.Blacklist

    local blacklist = Blacklist:GetAll()
    local count = 0

    local dataProvider = CreateDataProvider()
    for itemKey, data in pairs(blacklist) do
        count = count + 1
        dataProvider:Insert({
            itemKey = itemKey,
            itemID = data.itemID,
            link = data.link,
            name = data.name,
        })
    end

    scrollBox:SetDataProvider(dataProvider)
    countText:SetText(string.format(L.BLACKLIST_COUNT or "%d item(s) blacklisted", count))
end

function BlacklistFrame:Toggle()
    if not frame then
        self:Create()
    end

    if frame:IsShown() then
        frame:Hide()
    else
        self:Refresh()
        frame:Show()
    end
end

function BlacklistFrame:IsShown()
    return frame and frame:IsShown()
end

function BlacklistFrame:Show()
    if not frame then
        self:Create()
    end
    self:Refresh()
    frame:Show()
end

function BlacklistFrame:Hide()
    if frame then
        frame:Hide()
    end
end
