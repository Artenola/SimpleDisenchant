# Changelog

All notable changes to SimpleDisenchant will be documented in this file.

## [1.5.0] - 2026-03-05

### Added
- **Minimap button**: Draggable button on the minimap edge for quick access
  - Left-click to toggle main window
  - Right-click to toggle blacklist
  - Shift-click to hide the button
  - Drag to reposition around the minimap
  - Position and visibility saved per character
  - Show/hide via `/sde minimap`
- **Addon Compartment enhancements**: Same interactions as minimap button
  - Left-click to toggle main window
  - Right-click to toggle blacklist
  - Shift-click to show/hide minimap button
  - Tooltip with usage instructions
- **New keybindings** (Key Bindings > Simple Disenchant):
  - Toggle window: open/close the main frame
  - Toggle blacklist: open/close the blacklist
  - Toggle all windows: open or close all SimpleDisenchant windows at once
- **Item filters** (Issue #19, #20, #21): Filter dropdown with WoW-native menu API
  - Quality/rarity checkboxes with colored names (Uncommon, Rare, Epic) matching Auction House style
  - Item level min/max range filter to protect high-level gear from accidental disenchanting
  - Vendor price min/max range filter (in gold) to keep valuable items
  - Section titles with descriptive tooltips on hover
  - Built-in reset button to restore default filters
  - Filter settings saved per-character in SavedVariables
- **Search box**: Filter items by name with instant search (Blizzard SearchBoxTemplate)
- **Filtered Items panel**: Side panel showing items excluded by ilvl/gold filters
  - Items grouped by filter reason (Item Level / Vendor Price) with section headers
  - Click any filtered item to disenchant it anyway
  - Auto-docks next to main frame or blacklist frame
- **Item details on every row**: Item level and vendor sell price displayed below item name
  - Aligned price columns (gold | silver | copper) with coin icons for easy comparison
  - Consistent "00" placeholder when a denomination is zero for perfect alignment
  - Applied to main item list, blacklist, and filtered items panel
- **Visual separator lines** between items in all scroll lists
- **Filtered Items button** in the main frame header to toggle the filtered panel
- **Minimap button**: Draggable button on the minimap edge for quick access
  - Left-click to toggle main window
  - Right-click to toggle blacklist
  - Shift-click to hide the button
  - Drag to reposition around the minimap
  - Position and visibility saved per character
  - Show/hide via `/sde minimap`
- **Addon Compartment enhancements**: Same interactions as minimap button
  - Left-click to toggle main window
  - Right-click to toggle blacklist
  - Shift-click to show/hide minimap button
  - Tooltip with usage instructions
- **New keybindings** (Key Bindings > Simple Disenchant):
  - Toggle window: open/close the main frame
  - Toggle blacklist: open/close the blacklist
  - Toggle all windows: open or close all SimpleDisenchant windows at once

### Fixed
- Frame overlap: clicking a window now brings it to the front when frames overlap
- Blacklist item icons now load correctly on first display (async item info handling)

### Changed
- Quality filter buttons replaced by native WoW filter dropdown (WowStyle1FilterDropdownTemplate)
- Blacklist frame now displays item level and vendor price on each row
- Item row height reduced from 42px to 36px with smaller 24px icons for a more compact list
- Module renamed from FilterButtons to FilterPanel for clarity

### Fixed
- Frame overlap: clicking a window now brings it to the front when frames overlap
- Blacklist item icons now load correctly on first display (async item info handling)

## [1.4.0] - 2026-02-18

### Added
- Keybinding support: assign a shortcut to the disenchant button via WoW's Key Bindings UI (Escape > Key Bindings > Simple Disenchant)
- Keybinding labels localized in EN, FR, DE, ES, IT, RU
- Updated install.ps1 and install.sh to include Bindings.xml and all addon folders

## [1.3.0] - 2026-02-15

### Added
- Custom arcane-themed disenchant button texture with 4 states (normal, hover, pressed, disabled)
- Dark background for item list and blacklist list matching Blizzard's profession recipe list style
- Inset border (NineSlice) around scroll lists for polished look

### Changed
- Modernized scroll bars to use Blizzard's new MinimalScrollBar and ScrollBox system
- Replaced legacy UIPanelScrollFrameTemplate with WowScrollBoxList and DataProvider pattern
- Updated both item list and blacklist frame with modern scroll components
- Disenchant button now uses custom texture strip with proper state management
- Blacklist chat messages now display clickable item links instead of plain text names

## [1.2.2] - 2026-02-12

### Added
- Combat warning message when trying to use the addon during combat
- Combat overlay on the main frame when entering combat (grayed out interface with "In combat..." text)

### Fixed
- Added combat lockdown protection to prevent errors when opening/closing frames during combat
- Profession button now only shows on the Recipes tab (first tab) instead of all tabs

## [1.2.1] - 2025-02-10

### Fixed
- Blacklist is now per-character instead of global (#10)
- Blacklist now uses unique item identification (item link with bonus IDs) instead of generic itemID (#11)
  - This allows blacklisting a specific item variant without affecting other items of the same base type

### Changed
- Changed SavedVariables to SavedVariablesPerCharacter
- Tooltip in blacklist frame shows exact item stats via SetHyperlink

## [1.2.0] - 2025-02-09

### Added
- **Blacklist system**: Right-click on items to add them to a blacklist
- **Blacklist window**: View and manage blacklisted items (`/sde blacklist` or `/sde bl`)
- **Blacklist persistence**: Blacklist is saved between sessions using SavedVariables
- **Blacklist commands**: `/sde bl clear` to clear the entire blacklist
- **Right-click on profession button**: Opens the blacklist window
- **Blacklist window docking**: Blacklist window auto-docks next to main window
- Close window with Escape key

### Changed
- Modular code structure (Locales/, Core/, UI/ folders)
- Improved locale loading system

## [1.1.0] - 2025-01-26

### Added
- Button in Enchanting profession UI to open SimpleDisenchant
- Drag button to action bar creates a macro to toggle the addon
- Frame auto-docks next to profession window when opened from there

### Changed
- New Blizzard-style portrait frame (PortraitFrameTemplate)
- Use native Blizzard disenchant icon for better quality
- Updated interface version for TWW 12.0.1

## [1.0.0] - 2025-01-26

### Added
- Initial release
- Display disenchantable items from bags (weapons and armor, green+ quality)
- One-click disenchant button using SecureActionButton
- Quality filters (Green, Blue, Purple)
- Click on list item to select it as next to disenchant
- Tooltip on hover for item details
- Multi-language support: English, French, German, Spanish, Italian, Russian
- Draggable window
- Auto-refresh when bags change
