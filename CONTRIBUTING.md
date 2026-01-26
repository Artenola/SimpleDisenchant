# Contributing to SimpleDisenchant

Thank you for your interest in contributing to SimpleDisenchant!

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](https://github.com/Artenola/SimpleDisenchant/issues)
2. If not, create a new issue with:
   - WoW version and addon version
   - Steps to reproduce the bug
   - Expected vs actual behavior
   - Any error messages (use `/console scriptErrors 1` to see Lua errors)

### Suggesting Features

Open an issue with the `enhancement` label describing:
- What you'd like to see added
- Why it would be useful
- Any implementation ideas you have

### Submitting Code

1. Fork the repository
2. Create a feature branch from `develop`:
   ```
   git checkout develop
   git checkout -b feature/your-feature-name
   ```
3. Make your changes
4. Test in-game thoroughly
5. Commit with clear messages
6. Push and open a Pull Request to `develop`

### Code Style

- Use local variables when possible
- Comment complex logic (in English or French)
- Follow existing code patterns
- Test with different locales if modifying translations

### Translations

To add or improve translations, edit the `L` table in `SimpleDisenchant.lua`:

```lua
L["xxXX"] = {
    TITLE = "...",
    DISENCHANT = "...",
    -- etc.
}
```

## Questions?

Open a [Discussion](https://github.com/Artenola/SimpleDisenchant/discussions) for questions or ideas.
