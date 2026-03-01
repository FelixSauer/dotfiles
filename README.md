# dotfiles

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
├── .gitignore
│
├── btop/
│   └── .config/btop/
│       └── btop.conf
│
├── fish/
│   └── .config/fish/
│       ├── config.fish
│       ├── functions/
│       └── conf.d/
│
├── lazygit/
│   └── .config/lazygit/
│       └── config.yml
│
├── neofetch/
│   └── .config/neofetch/
│       └── config.conf
│
├── nvim/
│   └── .config/nvim/
│       ├── init.lua
│       └── lua/
│           ├── core/
│           └── plugins/
│
├── omf/
│   └── .config/omf/
│
├── starship/
│   └── .config/
│       └── starship.toml
│
├── posting/
│   ├── .config/posting/
│   │   └── config.yaml
│   └── .local/share/posting/
│       └── themes/
│           └── atom-one-dark.yaml
│
└── tmux/
    └── .config/tmux/
        ├── tmux.conf
        └── plugins/
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
4. Install SDKMAN, TPM (Tmux Plugin Manager), and the `gh copilot` extension

The script is idempotent — safe to run multiple times.

---

## Installation Details

### macOS

All tools are installed via Homebrew:

- **Formulas:** git, neovim, tmux, curl, stow, fish, starship, eza, bat, fzf, lazygit, lazydocker, gh, go, mongosh, tree-sitter, rustup, himalaya, posting, zoxide, glow
- **Casks:** font-hack-nerd-font, taproom

### Linux

| Tool              | Method                              |
|-------------------|-------------------------------------|
| git, tmux, curl, stow, fish, gpg, wget, bat, fzf, gh, pipx, zoxide | apt |
| go                | go.dev binary release               |
| neovim            | GitHub releases binary              |
| lazygit           | GitHub releases binary              |
| lazydocker        | GitHub releases binary              |
| glow              | GitHub releases binary              |
| eza               | Official apt repo                   |
| starship          | Install script (starship.rs)        |
| font-hack-nerd-font | GitHub release zip (~/.local/share/fonts) |
| rust              | rustup.rs install script            |
| mongosh           | MongoDB GitHub releases binary      |
| tree-sitter-cli   | `cargo install tree-sitter-cli`     |
| himalaya          | `cargo install himalaya`            |
| posting           | `pipx install posting`              |

### Both platforms (post-install)

- **SDKMAN** — curl installer (`https://get.sdkman.io`)
- **TPM** — git clone
- **gh copilot** — `gh extension install github/gh-copilot`
- **claude-code** — npm only, installed manually (see below)

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

| Package             | OS   | Description                                                         |
|---------------------|------|---------------------------------------------------------------------|
| bat                 | both | Cat clone with syntax highlighting                                  |
| btop                | both | Resource monitor                                                    |
| claude-code         | both | Anthropic Claude CLI (manual: `npm install -g @anthropic-ai/claude-code`) |
| copilot-cli         | both | GitHub Copilot CLI (`gh copilot` extension)                         |
| eza                 | both | Modern ls replacement                                               |
| fish                | both | Fish shell — aliases, functions, tmux auto-start                    |
| font-hack-nerd-font | both | Hack Nerd Font (cask on macOS, GitHub release on Linux)             |
| fzf                 | both | Fuzzy finder                                                        |
| go                  | both | Go toolchain (brew on macOS, go.dev binary on Linux)                |
| himalaya            | both | Terminal email client (brew on macOS, `cargo install` on Linux)     |
| lazydocker          | both | Terminal UI for Docker                                              |
| lazygit             | both | Terminal UI for git                                                 |
| mongosh             | both | MongoDB Shell (brew on macOS, binary release on Linux)              |
| neofetch            | both | System info display                                                 |
| nvim                | both | Neovim — Lazy.nvim, LSP, Treesitter, Copilot                       |
| omf                 | both | Oh My Fish framework config                                         |
| rust                | both | Rust toolchain (brew on macOS, rustup on Linux)                     |
| sdkman              | both | SDK manager for JVM tools — Java, Kotlin, Gradle (curl installer)   |
| starship            | both | Cross-shell prompt                                                  |
| glow                | both | Terminal markdown renderer (brew on macOS, GitHub release on Linux) |
| posting             | both | TUI HTTP client — Atom One Dark theme (brew on macOS, pipx on Linux)|
| stow                | both | Symlink manager used to deploy dotfiles                             |
| taproom             | macos| Homebrew GUI (cask)                                                 |
| tmux                | both | Terminal multiplexer — TPM, Atom One Dark theme                     |
| tree-sitter-cli     | both | Tree-sitter CLI (brew on macOS, `cargo install` on Linux)           |
| zoxide              | both | Smart directory jumper (brew on macOS, apt on Linux)                |

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

## Key Bindings Reference

### Tmux (prefix: Ctrl+a)

| Binding              | Action                     |
|----------------------|----------------------------|
| `Prefix + +`         | Split pane horizontally    |
| `Prefix + -`         | Split pane vertically      |
| `Prefix + h/j/k/l`   | Navigate panes (Vim-style) |
| `Alt + arrows`       | Navigate panes (no prefix) |
| `Prefix + r`         | Reload tmux config         |
| `Prefix + I`         | Install TPM plugins        |

### Fish

| Alias    | Expands to                                          |
|----------|-----------------------------------------------------|
| `c`      | `clear`                                             |
| `l`      | `eza --long --header --all --color=auto`            |
| `tree`   | `eza --tree --long --header --all --color=auto`     |
| `v`      | `nvim`                                              |
| `g`      | `lazygit`                                           |
| `d`      | `lazydocker`                                        |
| `k`      | `k9s`                                               |
| `q`      | `exit`                                              |
| `Alt+Cr` | Reload fish + tmux config                           |

---

## License

Use freely for your own setup.
