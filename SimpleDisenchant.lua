-- SimpleDisenchant: Displays disenchantable items
local addonName, addon = ...

-- Localization
local L = {}
local locale = GetLocale()

-- Default (English US/GB)
L["enUS"] = {
    TITLE = "Simple Disenchant",
    DISENCHANT = "Disenchant",
    DISENCHANT_SPELL = "Disenchant",
    NO_ITEM = "No item",
    ITEMS_COUNT = "%d item(s) to disenchant",
    QUALITY_GREEN = "Green",
    QUALITY_BLUE = "Blue",
    QUALITY_PURPLE = "Purple",
    LOADED_MSG = "/sde to open",
    DRAG_TO_ACTIONBAR = "Drag to action bar",
}
L["enGB"] = L["enUS"]

-- French
L["frFR"] = {
    TITLE = "Simple Disenchant",
    DISENCHANT = "Désenchanter",
    DISENCHANT_SPELL = "Désenchanter",
    NO_ITEM = "Aucun objet",
    ITEMS_COUNT = "%d objet(s) à désenchanter",
    QUALITY_GREEN = "Vert",
    QUALITY_BLUE = "Bleu",
    QUALITY_PURPLE = "Violet",
    LOADED_MSG = "/sde pour ouvrir",
    DRAG_TO_ACTIONBAR = "Glisser vers la barre d'action",
}

-- German
L["deDE"] = {
    TITLE = "Simple Disenchant",
    DISENCHANT = "Entzaubern",
    DISENCHANT_SPELL = "Entzaubern",
    NO_ITEM = "Kein Gegenstand",
    ITEMS_COUNT = "%d Gegenstand(e) zum Entzaubern",
    QUALITY_GREEN = "Grün",
    QUALITY_BLUE = "Blau",
    QUALITY_PURPLE = "Lila",
    LOADED_MSG = "/sde zum Öffnen",
    DRAG_TO_ACTIONBAR = "Zur Aktionsleiste ziehen",
}

-- Spanish (EU + Latin America)
L["esES"] = {
    TITLE = "Simple Disenchant",
    DISENCHANT = "Desencantar",
    DISENCHANT_SPELL = "Desencantar",
    NO_ITEM = "Sin objeto",
    ITEMS_COUNT = "%d objeto(s) a desencantar",
    QUALITY_GREEN = "Verde",
    QUALITY_BLUE = "Azul",
    QUALITY_PURPLE = "Morado",
    LOADED_MSG = "/sde para abrir",
    DRAG_TO_ACTIONBAR = "Arrastrar a barra de acción",
}
L["esMX"] = L["esES"]

-- Italian
L["itIT"] = {
    TITLE = "Simple Disenchant",
    DISENCHANT = "Disincantare",
    DISENCHANT_SPELL = "Disincanta",
    NO_ITEM = "Nessun oggetto",
    ITEMS_COUNT = "%d oggetto/i da disincantare",
    QUALITY_GREEN = "Verde",
    QUALITY_BLUE = "Blu",
    QUALITY_PURPLE = "Viola",
    LOADED_MSG = "/sde per aprire",
    DRAG_TO_ACTIONBAR = "Trascina sulla barra azioni",
}

-- Russian
L["ruRU"] = {
    TITLE = "Simple Disenchant",
    DISENCHANT = "Распылить",
    DISENCHANT_SPELL = "Распыление",
    NO_ITEM = "Нет предмета",
    ITEMS_COUNT = "%d предмет(ов)",
    QUALITY_GREEN = "Зелён.",
    QUALITY_BLUE = "Синий",
    QUALITY_PURPLE = "Фиол.",
    LOADED_MSG = "/sde открыть",
    DRAG_TO_ACTIONBAR = "Перетащить на панель действий",
}

-- Select locale (fallback to enUS)
local currentL = L[locale] or L["enUS"]

-- Liste des items désenchantables
local disenchantList = {}

-- Couleurs par qualité
local QUALITY_COLORS = {
    [2] = {0.12, 1.00, 0.00},    -- Vert (Uncommon)
    [3] = {0.00, 0.44, 0.87},    -- Bleu (Rare)
    [4] = {0.64, 0.21, 0.93},    -- Violet (Epic)
}

-- Filtres actifs (true = affiché)
local qualityFilters = {
    [2] = true,  -- Vert
    [3] = true,  -- Bleu
    [4] = true,  -- Violet
}

-- Forward declarations
local ScanBags

