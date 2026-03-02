```
    _     _    __ _ _
 __| |___| |_ / _(_) |___ ___
/ _` / _ \  _|  _| | / -_|_-<
\__,_\___/\__|_| |_|_\___/__/
```

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).
Supports macOS (Homebrew) and Linux (apt).

---

## Structure

Each tool has its own top-level directory. Inside, the path mirrors `$HOME` exactly,
so GNU Stow can create the correct symlinks automatically.

```
dotfiles/
├── setup.sh              # Bootstrap script (install + stow)
├── packages.config       # OS-specific package assignments
│
├── fish/                 # Example: single config file
│   └── .config/fish/
│       └── config.fish
│
└── nvim/                 # Example: nested structure
    └── .config/nvim/
        ├── init.lua
        └── lua/
```

### How GNU Stow works

Stow reads each package directory and creates symlinks in `$HOME` that mirror
the directory tree.

```
dotfiles/fish/.config/fish/config.fish
         ^--- package    ^--- relative to $HOME

result: ~/.config/fish/config.fish -> ~/dotfiles/fish/.config/fish/config.fish
```

---

## Quick Setup

```bash
# 1. Clone the repository
git clone https://github.com/<your-username>/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Run the setup script
bash setup.sh
```

`setup.sh` will:
1. Detect the OS
2. Install all packages via Homebrew (macOS) or apt + install scripts (Linux)
3. Run `stow --restow` for each package listed in `packages.config`, skipping those not applicable to the current OS
4. Install SDKMAN, TPM (Tmux Plugin Manager), and the `gh copilot` extension (if authenticated)
5. Apply Ollama Modelfiles (if ollama is installed)

The script is idempotent — safe to run multiple times.

---

## Installation Details

### macOS

All tools are installed via Homebrew:

- **Formulas:** git, neovim, tmux, curl, stow, fish, starship, eza, bat, fzf, lazygit, lazydocker, gh, go, mongosh, tree-sitter, rustup, posting, zoxide, glow, cmake, pipx, biome
- **Casks:** font-hack-nerd-font, taproom
- **SST Tap:** opencode
- **Brew:** ollama
- **Cargo:** himalaya (`cargo install himalaya --features oauth2`), minesweep, rebels, cfspeedtest, eilmeldung
- **pipx:** spotui

### Linux

| Tool              | Method                              |
|-------------------|-------------------------------------|
| git, tmux, curl, stow, fish, gpg, wget, bat, fzf, gh, pipx, zoxide, unzip, zip, build-essential, libclang-dev, zstd, libasound2-dev, cmake, perl, libssl-dev, pkg-config, libxml2-dev, libsqlite3-dev | apt |
| go                | go.dev binary release               |
| neovim            | GitHub releases binary              |
| lazygit           | GitHub releases binary              |
| lazydocker        | GitHub releases binary              |
| glow              | GitHub releases binary              |
| biome             | GitHub releases binary              |
| eza               | Official apt repo                   |
| starship          | Install script (starship.rs)        |
| font-hack-nerd-font | GitHub release zip (~/.local/share/fonts) |
| rust              | rustup.rs install script            |
| mongosh           | MongoDB GitHub releases binary      |
| tree-sitter-cli   | `cargo install tree-sitter-cli`     |
| himalaya          | `cargo install himalaya --features oauth2` |
| minesweep         | `cargo install minesweep`           |
| rebels            | `cargo install rebels`              |
| cfspeedtest | `cargo install cfspeedtest` |
| eilmeldung        | `cargo install eilmeldung`          |
| posting           | `pipx install posting`              |
| spotui            | `pipx install spotui`               |

### Both platforms (post-install)

- **SDKMAN** — curl installer (`https://get.sdkman.io`)
- **TPM** — git clone
- **oh-my-fish** — curl installer (`https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install`)
- **gh copilot** — `gh extension install github/gh-copilot` (requires `gh auth login` first)
- **claude-code** — npm only, installed manually (see below)
- **Ollama Modelfiles** — custom Modelfiles from `ollama/` are applied if ollama is available

---

## Manual Stow Usage

```bash
# Stow a single package
stow --dir=~/dotfiles --target="$HOME" fish

# Stow all packages
bash setup.sh

# Preview what stow would do (dry run)
stow --dir=~/dotfiles --target="$HOME" --simulate fish

# Restow after adding new files to a package
stow --dir=~/dotfiles --target="$HOME" --restow fish

# Remove a package
stow --dir=~/dotfiles --target="$HOME" --delete fish
```

