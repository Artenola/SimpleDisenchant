# Changelog

All notable changes to SimpleDisenchant will be documented in this file.

## [1.3.0] - 2026-02-10

### Changed
- Modernized scroll bars to use Blizzard's new MinimalScrollBar and ScrollBox system
- Replaced legacy UIPanelScrollFrameTemplate with WowScrollBoxList and DataProvider pattern
- Updated both item list and blacklist frame with modern scroll components

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
