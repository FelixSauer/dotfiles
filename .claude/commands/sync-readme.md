---
description: Regenerate all README tables from the actual config files
allowed-tools: Read, Edit
---

Synchronize all README.md tables with the current state of the config files.
This command takes no arguments.

## Step 1 — Read all source files

Read these files in full:
1. `setup.sh` — extract brew packages, cargo installs, pipx installs, binary downloads
2. `packages.config` — complete stow package list with OS assignments
3. `fish/.config/fish/config.fish` — all aliases with their categories
4. `tmux/.config/tmux/tmux.conf` — current hex color values
5. `nvim/.config/nvim/lua/plugins/nvim-colorscheme.lua` — current colorscheme
6. `README.md` — current state (to understand what needs to change)

## Step 2 — Extract data

From `setup.sh`, extract:
- **macOS brew formulas**: the `local packages=(...)` array in `install_macos()`
- **macOS brew casks**: the `local casks=(...)` array in `install_macos()`
- **macOS special installs**: ollama (brew), opencode (sst tap), himalaya (cargo --features oauth2)
- **Linux apt packages**: the `local packages=(...)` array in `install_linux()`
- **Linux binary downloads**: go, neovim, lazygit, lazydocker, glow, mongosh (GitHub releases)
- **Cargo installs**: all `cargo install` calls on both platforms
- **pipx installs**: all `pipx install` calls on both platforms

From `fish/config.fish`, extract all aliases with their category comments.

From `packages.config`, extract all `<package> <os>` pairs.

## Step 3 — Update README sections

Rewrite only the dynamic table sections. Leave all prose, headings, code blocks, and
sections that are not derived from config (Key Bindings, Post-Install instructions,
How GNU Stow works, etc.) unchanged.

### Section: Installation Details — macOS

Update the bullet list to reflect the current `install_macos()` content:
- Formulas line: list all brew formula packages alphabetically
- Casks line: list all casks
- SST Tap, Brew, Cargo, pipx lines: match current installs

### Section: Installation Details — Linux table

Regenerate the table rows to match `install_linux()`. One row per tool, sorted alphabetically.
Columns: Tool | Method

Group the apt packages into a single row (the long comma-separated list), same as the
current README style.

### Section: Packages table

Regenerate all rows from `packages.config`. Sort alphabetically by package name.
For each package, write a brief description (keep existing descriptions where possible,
write new ones only for packages not currently in README).
Columns: Package | OS | Description

Include aliases in the description where applicable (check the fish config).

### Section: Color Theme table

Re-read the tmux config for hex color values currently in use. Verify they match the
README table. Update any hex values that have drifted.

### Section: Fish Alias table

Regenerate from `fish/config.fish`. Include all aliases in the order they appear in config.
Preserve the `Alt+Cr` keybinding row (it's not an alias but belongs in the table).
Columns: Alias | Expands to

## Step 4 — Report

After completing the sync, report:
- Which sections were updated (list changed lines if small, or summarize if large)
- Which sections were left unchanged
- Any discrepancies found (e.g. packages in setup.sh but not in packages.config)
