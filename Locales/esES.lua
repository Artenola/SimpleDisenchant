-- SimpleDisenchant Spanish Localization
local addonName, addon = ...

-- Keybinding labels (WoW global strings for the Keybindings UI)
if GetLocale() == "esES" or GetLocale() == "esMX" then
    _G.BINDING_HEADER_SIMPLEDISENCHANT = "Simple Disenchant"
    _G.BINDING_NAME_SDEBTN = "Desencantar siguiente objeto"
end

addon.L["esES"] = {
    TITLE = "Simple Disenchant",
    DISENCHANT = "Desencantar",
    DISENCHANT_SPELL = "Desencantar",
    NO_ITEM = "Sin objeto",
    ITEMS_COUNT = "%d objeto(s) a desencantar",
    LOADED_MSG = "/sde para abrir",
    DRAG_TO_ACTIONBAR = "Arrastrar a barra de acción",
    BLACKLIST_ADDED = "%s añadido a lista negra",
    BLACKLIST_REMOVED = "%s eliminado de lista negra",
    BLACKLIST_CLEARED = "Lista negra vaciada",
    BLACKLIST_HINT = "Clic derecho para ignorar",
    BLACKLIST_TITLE = "Lista negra",
    BLACKLIST_CLEAR_BTN = "Borrar todo",
    BLACKLIST_REMOVE_HINT = "Clic derecho para eliminar",
    BLACKLIST_COUNT = "%d objeto(s) ignorado(s)",
    BLACKLIST_EMPTY = "Lista negra vacía",
    BLACKLIST_HELP = "Uso: /sde blacklist [clear]",
    BLACKLIST_OPEN_HINT = "Clic derecho para lista negra",
    COMBAT_WARNING = "No disponible en combate",
    COMBAT_OVERLAY = "En combate...",

    FILTER_BUTTON = "Filtrar",
    FILTER_RARITY = "Rareza",
    FILTER_ITEM_LEVEL = "Nivel de objeto",
    FILTER_VENDOR_PRICE = "Precio de venta",
    FILTER_MIN = "Mín:",
    FILTER_MAX = "Máx:",
    FILTER_RESET = "Reiniciar",
    FILTER_ILVL_SHORT = "iLvl ",
    FILTERED_TITLE = "Objetos filtrados",
    FILTERED_COUNT = "%d objeto(s) filtrado(s)",
    FILTERED_OVER_ILVL = "Nivel de objeto",
    FILTERED_OVER_GOLD = "Precio de venta",
    FILTERED_SELECT_HINT = "Clic para desencantar de todas formas",
    FILTERED_TOOLTIP_HINT = "Objetos excluidos por filtros",

    -- Filter tooltips
    FILTER_RARITY_TOOLTIP = "Incluir o excluir objetos por rareza",
    FILTER_ILVL_TOOLTIP = "Establecer nivel de objeto mín/máx. Vacío = sin límite.",
    FILTER_GOLD_TOOLTIP = "Establecer precio de venta mín/máx en oro. Vacío = sin límite.",
}

-- Latin American Spanish uses same as European Spanish
addon.L["esMX"] = addon.L["esES"]
