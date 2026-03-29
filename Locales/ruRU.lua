-- SimpleDisenchant Russian Localization
local addonName, addon = ...

-- Keybinding labels (WoW global strings for the Keybindings UI)
if GetLocale() == "ruRU" then
    _G.BINDING_HEADER_SIMPLEDISENCHANT = "Simple Disenchant"
    _G.BINDING_NAME_SDEBTN = "Распылить следующий предмет"
    _G.BINDING_NAME_SDETOGGLE = "Показать/Скрыть окно"
    _G.BINDING_NAME_SDEBLACKLIST = "Показать/Скрыть черный список"
    _G.BINDING_NAME_SDEALL = "Показать/Скрыть все окна"
end

addon.L["ruRU"] = {
    TITLE = "Simple Disenchant",
    DISENCHANT = "Распылить",
    DISENCHANT_SPELL = "Распыление",
    NO_ITEM = "Нет предмета",
    ITEMS_COUNT = "%d предмет(ов)",
    LOADED_MSG = "/sde открыть",
    DRAG_TO_ACTIONBAR = "Перетащить на панель действий",
    BLACKLIST_ADDED = "%s добавлен в черный список",
    BLACKLIST_REMOVED = "%s удален из черного списка",
    BLACKLIST_CLEARED = "Черный список очищен",
    BLACKLIST_HINT = "ПКМ для игнорирования",
    BLACKLIST_TITLE = "Черный список",
    BLACKLIST_CLEAR_BTN = "Очистить",
    BLACKLIST_REMOVE_HINT = "ПКМ для удаления",
    BLACKLIST_COUNT = "%d предмет(ов) игнорируется",
    BLACKLIST_EMPTY = "Черный список пуст",
    BLACKLIST_HELP = "Исп.: /sde blacklist [clear]",
    BLACKLIST_OPEN_HINT = "ПКМ для черного списка",
    COMBAT_WARNING = "Недоступно в бою",
    COMBAT_OVERLAY = "В бою...",

    FILTER_BUTTON = "Фильтр",
    FILTER_RARITY = "Редкость",
    FILTER_ITEM_LEVEL = "Уровень предмета",
    FILTER_VENDOR_PRICE = "Цена у торговца",
    FILTER_MIN = "Мин:",
    FILTER_MAX = "Макс:",
    FILTER_RESET = "Сбросить",
    FILTER_ILVL_SHORT = "iLvl ",
    FILTERED_TITLE = "Отфильтрованные предметы",
    FILTERED_COUNT = "%d предмет(ов) отфильтровано",
    FILTERED_OVER_ILVL = "Уровень предмета",
    FILTERED_OVER_GOLD = "Цена у торговца",
    FILTERED_SELECT_HINT = "Нажмите, чтобы распылить",
    FILTERED_TOOLTIP_HINT = "Предметы, исключённые фильтрами",

    -- Filter tooltips
    FILTER_RARITY_TOOLTIP = "Включить или исключить предметы по редкости",
    FILTER_ILVL_TOOLTIP = "Задать мин/макс уровень предмета. Пусто = без ограничений.",
    FILTER_GOLD_TOOLTIP = "Задать мин/макс цену у торговца в золоте. Пусто = без ограничений.",

    -- Reset positions
    RESET_POSITIONS_MSG = "Все позиции окон сброшены.",

    -- Minimap button
    MINIMAP_TOOLTIP_LEFT = "ЛКМ для открытия/закрытия",
    MINIMAP_TOOLTIP_RIGHT = "ПКМ для черного списка",
    MINIMAP_TOOLTIP_DRAG = "Перетащите для перемещения",
    MINIMAP_TOOLTIP_HIDE = "Shift-клик чтобы скрыть",
    MINIMAP_HIDDEN_MSG = "Кнопка миникарты скрыта. /sde minimap чтобы показать.",
}
