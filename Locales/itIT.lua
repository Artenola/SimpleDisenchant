-- SimpleDisenchant Italian Localization
local addonName, addon = ...

-- Keybinding labels (WoW global strings for the Keybindings UI)
if GetLocale() == "itIT" then
    _G.BINDING_HEADER_SIMPLEDISENCHANT = "Simple Disenchant"
    _G.BINDING_NAME_SDEBTN = "Disincanta il prossimo oggetto"
    _G.BINDING_NAME_SDETOGGLE = "Mostra/Nascondi finestra"
    _G.BINDING_NAME_SDEBLACKLIST = "Mostra/Nascondi lista nera"
    _G.BINDING_NAME_SDEALL = "Mostra/Nascondi tutte le finestre"
end

addon.L["itIT"] = {
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
    BLACKLIST_ADDED = "%s aggiunto alla lista nera",
    BLACKLIST_REMOVED = "%s rimosso dalla lista nera",
    BLACKLIST_CLEARED = "Lista nera svuotata",
    BLACKLIST_HINT = "Clic destro per ignorare",
    BLACKLIST_TITLE = "Lista nera",
    BLACKLIST_CLEAR_BTN = "Cancella tutto",
    BLACKLIST_REMOVE_HINT = "Clic destro per rimuovere",
    BLACKLIST_COUNT = "%d oggetto/i ignorato/i",
    BLACKLIST_EMPTY = "Lista nera vuota",
    BLACKLIST_HELP = "Uso: /sde blacklist [clear]",
    BLACKLIST_OPEN_HINT = "Clic destro per lista nera",
    COMBAT_WARNING = "Non disponibile in combattimento",
    COMBAT_OVERLAY = "In combattimento...",
    MINIMAP_TOOLTIP_LEFT = "Clic sinistro per aprire/chiudere",
    MINIMAP_TOOLTIP_RIGHT = "Clic destro per lista nera",
    MINIMAP_TOOLTIP_DRAG = "Trascina per spostare",
    MINIMAP_TOOLTIP_HIDE = "Shift-clic per nascondere",
    MINIMAP_HIDDEN_MSG = "Pulsante minimappa nascosto. Digita /sde minimap per mostrarlo.",
}
