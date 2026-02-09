# SimpleDisenchant

A World of Warcraft addon that makes disenchanting items from your bags quick and easy.

## Features

- **Easy disenchanting**: Display all disenchantable items (weapons and armor) in a clean interface
- **One-click action**: Select an item and disenchant it with a single button click
- **Quality filters**: Filter items by quality (Green, Blue, Purple)
- **Item selection**: Click any item in the list to set it as the next to disenchant
- **Blacklist system**: Right-click items to blacklist them (they won't appear in the list anymore)
- **Blacklist management**: View and manage your blacklist with `/sde blacklist` or right-click on the profession button
- **Profession integration**: Button in Enchanting profession UI to quickly open SimpleDisenchant
- **Tooltips**: Hover over items to see full item details
- **Multi-language**: Supports English, French, German, Spanish, Italian, and Russian

## Usage

### Basic Usage
Type `/sde` to open/close the SimpleDisenchant window.

1. Open the window with `/sde`
2. Browse your disenchantable items in the list
3. Click an item to select it (or use the first one by default)
4. Click the "Disenchant" button to disenchant the selected item
5. Use the quality filters to show/hide items by rarity

### Blacklist
- **Right-click** on any item in the list to add it to the blacklist
- Blacklisted items won't appear in the disenchant list anymore
- The blacklist persists between sessions

### Blacklist Management
- `/sde blacklist` or `/sde bl` - Open the blacklist window
- `/sde blacklist clear` or `/sde bl clear` - Clear the entire blacklist
- **Right-click** on the profession button (in Enchanting window) to open the blacklist
- In the blacklist window, **right-click** on an item to remove it from the blacklist

### Profession Integration
When you open the Enchanting profession window, a SimpleDisenchant button appears.
- **Left-click**: Open the main SimpleDisenchant window
- **Right-click**: Open the blacklist window
- **Drag**: Create a macro on your action bar

## Installation

1. Download the latest release
2. Extract the `SimpleDisenchant` folder to your `World of Warcraft\_retail_\Interface\AddOns` directory
3. Restart WoW or type `/reload`

## Requirements

- World of Warcraft Retail (12.0+)
- Enchanting profession (to use the disenchant ability)

## Links

- [CurseForge](https://www.curseforge.com/wow/addons/simpledisenchant)
- [Wago.io](https://addons.wago.io/addons/simpledisenchant)
- [GitHub](https://github.com/Artenola/SimpleDisenchant)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
