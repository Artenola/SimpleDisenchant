# Changelog

All notable changes to SimpleDisenchant will be documented in this file.

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