---

## Post-Install

### Fish shell

Set Fish as the default shell:

```bash
# Add fish to /etc/shells if not already listed
echo "$(which fish)" | sudo tee -a /etc/shells

# Change default shell
chsh -s "$(which fish)"
```

### Tmux plugins

Inside a tmux session, press `Prefix + I` (capital i) to install plugins via TPM.

### Neovim

Start Neovim — Lazy.nvim will install all plugins automatically on first launch:

```bash
nvim
```

### Claude Code

`claude-code` is distributed via npm only and cannot be installed without it.
Install manually after setup:

```bash
npm install -g @anthropic-ai/claude-code
```

---

## Packages

OS assignments are defined in `packages.config`. `setup.sh` reads this file and skips
packages that do not apply to the current OS. To add a new package, create its directory
and add a line to `packages.config`.

| Package             | OS    | Description                                                         |
|---------------------|-------|---------------------------------------------------------------------|
| bat                 | both  | Cat clone with syntax highlighting                                  |
| biome               | both  | Fast formatter and linter for web projects (brew on macOS, GitHub release on Linux) |
| btop                | both  | Resource monitor                                                    |
| claude-code         | both  | Anthropic Claude CLI (manual: `npm install -g @anthropic-ai/claude-code`) |
| cfspeedtest| both  | Network speed test TUI (`cargo install`, alias: `speedtest`)        |
| copilot-cli         | both  | GitHub Copilot CLI (`gh copilot` extension)                         |
| eilmeldung          | both  | TUI RSS reader (`cargo install`, alias: `news`)                     |
| eza                 | both  | Modern ls replacement                                               |
| fish                | both  | Fish shell — aliases, functions, tmux auto-start                    |
| font-hack-nerd-font | both  | Hack Nerd Font (cask on macOS, GitHub release on Linux)             |
| fzf                 | both  | Fuzzy finder                                                        |
| go                  | both  | Go toolchain (brew on macOS, go.dev binary on Linux)                |
| glow                | both  | Terminal markdown renderer (brew on macOS, GitHub release on Linux) |
| himalaya            | macos | Terminal email client (`cargo install` with oauth2 feature)         |
| lazydocker          | both  | Terminal UI for Docker                                              |
| lazygit             | both  | Terminal UI for git                                                 |
| minesweep-rs        | both  | Terminal minesweeper (`cargo install minesweep`, alias: `mines`)    |
| mongosh             | both  | MongoDB Shell (brew on macOS, binary release on Linux)              |
| neofetch            | both  | System info display                                                 |
| nvim                | both  | Neovim — Lazy.nvim, LSP, Treesitter, Copilot, onedarkpro theme      |
| ollama              | macos | Local LLM runtime + custom Modelfiles                               |
| omf                 | both  | Oh My Fish framework — installed via curl, config stowed from `omf/` |
| opencode            | macos | AI coding assistant (SST tap)                                       |
| posting             | both  | TUI HTTP client — onedark theme (brew on macOS, pipx on Linux)      |
| rebels-in-the-sky   | both  | Terminal space game (`cargo install rebels`, alias: `rit`)          |
| rust                | both  | Rust toolchain (brew on macOS, rustup on Linux)                     |
| sdkman              | both  | SDK manager for JVM tools — Java, Kotlin, Gradle (curl installer)   |
| spotui              | both  | Spotify TUI (`pipx install spotui`, alias: `spot`)                  |
| sshtron             | both  | Multiplayer tron over SSH (alias only: `tron`)                      |
| starship            | both  | Cross-shell prompt                                                  |
| stow                | both  | Symlink manager used to deploy dotfiles                             |
| taproom             | macos | Homebrew GUI (cask)                                                 |
| tmux                | both  | Terminal multiplexer — TPM, onedarkpro color palette                |
| tree-sitter-cli     | both  | Tree-sitter CLI (brew on macOS, `cargo install` on Linux)           |
| zoxide              | both  | Smart directory jumper (brew on macOS, apt on Linux)                |

---

## Updating

```bash
cd ~/dotfiles
git pull

# Re-stow to pick up any new files
bash setup.sh

# Update Neovim plugins
nvim --headless "+Lazy! sync" +qa

# Update Tmux plugins
# Inside tmux: Prefix + U
```

---

## Color Theme