-- Frame principal avec style Blizzard (PortraitFrameTemplate)
local frame = CreateFrame("Frame", "SimpleDisenchantFrame", UIParent, "PortraitFrameTemplate")
frame:SetSize(320, 450)
frame:SetPoint("CENTER")
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:Hide()

-- Permet de fermer avec Échap
tinsert(UISpecialFrames, "SimpleDisenchantFrame")

-- Configurer le portrait (icône de Désenchanter)
frame:SetPortraitToAsset("Interface\\Icons\\INV_Enchant_Disenchant")

-- Titre
frame:SetTitle(currentL.TITLE)

-- Hook quand SimpleDisenchant s'ouvre
frame:HookScript("OnShow", function(self)
    -- Vérifier si ProfessionsFrame est ouvert
    if ProfessionsFrame and ProfessionsFrame:IsShown() then
        -- Coller à droite de ProfessionsFrame
        self:ClearAllPoints()
        self:SetPoint("TOPLEFT", ProfessionsFrame, "TOPRIGHT", 5, 0)
    end
end)

-- Container pour l'icône de l'item (à côté du bouton DE)
local iconFrame = CreateFrame("Frame", nil, frame)
iconFrame:SetSize(44, 44)
iconFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -60)
iconFrame:EnableMouse(true)

-- Tooltip sur l'icône
iconFrame:SetScript("OnEnter", function(self)
    if #disenchantList > 0 then
        local firstItem = disenchantList[1]
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetBagItem(firstItem.bag, firstItem.slot)
        GameTooltip:Show()
    end
end)
iconFrame:SetScript("OnLeave", GameTooltip_Hide)

-- Icône du prochain objet à DE
local nextItemIcon = iconFrame:CreateTexture(nil, "ARTWORK")
nextItemIcon:SetAllPoints()

-- Bordure de l'icône (style Blizzard)
local nextItemBorder = iconFrame:CreateTexture(nil, "OVERLAY")
nextItemBorder:SetPoint("TOPLEFT", iconFrame, "TOPLEFT", -2, 2)
nextItemBorder:SetPoint("BOTTOMRIGHT", iconFrame, "BOTTOMRIGHT", 2, -2)
nextItemBorder:SetTexture("Interface\\Common\\WhiteIconFrame")
nextItemBorder:SetVertexColor(1, 1, 1, 1)

-- Bouton Désenchanter (SecureActionButton)
local deButton = CreateFrame("Button", "SimpleDisenchantButton", frame, "SecureActionButtonTemplate")
deButton:SetSize(230, 40)
deButton:SetPoint("LEFT", iconFrame, "RIGHT", 10, 0)
deButton:RegisterForClicks("LeftButtonUp", "LeftButtonDown")

-- Style du bouton
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

-- Texte centré dans le bouton
deButton.text = deButton:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
deButton.text:SetAllPoints(deButton)
deButton.text:SetText(currentL.DISENCHANT)

-- Configurer le bouton comme macro
deButton:SetAttribute("type", "macro")

-- Fonction pour créer un bouton de filtre
local function CreateFilterButton(parent, quality, label, xOffset)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(60, 22)
    btn:SetPoint("TOP", parent, "TOP", xOffset, -110)

    local color = QUALITY_COLORS[quality]

    -- Fond intérieur
    btn.inner = btn:CreateTexture(nil, "BACKGROUND")
    btn.inner:SetAllPoints()
    btn.inner:SetColorTexture(0.1, 0.1, 0.1, 0.9)

    -- Texte
    btn.text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    btn.text:SetPoint("CENTER")
    btn.text:SetText(label)
    btn.text:SetTextColor(color[1], color[2], color[3], 1)

    -- Indicateur actif/inactif
    btn.quality = quality

    btn:SetScript("OnClick", function(self)
        qualityFilters[self.quality] = not qualityFilters[self.quality]
        -- Mettre à jour l'apparence
        if qualityFilters[self.quality] then
            self.inner:SetColorTexture(0.1, 0.1, 0.1, 0.9)
            self.text:SetAlpha(1)
        else
            self.inner:SetColorTexture(0.05, 0.05, 0.05, 0.9)
            self.text:SetAlpha(0.4)
        end
        -- Rescanner les sacs
        if not InCombatLockdown() then
            ScanBags()
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

-- Boutons de filtre
local filterGreen = CreateFilterButton(frame, 2, currentL.QUALITY_GREEN, -70)
local filterBlue = CreateFilterButton(frame, 3, currentL.QUALITY_BLUE, 0)
local filterPurple = CreateFilterButton(frame, 4, currentL.QUALITY_PURPLE, 70)

-- Compteur
local countText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
countText:SetPoint("TOP", frame, "TOP", 0, -140)
countText:SetText("0 objet(s)")


-- Conteneur scrollable
local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 10, -160)
scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

