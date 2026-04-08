-- Luacheck configuration for SimpleDisenchant (WoW addon)
-- https://luacheck.readthedocs.io

std = "lua51"
max_line_length = false
codes = true

exclude_files = {
    "Libs/**",
    ".build/**",
    ".release/**",
    ".luacheckrc",
}

ignore = {
    "11./SLASH_.*",     -- slash command globals
    "113",               -- accessing undefined variable (WoW API globals can't be enumerated)
    "211",               -- unused local variable
    "212",               -- unused argument
    "213",               -- unused loop variable
    "311",               -- value assigned to a local variable is unused
    "314",               -- value of a field is unused
    "411",               -- redefining a local variable
    "412",               -- redefining an argument
    "421",               -- shadowing a local variable
    "422",               -- shadowing an argument
    "431",               -- shadowing an upvalue
    "432",               -- shadowing an upvalue argument
    "542",               -- empty if branch
}

globals = {
    -- SavedVariables
    "SimpleDisenchantDB",
    -- Addon namespace
    "SimpleDisenchant",
    "SimpleDisenchant_OnAddonCompartmentClick",
    "SimpleDisenchant_OnAddonCompartmentEnter",
    "SimpleDisenchant_OnAddonCompartmentLeave",
}

read_globals = {
    -- Lua standard
    "bit",
    -- Core WoW API
    "C_Container", "C_Item", "C_EquipmentSet", "C_Timer", "C_AddOns",
    "C_TradeSkillUI", "C_Spell",
    "CreateFrame", "CreateFromMixins", "Mixin",
    "UIParent", "WorldFrame", "GameTooltip", "ItemRefTooltip",
    "GameFontNormal", "GameFontHighlight", "GameFontDisable",
    "GameFontNormalSmall", "GameFontHighlightSmall",
    -- Frame templates / globals
    "BackdropTemplateMixin", "ScrollingMessageFrame",
    -- Item & inventory
    "GetItemInfo", "GetItemInfoInstant", "GetItemQualityColor",
    "GetItemSpell", "GetContainerNumSlots", "GetContainerItemInfo",
    "GetContainerItemLink", "GetContainerItemID", "GetInventoryItemLink",
    "PickupContainerItem", "UseContainerItem", "ClearCursor",
    "EquipmentManager_GetLocationData", "EquipmentManager_UnpackLocation",
    -- Player
    "UnitName", "UnitClass", "UnitLevel", "UnitExists", "GetSpellInfo",
    "IsSpellKnown", "GetSpecialization", "GetSpecializationInfo",
    "GetProfessions", "GetProfessionInfo",
    -- Combat & state
    "InCombatLockdown", "IsAddOnLoaded", "GetAddOnMetadata",
    "GetTime", "GetServerTime",
    -- Strings & locale
    "GetLocale", "format", "strsplit", "strjoin", "strtrim",
    -- Tooltip API
    "TooltipDataProcessor",
    -- UI
    "PlaySound", "PlaySoundFile", "SOUNDKIT",
    "StaticPopupDialogs", "StaticPopup_Show", "StaticPopup_Hide",
    "ChatFrame1", "DEFAULT_CHAT_FRAME",
    -- Slash commands
    "SLASH_SDE1", "SLASH_SDE2",
    "SlashCmdList",
    -- Misc
    "hooksecurefunc", "issecurevariable", "securecall",
    "ITEM_QUALITY_COLORS", "ITEM_QUALITY0_DESC", "ITEM_QUALITY1_DESC",
    "ITEM_QUALITY2_DESC", "ITEM_QUALITY3_DESC", "ITEM_QUALITY4_DESC",
    "ITEM_QUALITY5_DESC", "ITEM_QUALITY6_DESC", "ITEM_QUALITY7_DESC",
    "LE_ITEM_QUALITY_POOR", "LE_ITEM_QUALITY_COMMON",
    "LE_ITEM_QUALITY_UNCOMMON", "LE_ITEM_QUALITY_RARE",
    "LE_ITEM_QUALITY_EPIC", "LE_ITEM_QUALITY_LEGENDARY",
    "LE_ITEM_CLASS_ARMOR", "LE_ITEM_CLASS_WEAPON",
    "LE_ITEM_CLASS_PROFESSION",
    "Enum",
    -- LibStub (loaded as external)
    "LibStub",
}