All tools use the [onedarkpro](https://github.com/olimorris/onedarkpro.nvim) `onedark_vivid` palette as the single source of truth:

| Color  | Hex       | Usage                                                      |
|--------|-----------|------------------------------------------------------------|
| red    | `#ef596f` | Lualine Replace mode, tmux PREFIX indicator                |
| yellow | `#e5c07b` | Lualine Command mode, tmux window activity                 |
| green  | `#89ca78` | Lualine Insert mode, tmux session name                     |
| cyan   | `#2bbac5` | Lualine z-section, tmux clock + copy-mode selection        |
| blue   | `#61afef` | Lualine Normal mode, tmux active window tab                |
| purple | `#d55fde` | Lualine Visual mode, tmux active pane border               |

### Neovim

Syntax highlighting uses `olimorris/onedarkpro.nvim` with the `onedark_vivid` variant. Lualine pulls colors at runtime via `require("onedarkpro.helpers").get_colors()` — no hardcoded hex values. The statusline indicator changes color per Vim mode.

### Tmux

Status bar: session name (green) on the left, clock + optional PREFIX indicator (red) on the right. Active pane border is purple, copy-mode selection is cyan.

---

## Key Bindings Reference

### Tmux (prefix: Ctrl+s)

**Panes**

| Binding            | Action                      |
|--------------------|-----------------------------|
| `Prefix + +`       | Split pane horizontally     |
| `Prefix + -`       | Split pane vertically       |
| `Prefix + h/j/k/l` | Navigate panes (Vim-style)  |
| `Alt + arrows`     | Navigate panes (no prefix)  |
| `Prefix + z`       | Zoom pane (toggle fullscreen)|
| `Prefix + x`       | Kill pane                   |

**Windows**

| Binding          | Action                  |
|------------------|-------------------------|
| `Prefix + t`     | New window              |
| `Prefix + ,`     | Rename window           |
| `Prefix + 1-9`   | Switch to window by index |
| `Prefix + n/p`   | Next / previous window  |
| `Prefix + &`     | Kill window             |

**Sessions**

| Binding          | Action                  |
|------------------|-------------------------|
| `Prefix + d`     | Detach session          |
| `Prefix + s`     | List sessions           |
| `Prefix + $`     | Rename session          |

**Copy mode**

| Binding          | Action                  |
|------------------|-------------------------|
| `Prefix + [`     | Enter copy mode         |
| `q`              | Exit copy mode          |
| `v`              | Begin selection (vi)    |
| `y`              | Copy selection (vi)     |
| `Prefix + ]`     | Paste buffer            |

**Other**

| Binding          | Action                        |
|------------------|-------------------------------|
| `Prefix + r`     | Reload tmux config            |
| `Prefix + I`     | Install TPM plugins           |
| `Prefix + U`     | Update TPM plugins            |

### Fish

**Keybindings**

| Binding      | Action                                      |
|--------------|---------------------------------------------|
| `Ctrl+R`     | Fuzzy history search (fzf)                  |
| `Ctrl+T`     | Fuzzy file search — insert path (fzf)       |
| `Alt+C`      | Fuzzy directory jump (fzf)                  |
| `Alt+Z`      | Interactive zoxide jump (`zi`)              |
| `Alt+Ctrl+R` | Reload fish + tmux config                   |

**Functions**

| Command       | Description                                        |
|---------------|----------------------------------------------------|
| `g`           | `lazygit` — only inside a git repo, hint otherwise |
| `mkcd <path>` | `mkdir -p` + `cd` in one step                      |
| `dots`        | Jump to `~/dotfiles` and show `git status --short` |

**Aliases — General**

| Alias  | Expands to                                      |
|--------|-------------------------------------------------|
| `c`    | `clear`                                         |
| `l`    | `eza --long --header --all --color=auto`        |
| `tree` | `eza --tree --long --header --all --color=auto` |
| `v`    | `nvim`                                          |
| `d`    | `lazydocker`                                    |
| `q`    | `exit`                                          |

**Aliases — Dev Tools**

| Alias  | Expands to              |
|--------|-------------------------|
| `cat`  | `bat --paging=never`    |
| `gl`   | `glow`                  |
| `post` | `posting`               |

**Aliases — Network / Media / Games**

| Alias       | Expands to                    |
|-------------|-------------------------------|
| `speedtest` | `cfspeedtest`                 |
| `spot`      | `spotui`                      |
| `news`      | `eilmeldung`                  |
| `mines`     | `minesweep`                   |
| `rit`       | `rebels`                      |
| `tron`      | `ssh sshtron.zachlatta.com`   |

---

## License

Use freely for your own setup.
