-- SimpleDisenchant French Localization
local addonName, addon = ...

-- Keybinding labels (WoW global strings for the Keybindings UI)
if GetLocale() == "frFR" then
    _G.BINDING_HEADER_SIMPLEDISENCHANT = "Simple Disenchant"
    _G.BINDING_NAME_SDEBTN = "Désenchanter l'objet suivant"
    _G.BINDING_NAME_SDETOGGLE = "Ouvrir/Fermer la fenêtre"
    _G.BINDING_NAME_SDEBLACKLIST = "Ouvrir/Fermer la liste noire"
    _G.BINDING_NAME_SDEALL = "Ouvrir/Fermer toutes les fenêtres"
end

addon.L["frFR"] = {

    TITLE = "Simple Disenchant",
    DISENCHANT = "Désenchanter",
    DISENCHANT_SPELL = "Désenchanter",
    NO_ITEM = "Aucun objet",
    ITEMS_COUNT = "%d objet(s) à désenchanter",
    LOADED_MSG = "/sde pour ouvrir",
    DRAG_TO_ACTIONBAR = "Glisser vers la barre d'action",
    BLACKLIST_ADDED = "%s ajouté à la liste noire",
    BLACKLIST_REMOVED = "%s retiré de la liste noire",
    BLACKLIST_CLEARED = "Liste noire vidée",
    BLACKLIST_HINT = "Clic droit pour ignorer",
    BLACKLIST_TITLE = "Liste noire",
    BLACKLIST_CLEAR_BTN = "Tout effacer",
    BLACKLIST_REMOVE_HINT = "Clic droit pour retirer",
    BLACKLIST_COUNT = "%d objet(s) ignoré(s)",
    BLACKLIST_EMPTY = "Liste noire vide",
    BLACKLIST_HELP = "Usage: /sde blacklist [clear]",
    BLACKLIST_OPEN_HINT = "Clic droit pour la liste noire",
    COMBAT_WARNING = "Indisponible en combat",
    COMBAT_OVERLAY = "En combat...",

    FILTER_BUTTON = "Filtrer",
    FILTER_RARITY = "Rareté",
    FILTER_ITEM_LEVEL = "Niveau d'objet",
    FILTER_VENDOR_PRICE = "Prix marchand",
    FILTER_MIN = "Min :",
    FILTER_MAX = "Max :",
    FILTER_RESET = "Réinitialiser",
    FILTER_ILVL_SHORT = "iLvl ",
    FILTERED_TITLE = "Objets filtrés",
    FILTERED_COUNT = "%d objet(s) filtré(s)",
    FILTERED_OVER_ILVL = "Niveau d'objet",
    FILTERED_OVER_GOLD = "Prix marchand",
    FILTERED_SELECT_HINT = "Cliquer pour désenchanter quand même",
    FILTERED_TOOLTIP_HINT = "Objets exclus par les filtres",

    -- Filter tooltips
    FILTER_RARITY_TOOLTIP = "Inclure ou exclure les objets par rareté",
    FILTER_ILVL_TOOLTIP = "Définir un niveau d'objet min/max. Vide = pas de limite.",
    FILTER_GOLD_TOOLTIP = "Définir un prix marchand min/max en or. Vide = pas de limite.",

    -- Item type filter
    FILTER_ITEM_TYPE = "Type d'objet",
    FILTER_ITEM_TYPE_TOOLTIP = "Afficher ou masquer les objets par type. Decochez un type pour l'exclure de la liste.",
    FILTER_TYPE_ARMOR = "Armure",
    FILTER_TYPE_WEAPON = "Arme",
    FILTER_TYPE_PROFESSION = "Equipement de profession",

    -- Minimap button
    MINIMAP_TOOLTIP_LEFT = "Clic gauche pour ouvrir/fermer",
    MINIMAP_TOOLTIP_RIGHT = "Clic droit pour la liste noire",
    MINIMAP_TOOLTIP_DRAG = "Glisser pour déplacer",
    MINIMAP_TOOLTIP_HIDE = "Shift-clic pour masquer",
    MINIMAP_HIDDEN_MSG = "Bouton minimap masqué. Tapez /sde minimap pour le réafficher.",
}
