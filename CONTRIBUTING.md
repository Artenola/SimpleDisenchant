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
5. Commit using [Conventional Commits](#commit-messages) format
6. Push and open a Pull Request to `develop`

### Commit Messages

This project uses [Conventional Commits](https://www.conventionalcommits.org/).
Commit messages drive automatic version bumps and changelog generation via
[release-please](https://github.com/googleapis/release-please).

**Format:** `type(scope): description`

| Type        | When to use                                  | Version impact |
|-------------|----------------------------------------------|----------------|
| `feat`      | New feature                                  | minor (1.6.0 → 1.7.0) |
| `fix`       | Bug fix                                      | patch (1.6.0 → 1.6.1) |
| `perf`      | Performance improvement                      | patch          |
| `refactor`  | Code change without new feature or bug fix   | patch          |
| `docs`      | Documentation only                           | none           |
| `style`     | Formatting, whitespace                       | none           |
| `test`      | Adding or updating tests                     | none           |
| `chore`     | Maintenance, dependencies, tooling           | none           |
| `ci`        | CI/CD changes                                | none           |
| `build`     | Build system, packaging                      | none           |

**Breaking changes:** add `!` after the type (e.g. `feat!:`) or include
`BREAKING CHANGE:` in the commit body. This bumps the **major** version.

**Examples:**
```
feat(filters): add binding type filter
fix(ui): resolve window overlap on logout
perf(scan): cache item info between bag updates
docs: update installation instructions
chore(deps): update LibDataBroker
feat!: redesign settings UI
```

The scope (in parentheses) is optional but recommended for clarity. Common
scopes: `ui`, `core`, `filters`, `i18n`, `deps`.

### Code Style

- Use local variables when possible
- Comment complex logic (in English or French)
- Follow existing code patterns
- Test with different locales if modifying translations
- Run `luacheck .` locally before pushing (the CI will block on errors)

### Translations

Translation files are in the `Locales/` folder. To add or improve translations, edit the corresponding locale file (e.g., `Locales/frFR.lua`):

```lua
addon.L["xxXX"] = {
    TITLE = "...",
    DISENCHANT = "...",
    -- etc.
}
```

The default English strings are in `Locales/Locales.lua`.

## Questions?

Open a [Discussion](https://github.com/Artenola/SimpleDisenchant/discussions) for questions or ideas.
