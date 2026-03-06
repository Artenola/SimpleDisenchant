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

    FILTER_BUTTON = "Filtra",
    FILTER_RARITY = "Rarità",
    FILTER_ITEM_LEVEL = "Livello oggetto",
    FILTER_VENDOR_PRICE = "Prezzo venditore",
    FILTER_MIN = "Min:",
    FILTER_MAX = "Max:",
    FILTER_RESET = "Reimposta",
    FILTER_ILVL_SHORT = "iLvl ",
    FILTERED_TITLE = "Oggetti filtrati",
    FILTERED_COUNT = "%d oggetto/i filtrato/i",
    FILTERED_OVER_ILVL = "Livello oggetto",
    FILTERED_OVER_GOLD = "Prezzo venditore",
    FILTERED_SELECT_HINT = "Clicca per disincantare comunque",
    FILTERED_TOOLTIP_HINT = "Oggetti esclusi dai filtri",

    -- Filter tooltips
    FILTER_RARITY_TOOLTIP = "Includi o escludi oggetti per rarità",
    FILTER_ILVL_TOOLTIP = "Imposta livello oggetto min/max. Vuoto = nessun limite.",
    FILTER_GOLD_TOOLTIP = "Imposta prezzo venditore min/max in oro. Vuoto = nessun limite.",

    -- Minimap button
    MINIMAP_TOOLTIP_LEFT = "Clic sinistro per aprire/chiudere",
    MINIMAP_TOOLTIP_RIGHT = "Clic destro per lista nera",
    MINIMAP_TOOLTIP_DRAG = "Trascina per spostare",
    MINIMAP_TOOLTIP_HIDE = "Shift-clic per nascondere",
    MINIMAP_HIDDEN_MSG = "Pulsante minimappa nascosto. Digita /sde minimap per mostrarlo.",
}
