-- SimpleDisenchant Blacklist Frame
local addonName, addon = ...

local C = addon.Constants

addon.BlacklistFrame = {}
local BlacklistFrame = addon.BlacklistFrame

local frame
local scrollFrame, scrollChild
local itemButtons = {}
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

    -- Scroll frame
    scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 10, -85)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

    scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetSize(240, 1)
    scrollFrame:SetScrollChild(scrollChild)

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

    -- Hide old buttons
    for _, btn in ipairs(itemButtons) do
        btn:Hide()
    end

    local blacklist = Blacklist:GetAll()
    local yOffset = 0
    local count = 0

    for itemID, data in pairs(blacklist) do
        count = count + 1

        local btn = itemButtons[count]
        if not btn then
            btn = CreateFrame("Button", nil, scrollChild)
            btn:SetSize(240, 30)

            -- Background
            btn.bg = btn:CreateTexture(nil, "BACKGROUND")
            btn.bg:SetAllPoints()
            btn.bg:SetColorTexture(0.1, 0.1, 0.1, 0.5)

            -- Highlight
            btn:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")

            -- Icon
            btn.icon = btn:CreateTexture(nil, "ARTWORK")
            btn.icon:SetSize(24, 24)
            btn.icon:SetPoint("LEFT", btn, "LEFT", 4, 0)

            -- Item name
            btn.text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            btn.text:SetPoint("LEFT", btn.icon, "RIGHT", 8, 0)
            btn.text:SetPoint("RIGHT", btn, "RIGHT", -5, 0)
            btn.text:SetJustifyH("LEFT")
            btn.text:SetWordWrap(false)

            itemButtons[count] = btn
        end

        -- Get item info
        local itemName, _, quality, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(itemID)

        btn.icon:SetTexture(itemTexture or "Interface\\Icons\\INV_Misc_QuestionMark")
        btn.text:SetText(itemName or data.name or ("Item " .. itemID))

        -- Color by quality
        if quality then
            local color = ITEM_QUALITY_COLORS[quality]
            if color then
                btn.text:SetTextColor(color.r, color.g, color.b)
            end
        else
            btn.text:SetTextColor(1, 1, 1)
        end

        btn:SetPoint("TOPLEFT", 0, -yOffset)
        btn:Show()

        -- Store itemID
        btn.itemID = itemID
        btn.itemName = itemName or data.name

        btn:RegisterForClicks("RightButtonUp")

        btn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetItemByID(self.itemID)
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(L.BLACKLIST_REMOVE_HINT or "Right-click to remove", 0.7, 0.7, 0.7)
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", GameTooltip_Hide)

        btn:SetScript("OnClick", function(self, button)
            if button == "RightButton" then
                Blacklist:Remove(self.itemID)
                BlacklistFrame:Refresh()
                if addon.MainFrame:IsShown() then
                    addon.ItemList:ScanBags()
                end
            end
        end)

        yOffset = yOffset + 32
    end

    scrollChild:SetHeight(math.max(yOffset, 1))
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
