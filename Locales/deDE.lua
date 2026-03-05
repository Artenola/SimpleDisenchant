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
    QUALITY_GREEN = "Grün",
    QUALITY_BLUE = "Blau",
    QUALITY_PURPLE = "Lila",
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
    MINIMAP_TOOLTIP_LEFT = "Linksklick zum Öffnen/Schließen",
    MINIMAP_TOOLTIP_RIGHT = "Rechtsklick für Sperrliste",
    MINIMAP_TOOLTIP_DRAG = "Ziehen zum Verschieben",
    MINIMAP_TOOLTIP_HIDE = "Umschalt-Klick zum Ausblenden",
    MINIMAP_HIDDEN_MSG = "Minimap-Button ausgeblendet. /sde minimap zum Einblenden.",
}