local scrollChild = CreateFrame("Frame", nil, scrollFrame)
scrollChild:SetSize(260, 1)
scrollFrame:SetScrollChild(scrollChild)

-- Liste des boutons d'affichage
local itemButtons = {}

-- Fonction pour mettre à jour le bouton DE avec le premier item
local function UpdateDEButton()
    if InCombatLockdown() then return end

    if #disenchantList > 0 then
        local firstItem = disenchantList[1]
        -- Macro avec le bon nom du sort
        local macroText = "/cast " .. currentL.DISENCHANT_SPELL .. "\n/use " .. firstItem.bag .. " " .. firstItem.slot
        deButton:SetAttribute("macrotext", macroText)
        deButton.text:SetText(currentL.DISENCHANT)
        deButton:Enable()
        deButton:SetAlpha(1)

        -- Mettre à jour l'icône
        nextItemIcon:SetTexture(firstItem.icon)
        iconFrame:Show()

        -- Couleur de la bordure selon qualité
        local color = QUALITY_COLORS[firstItem.quality] or {1, 1, 1}
        nextItemBorder:SetVertexColor(color[1], color[2], color[3], 1)
    else
        deButton:SetAttribute("macrotext", "")
        deButton.text:SetText(currentL.NO_ITEM)
        deButton:Disable()
        deButton:SetAlpha(0.5)
        iconFrame:Hide()
    end
end

