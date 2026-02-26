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
│
├── omf/
│   └── .config/omf/
│
├── starship/
│   └── .config/
│       └── starship.toml
│
└── tmux/
    └── .config/tmux/
        └── tmux.conf
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
and add a line to `packages.config`. The file uses Stow's terminology: each top-level
directory is a package.

| Package             | OS    | Description                                                        |
|---------------------|-------|--------------------------------------------------------------------|
| bat                 | both  | Cat clone with syntax highlighting                                 |
| btop                | both  | Resource monitor                                                   |
| claude-code         | both  | Anthropic Claude CLI (manual: `npm install -g @anthropic-ai/claude-code`) |
| copilot-cli         | both  | GitHub Copilot CLI (`gh copilot` extension)                        |
| eza                 | both  | Modern ls replacement                                              |
| fish                | both  | Fish shell — aliases, functions, tmux auto-start                   |
| font-hack-nerd-font | both  | Hack Nerd Font (cask on macOS, GitHub release on Linux)            |
| fzf                 | both  | Fuzzy finder                                                       |
| go                  | both  | Go toolchain (brew on macOS, go.dev binary on Linux)               |
| himalaya            | both  | Terminal email client (brew on macOS, `cargo install` on Linux)    |
| lazydocker          | both  | Terminal UI for Docker                                             |
| lazygit             | both  | Terminal UI for git                                                |
| mongosh             | both  | MongoDB Shell (brew on macOS, binary release on Linux)             |
| neofetch            | both  | System info display                                                |
| nvim                | both  | Neovim — Lazy.nvim, LSP, Treesitter, Copilot                      |
| omf                 | both  | Oh My Fish framework config                                        |
| rust                | both  | Rust toolchain (brew on macOS, rustup on Linux)                    |
| sdkman              | both  | SDK manager for JVM tools — Java, Kotlin, Gradle (curl installer)  |
| starship            | both  | Cross-shell prompt                                                 |
| stow                | both  | Symlink manager used to deploy dotfiles                            |
| tmux                | both  | Terminal multiplexer — TPM, Atom One Dark theme                    |
| tree-sitter-cli     | both  | Tree-sitter CLI (brew on macOS, `cargo install` on Linux)          |

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

| Binding            | Action                      |
|--------------------|-----------------------------|
| `Prefix + +`       | Split pane horizontally     |
| `Prefix + -`       | Split pane vertically       |
| `Prefix + h/j/k/l` | Navigate panes (Vim-style)  |
| `Alt + arrows`     | Navigate panes (no prefix)  |
| `Prefix + r`       | Reload tmux config          |
| `Prefix + I`       | Install TPM plugins         |

### Fish

| Alias    | Expands to                           |
|----------|--------------------------------------|
| `c`      | `clear`                              |
| `l`      | `eza --long --header --all`          |
| `V`      | `nvim`                               |
| `G`      | `lazygit`                            |
| `q`      | `exit`                               |
| `config` | `cd ~/.config/`                      |
| `Alt+Cr` | Reload fish + tmux config            |

---

## License

Use freely for your own setup.
