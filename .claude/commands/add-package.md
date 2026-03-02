---
description: Add a new tool to setup.sh (both OSes), fish alias, and README
argument-hint: <github-url-or-package-name>
allowed-tools: WebFetch, Bash, Read, Edit
---

You are adding a new tool/package to the dotfiles project. The argument is: $ARGUMENTS

Work through these steps in order.

## Step 1 — Identify the package

If the argument looks like a GitHub URL (contains `github.com`), fetch the repository page
to determine:
- What the tool does (one-line description)
- The install method: brew formula, cargo crate, pipx package, go binary, or GitHub release binary
- Whether Linux needs extra apt build-deps (check Cargo.toml for crate dependencies that need system libs)

If the argument is a plain name (e.g. `ripgrep`), use your knowledge to determine the
install method.

Key install method rules for this project:
- macOS: prefer `brew install` for everything that has a formula; use cargo/pipx/go as fallback
- Linux: prefer `apt` if available; otherwise use the same method as macOS (cargo, pipx, go, GitHub release binary)
- Cargo crates: check if they need system libs (e.g. audio → libasound2-dev, SSL → libssl-dev)

## Step 2 — Read existing files

Read these files to understand current state:
- `setup.sh` — to find the right insertion points
- `fish/.config/fish/config.fish` — to find the right alias category
- `README.md` — to find the tables to update

## Step 3 — Update setup.sh

Add the installation block in BOTH `install_macos()` AND `install_linux()`.

Follow the existing pattern exactly:

```bash
# <tool-name> — <one-line description>
if command -v <binary> &>/dev/null; then
    log_ok "<tool-name> already installed"
else
    log_info "Installing <tool-name>..."
    <install command>
    log_ok "<tool-name>"
fi
```

For brew packages, add the package name to the `local packages=(...)` array in `install_macos()` instead of adding a separate block.

For Linux-only apt packages, add the package name to the `local packages=(...)` array in `install_linux()`.

If the Linux install needs extra apt build-deps not already in the packages array, add them
to the apt packages array. Common ones already present: build-essential, libclang-dev,
libasound2-dev, libssl-dev, pkg-config, libxml2-dev, libsqlite3-dev, cmake.

## Step 4 — Update fish/config.fish

Add a short, memorable alias. Pick the right category:
- General: everyday tools (file ops, editors, git)
- Games: games and entertainment
- Network: network tools
- Media/News: media and RSS

Pattern: `alias <short> '<full-command>'`

If no obvious alias makes sense, skip this step.

## Step 5 — Update README.md

Update three places:

1. **Installation Details — macOS section** (the bullet list): add the package under the
   correct method heading (Formulas / Casks / Cargo / pipx / etc.)

2. **Installation Details — Linux table**: add a row with the tool name and install method

3. **Packages table** (alphabetical): add a row following this pattern:
   `| <name> | both/macos/linux | <description> |`
   Include the alias in the description if one was added.

4. **Fish Alias table** (if an alias was added): add a row.

After making all changes, summarize what was added and where.