-- Scanner les sacs
function ScanBags()
    -- Vider la liste
    wipe(disenchantList)

    -- Cacher les anciens boutons
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

                -- Armure (4) ou Arme (2), qualité verte+ (2+), et filtre actif
                if (classID == 2 or classID == 4) and quality and quality >= 2 and qualityFilters[quality] then
                    count = count + 1

                    -- Ajouter à la liste
                    table.insert(disenchantList, {
                        bag = bag,
                        slot = slot,
                        link = info.hyperlink,
                        name = itemName,
                        icon = info.iconFileID,
                        quality = quality
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

                        -- Icône
                        btn.icon = btn:CreateTexture(nil, "ARTWORK")
                        btn.icon:SetSize(32, 32)
                        btn.icon:SetPoint("LEFT", btn, "LEFT", 2, 0)

                        -- Nom de l'objet
                        btn.text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                        btn.text:SetPoint("LEFT", btn.icon, "RIGHT", 8, 0)
                        btn.text:SetPoint("RIGHT", btn, "RIGHT", -5, 0)
                        btn.text:SetJustifyH("LEFT")
                        btn.text:SetWordWrap(false)

                        itemButtons[count] = btn
                    end

                    -- Configurer le bouton
                    btn.icon:SetTexture(info.iconFileID)
                    btn.text:SetText(info.hyperlink)


                    btn:SetPoint("TOPLEFT", 0, -yOffset)
                    btn:Show()

                    -- Stocker les données
                    btn.itemBag = bag
                    btn.itemSlot = slot

                    btn:SetScript("OnEnter", function(self)
                        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                        GameTooltip:SetBagItem(self.itemBag, self.itemSlot)
                        GameTooltip:Show()
                    end)
                    btn:SetScript("OnLeave", GameTooltip_Hide)

                    -- Clic pour sélectionner cet item comme prochain à désenchanter
                    btn:SetScript("OnClick", function(self)
                        if InCombatLockdown() then return end
                        -- Trouver l'item dans la liste et le déplacer en première position
                        for i, item in ipairs(disenchantList) do
                            if item.bag == self.itemBag and item.slot == self.itemSlot then
                                table.remove(disenchantList, i)
                                table.insert(disenchantList, 1, item)
                                break
                            end
                        end
                        -- Mettre à jour l'icône et le bouton DE
                        UpdateDEButton()
                    end)

                    yOffset = yOffset + 38
                end
            end
        end
    end

    scrollChild:SetHeight(math.max(yOffset, 1))
    countText:SetText(string.format(currentL.ITEMS_COUNT, count))

    -- Mettre à jour le bouton DE
    UpdateDEButton()
end

-- Après un clic, rafraîchir la liste
deButton:HookScript("OnClick", function()
    -- Debug: afficher la macro
    -- local macroText = deButton:GetAttribute("macrotext")
    -- print("|cffFFD700[SimpleDisenchant]|r Macro: " .. (macroText or "nil"))
    C_Timer.After(2, function()
        if frame:IsShown() and not InCombatLockdown() then
            ScanBags()
        end
    end)
end)

-- Commande slash
SLASH_SIMPLEDISENCHANT1 = "/sde"
SlashCmdList["SIMPLEDISENCHANT"] = function()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
        ScanBags()
    end
end

-- Rafraîchir quand les sacs changent
frame:RegisterEvent("BAG_UPDATE_DELAYED")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:SetScript("OnEvent", function(self, event)
    if frame:IsShown() and not InCombatLockdown() then
        ScanBags()
    end
end)

-- Fonction pour le bouton du compartiment addon (menu en haut à droite)
function SimpleDisenchant_OnAddonCompartmentClick(addonName, buttonName)
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
        ScanBags()
    end
end

-- ============================================
-- Bouton dans le grimoire des professions (Enchantement)
-- ============================================
local DISENCHANT_SPELL_ID = 13262 -- ID du sort Désenchanter
local professionButton = nil

local function CreateProfessionButton()
    if professionButton then return end

    -- Vérifier que ProfessionsFrame existe
    if not ProfessionsFrame then return end

    professionButton = CreateFrame("Button", "SimpleDisenchantProfessionButton", ProfessionsFrame)
    professionButton:SetSize(36, 36)
    professionButton:SetPoint("LEFT", ProfessionsFrame.CraftingPage.ConcentrationDisplay, "RIGHT", 0, 0)
    professionButton:RegisterForClicks("LeftButtonUp")
    professionButton:RegisterForDrag("LeftButton")

    -- Icône
    professionButton.icon = professionButton:CreateTexture(nil, "ARTWORK")
    professionButton.icon:SetSize(36, 36)
    professionButton.icon:SetPoint("CENTER")
    professionButton.icon:SetTexture("Interface\\Icons\\INV_Enchant_Disenchant")

    -- Highlight
    professionButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")

    -- Clic pour ouvrir SimpleDisenchant
    professionButton:SetScript("OnClick", function()
        if frame:IsShown() then
            frame:Hide()
        else
            frame:Show()
            ScanBags()
        end
    end)

    -- Drag pour créer une macro sur la barre d'action
    professionButton:SetScript("OnDragStart", function()
        if InCombatLockdown() then return end

        -- Créer ou récupérer la macro
        local macroName = "SimpleDE"
        local macroIndex = GetMacroIndexByName(macroName)

        if macroIndex == 0 then
            -- Créer la macro si elle n'existe pas
            macroIndex = CreateMacro(macroName, "INV_Enchant_Disenchant", "/sde", false)
        end

        if macroIndex and macroIndex > 0 then
            PickupMacro(macroIndex)
        end
    end)

    professionButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(currentL.TITLE)
        GameTooltip:AddLine(currentL.LOADED_MSG, 1, 1, 1)
        GameTooltip:AddLine(currentL.DRAG_TO_ACTIONBAR, 0.7, 0.7, 0.7)
        GameTooltip:Show()
    end)
    professionButton:SetScript("OnLeave", GameTooltip_Hide)
end

-- Hook quand le grimoire des professions s'ouvre
local function OnProfessionsFrameShow()
    -- Vérifier si c'est l'enchantement (profession ID 333)
    local profInfo = C_TradeSkillUI.GetBaseProfessionInfo()
    if profInfo and profInfo.professionID == 333 then
        CreateProfessionButton()
        if professionButton then
            professionButton:Show()
        end
    elseif professionButton then
        professionButton:Hide()
    end
end

-- Charger quand Blizzard_Professions est chargé
local function SetupProfessionsHook()
    if ProfessionsFrame then
        ProfessionsFrame:HookScript("OnShow", OnProfessionsFrameShow)
    end
end

-- Attendre que Blizzard_Professions soit chargé
if C_AddOns.IsAddOnLoaded("Blizzard_Professions") then
    SetupProfessionsHook()
else
    local loader = CreateFrame("Frame")
    loader:RegisterEvent("ADDON_LOADED")
    loader:SetScript("OnEvent", function(self, event, addonName)
        if addonName == "Blizzard_Professions" then
            SetupProfessionsHook()
            self:UnregisterEvent("ADDON_LOADED")
        end
    end)
end

print("|cffFFD700[SimpleDisenchant]|r " .. currentL.LOADED_MSG)
