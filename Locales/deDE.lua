-- SimpleDisenchant German Localization
local addonName, addon = ...

-- Keybinding labels (WoW global strings for the Keybindings UI)
if GetLocale() == "deDE" then
    _G.BINDING_HEADER_SIMPLEDISENCHANT = "Simple Disenchant"
    _G.BINDING_NAME_SDEBTN = "Nächsten Gegenstand entzaubern"
    _G.BINDING_NAME_SDETOGGLE = "Fenster ein-/ausblenden"
    _G.BINDING_NAME_SDEBLACKLIST = "Sperrliste ein-/ausblenden"
    _G.BINDING_NAME_SDEALL = "Alle Fenster ein-/ausblenden"
end

addon.L["deDE"] = {
    TITLE = "Simple Disenchant",
    DISENCHANT = "Entzaubern",
    DISENCHANT_SPELL = "Entzaubern",
    NO_ITEM = "Kein Gegenstand",
    ITEMS_COUNT = "%d Gegenstand(e) zum Entzaubern",
    LOADED_MSG = "/sde zum Öffnen",
    DRAG_TO_ACTIONBAR = "Zur Aktionsleiste ziehen",
    BLACKLIST_ADDED = "%s zur Sperrliste hinzugefügt",
    BLACKLIST_REMOVED = "%s von Sperrliste entfernt",
    BLACKLIST_CLEARED = "Sperrliste geleert",
    BLACKLIST_HINT = "Rechtsklick zum Sperren",
    BLACKLIST_TITLE = "Sperrliste",
    BLACKLIST_CLEAR_BTN = "Alle löschen",
    BLACKLIST_REMOVE_HINT = "Rechtsklick zum Entfernen",
    BLACKLIST_COUNT = "%d Gegenstand(e) gesperrt",
    BLACKLIST_EMPTY = "Sperrliste ist leer",
    BLACKLIST_HELP = "Nutzung: /sde blacklist [clear]",
    BLACKLIST_OPEN_HINT = "Rechtsklick für Sperrliste",
    COMBAT_WARNING = "Im Kampf nicht verfügbar",
    COMBAT_OVERLAY = "Im Kampf...",

    FILTER_BUTTON = "Filter",
    FILTER_RARITY = "Seltenheit",
    FILTER_ITEM_LEVEL = "Gegenstandsstufe",
    FILTER_VENDOR_PRICE = "Händlerpreis",
    FILTER_MIN = "Min:",
    FILTER_MAX = "Max:",
    FILTER_RESET = "Zurücksetzen",
    FILTER_ILVL_SHORT = "iLvl ",
    FILTERED_TITLE = "Gefilterte Gegenstände",
    FILTERED_COUNT = "%d Gegenstand(e) gefiltert",
    FILTERED_OVER_ILVL = "Gegenstandsstufe",
    FILTERED_OVER_GOLD = "Händlerpreis",
    FILTERED_SELECT_HINT = "Klicken um trotzdem zu entzaubern",
    FILTERED_TOOLTIP_HINT = "Durch Filter ausgeschlossene Gegenstände",

    -- Filter tooltips
    FILTER_RARITY_TOOLTIP = "Gegenstände nach Seltenheit ein- oder ausschließen",
    FILTER_ILVL_TOOLTIP = "Min/Max Gegenstandsstufe festlegen. Leer = keine Begrenzung.",
    FILTER_GOLD_TOOLTIP = "Min/Max Händlerpreis in Gold festlegen. Leer = keine Begrenzung.",

    -- Item type filter
    FILTER_ITEM_TYPE = "Gegenstandstyp",
    FILTER_ITEM_TYPE_TOOLTIP = "Gegenstände nach Typ ein- oder ausblenden. Typ abwählen um ihn auszuschließen.",
    FILTER_TYPE_ARMOR = "Rüstung",
    FILTER_TYPE_WEAPON = "Waffe",
    FILTER_TYPE_PROFESSION = "Berufsausrüstung",

    -- Minimap button
    MINIMAP_TOOLTIP_LEFT = "Linksklick zum Öffnen/Schließen",
    MINIMAP_TOOLTIP_RIGHT = "Rechtsklick für Sperrliste",
    MINIMAP_TOOLTIP_DRAG = "Ziehen zum Verschieben",
    MINIMAP_TOOLTIP_HIDE = "Umschalt-Klick zum Ausblenden",
    MINIMAP_HIDDEN_MSG = "Minimap-Button ausgeblendet. /sde minimap zum Einblenden.",
}
