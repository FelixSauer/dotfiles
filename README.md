
```ansi
[38;2;43;186;197m    _     _    __ _ _
[38;2;97;175;239m __| |___| |_ / _(_) |___ ___
[38;2;97;175;239m/ _` / _ \  _|  _| | / -_|_-<
[38;2;213;95;222m\__,_\___/\__|_| |_|_\___/__/[0m
```

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Supports macOS and Linux.

---

## Setup

```bash
git clone https://github.com/<your-username>/dotfiles.git ~/dotfiles
cd ~/dotfiles && bash setup.sh
```

`setup.sh` detects the OS, installs all packages, stows configs, and runs post-install steps. Safe to re-run.

An interactive package selector launches before installation. Use `j/k` or arrow keys to navigate, `space` to toggle, `a`/`n` for all/none, `tab` to switch to the Install/Cancel buttons.

---

## Structure

Each package directory mirrors `$HOME` — Stow creates symlinks automatically.

```
dotfiles/
├── setup.sh          # install + stow
├── packages.config   # OS-specific assignments
│
├── fish/             # example: single config file
│   └── .config/fish/
│       └── config.fish
│
└── nvim/             # example: nested structure
    └── .config/nvim/
        ├── init.lua
        └── lua/
```

`dotfiles/fish/.config/fish/config.fish` → `~/.config/fish/config.fish`

**Stow commands**

```bash
stow fish                    # link a package
stow --simulate fish         # dry run
stow --restow fish           # re-link after changes
stow --delete fish           # remove symlinks
```

---

## Packages

`OS`: `both` = macOS + Linux, `mac` = macOS only.

| Package             | OS   | Description                                                       |
|---------------------|------|-------------------------------------------------------------------|
| bat                 | both | Cat clone with syntax highlighting                                |
| biome               | both | Fast formatter and linter for web projects                        |
| btop                | both | Resource monitor                                                  |
| cfspeedtest         | both | Cloudflare speed test (`alias: speedtest`)                        |
| claude-code         | both | Anthropic Claude CLI (`npm install -g @anthropic-ai/claude-code`) |
| copilot-cli         | both | GitHub Copilot CLI (`gh copilot` extension)                       |
| eilmeldung          | both | TUI RSS reader (`alias: news`)                                    |
| eza                 | both | Modern ls replacement                                             |
| fish                | both | Fish shell — aliases, functions, tmux auto-start                  |
| font-hack-nerd-font | both | Hack Nerd Font                                                    |
| fzf                 | both | Fuzzy finder                                                      |
| go                  | both | Go toolchain                                                      |
| glow                | both | Terminal markdown renderer (`alias: gl`)                          |
| lazydocker          | both | Terminal UI for Docker (`alias: d`)                               |
| lazygit             | both | Terminal UI for git (`alias: g`)                                  |
| minesweep-rs        | both | Terminal minesweeper (`alias: mines`)                             |
| mongosh             | both | MongoDB Shell                                                     |
| neofetch            | both | System info display                                               |
| nvim                | both | Neovim — Lazy.nvim, LSP, Treesitter, onedarkpro theme             |
| omf                 | both | Oh My Fish — fish framework (curl installer)                      |
| ollama              | mac  | Local LLM runtime + custom Modelfiles                             |
| opencode            | mac  | AI coding assistant (SST tap)                                     |
| posting             | both | TUI HTTP client (`alias: post`)                                   |
| rebels-in-the-sky   | both | Terminal space game (`alias: rit`)                                |
| rust                | both | Rust toolchain                                                    |
| sdkman              | both | SDK manager for JVM tools (curl installer)                        |
| spotui              | both | Spotify TUI (`alias: spot`)                                       |
| sshtron             | both | Multiplayer tron over SSH (`alias: tron`)                         |
| starship            | both | Cross-shell prompt                                                |
| stow                | both | Symlink manager                                                   |
| taproom             | mac  | Homebrew GUI (cask)                                               |
| tmux                | both | Terminal multiplexer — TPM, onedarkpro palette                    |
| tree-sitter-cli     | both | Tree-sitter CLI                                                   |
| zoxide              | both | Smart directory jumper                                            |

---

## Installation

### macOS

All packages via Homebrew. `bash setup.sh` handles everything.

| Method   | Packages                                                                                                    |
|----------|-------------------------------------------------------------------------------------------------------------|
| Formulas | git, neovim, tmux, stow, fish, starship, eza, bat, fzf, lazygit, lazydocker, gh, go, mongosh, tree-sitter, rustup, posting, zoxide, glow, cmake, pipx, biome |
| Casks    | font-hack-nerd-font, taproom                                                                                |
| SST Tap  | opencode                                                                                                    |
| Cargo    | minesweep, rebels, cfspeedtest, eilmeldung                                                                 |
| pipx     | spotui                                                                                                      |

### Linux

| Tool                | Method                                              |
|---------------------|-----------------------------------------------------|
| Core tools          | apt (git, tmux, curl, stow, fish, bat, fzf, gh, pipx, zoxide, ...) |
| go                  | go.dev binary                                       |
| neovim              | GitHub releases binary                              |
| lazygit             | GitHub releases binary                              |
| lazydocker          | GitHub releases binary                              |
| glow                | GitHub releases binary                              |
| biome               | GitHub releases binary                              |
| eza                 | Official apt repo                                   |
| starship            | starship.rs install script                          |
| font-hack-nerd-font | GitHub release zip (`~/.local/share/fonts`)         |
| rust                | rustup.rs install script                            |
| mongosh             | MongoDB GitHub releases binary                      |
| tree-sitter-cli     | `cargo install tree-sitter-cli`                     |
| minesweep           | `cargo install minesweep`                           |
| rebels              | `cargo install rebels`                              |
| cfspeedtest         | `cargo install cfspeedtest`                         |
| eilmeldung          | `cargo install eilmeldung`                          |
| posting             | `pipx install posting`                              |
| spotui              | `pipx install spotui`                               |

### Post-install (both platforms)

| Tool          | Method                                                   |
|---------------|----------------------------------------------------------|
| oh-my-fish    | curl installer                                           |
| SDKMAN        | curl installer (`https://get.sdkman.io`)                 |
| TPM           | git clone                                                |
| gh copilot    | `gh extension install github/gh-copilot`                 |
| claude-code   | `npm install -g @anthropic-ai/claude-code` (manual)      |
| Ollama models | applied from `ollama/*.Modelfile` if ollama is present   |

---

## Post-Setup

**Fish as default shell**
```bash
echo "$(which fish)" | sudo tee -a /etc/shells
chsh -s "$(which fish)"
```

**Neovim** — plugins install automatically on first launch via Lazy.nvim.

**Tmux** — press `Prefix + I` inside a session to install TPM plugins.

**Claude Code**
```bash
npm install -g @anthropic-ai/claude-code
```

**Update everything**
```bash
cd ~/dotfiles && git pull && bash setup.sh
nvim --headless "+Lazy! sync" +qa   # Neovim plugins
# Tmux plugins: Prefix + U inside tmux
```

---

## Key Bindings

### German keyboard (QWERTZ)

Kitty is configured with `macos_option_as_alt left`:

- **Left Option** = Alt/Meta modifier — used by tmux, nvim, and fish bindings
- **Right Option** = macOS special characters — types `[` `]` `{` `}` etc. as usual

This splits the two Option keys so terminal shortcuts and German character input coexist without conflict.

---

### Tmux (prefix: Ctrl+s)

**Panes**

| Binding              | Action                     |
|----------------------|----------------------------|
| `Prefix + +`         | Split horizontally         |
| `Prefix + -`         | Split vertically           |
| `Prefix + h/j/k/l`   | Navigate panes (Vim-style) |
| `Alt + h/j/k/l`      | Navigate panes (no prefix) |
| `Alt + arrows`       | Navigate panes (no prefix) |
| `Prefix + z`         | Zoom pane                  |
| `Prefix + x`         | Kill pane                  |

**Windows**

| Binding          | Action                  |
|------------------|-------------------------|
| `Shift + Tab`    | Next window (no prefix) |
| `Prefix + t`     | New window              |
| `Prefix + ,`     | Rename window           |
| `Prefix + 1-9`   | Switch to window        |
| `Prefix + n/p`   | Next / previous window  |
| `Prefix + &`     | Kill window             |

**Sessions**

| Binding          | Action          |
|------------------|-----------------|
| `Prefix + d`     | Detach          |
| `Prefix + s`     | List sessions   |
| `Prefix + $`     | Rename session  |

**Copy mode**

| Binding          | Action          |
|------------------|-----------------|
| `Prefix + [`     | Enter copy mode |
| `v`              | Begin selection |
| `y`              | Copy selection  |
| `Prefix + ]`     | Paste buffer    |
| `q`              | Exit copy mode  |

**Other**

| Binding          | Action                  |
|------------------|-------------------------|
| `Prefix + r`     | Reload config           |
| `Prefix + I`     | Install TPM plugins     |
| `Prefix + U`     | Update TPM plugins      |

---

### Fish

**Keybindings**

| Binding        | Action                                      |
|----------------|---------------------------------------------|
| `Ctrl+R`       | Fuzzy history search (fzf)                  |
| `Ctrl+T`       | Fuzzy file search — inserts path (fzf)      |
| `Alt+C`        | Fuzzy directory jump (fzf)                  |
| `Alt+Z`        | Interactive zoxide (`zi`)                   |
| `Alt+Ctrl+R`   | Reload fish + tmux config                   |

**Functions**

| Command       | Description                                         |
|---------------|-----------------------------------------------------|
| `g`           | `lazygit` — checks for git repo first               |
| `mkcd <path>` | `mkdir -p` + `cd`                                   |
| `dots`        | Jump to `~/dotfiles`, show `git status --short`     |

**Aliases**

| Alias       | Expands to                                      |
|-------------|-------------------------------------------------|
| `c`         | `clear`                                         |
| `l`         | `eza --long --header --all --color=auto`        |
| `tree`      | `eza --tree --long --header --all --color=auto` |
| `v`         | `nvim`                                          |
| `d`         | `lazydocker`                                    |
| `q`         | `exit`                                          |
| `cat`       | `bat --paging=never`                            |
| `gl`        | `glow`                                          |
| `post`      | `posting`                                       |
| `speedtest` | `cfspeedtest`                                   |
| `spot`      | `spotui`                                        |
| `news`      | `eilmeldung`                                    |
| `mines`     | `minesweep`                                     |
| `rit`       | `rebels`                                        |
| `tron`      | `ssh sshtron.zachlatta.com`                     |

---

### Neovim (leader: Space)

**General**

| Binding       | Action                  |
|---------------|-------------------------|
| `<leader>ww`  | Save                    |
| `<leader>wq`  | Save and quit           |
| `<leader>qq`  | Quit without saving     |
| `Cmd+S`       | Save                    |
| `Cmd+X`       | Close buffer            |
| `gx`          | Open URL under cursor   |

**Splits**

| Binding        | Action                        |
|----------------|-------------------------------|
| `<leader>sv`   | Split vertically              |
| `<leader>sh`   | Split horizontally            |
| `<leader>se`   | Equalize split widths         |
| `<leader>sx`   | Close split                   |
| `<leader>sj/k` | Resize height shorter/taller  |
| `<leader>sl`   | Resize width wider            |
| `<leader>sm`   | Toggle maximize split         |

**Tabs**

| Binding       | Action          |
|---------------|-----------------|
| `<leader>to`  | New tab         |
| `<leader>tx`  | Close tab       |
| `<leader>tn`  | Next tab        |
| `<leader>tp`  | Previous tab    |

**File Tree (Neo-tree)**

| Binding       | Action               |
|---------------|----------------------|
| `<leader>ee`  | Toggle file tree     |

**Telescope**

| Binding       | Action                            |
|---------------|-----------------------------------|
| `<leader>ff`  | Find files                        |
| `<leader>fg`  | Live grep                         |
| `<leader>fb`  | Open buffers                      |
| `<leader>fh`  | Help tags                         |
| `<leader>fs`  | Fuzzy find in current buffer      |
| `<leader>fo`  | LSP document symbols              |
| `<leader>fi`  | LSP incoming calls                |
| `<leader>fm`  | Find functions/methods            |
| `<leader>ft`  | Grep in current nvim-tree node    |

**Harpoon**

| Binding        | Action                   |
|----------------|--------------------------|
| `<leader>ha`   | Add file                 |
| `<leader>hh`   | Toggle quick menu        |
| `<leader>h1-9` | Navigate to file 1-9     |

**LSP**

| Binding       | Action                    |
|---------------|---------------------------|
| `<leader>gg`  | Hover docs                |
| `<leader>gd`  | Go to definition          |
| `<leader>gD`  | Go to declaration         |
| `<leader>gi`  | Go to implementation      |
| `<leader>gt`  | Go to type definition     |
| `<leader>gr`  | References                |
| `<leader>gs`  | Signature help            |
| `<leader>rr`  | Rename symbol             |
| `<leader>gf`  | Format (normal + visual)  |
| `<leader>ga`  | Code action               |
| `<leader>gl`  | Open diagnostics float    |
| `<leader>gp`  | Previous diagnostic       |
| `<leader>gn`  | Next diagnostic           |
| `Ctrl+Space`  | Trigger completion        |

**Diff / Merge**

| Binding       | Action                         |
|---------------|--------------------------------|
| `<leader>cc`  | Put diff to other              |
| `<leader>cj`  | Get diff from left (local)     |
| `<leader>ck`  | Get diff from right (remote)   |
| `<leader>cn`  | Next diff hunk                 |
| `<leader>cp`  | Previous diff hunk             |

**Quickfix**

| Binding       | Action                    |
|---------------|---------------------------|
| `<leader>qo`  | Open quickfix list        |
| `<leader>qf`  | First item                |
| `<leader>qn`  | Next item                 |
| `<leader>qp`  | Previous item             |
| `<leader>ql`  | Last item                 |
| `<leader>qc`  | Close quickfix list       |

**Debugging (DAP)**

| Binding        | Action                       |
|----------------|------------------------------|
| `<leader>bb`   | Toggle breakpoint            |
| `<leader>bc`   | Conditional breakpoint       |
| `<leader>bl`   | Log point                    |
| `<leader>br`   | Clear breakpoints            |
| `<leader>ba`   | List breakpoints             |
| `<leader>dc`   | Continue                     |
| `<leader>dj`   | Step over                    |
| `<leader>dk`   | Step into                    |
| `<leader>do`   | Step out                     |
| `<leader>dd`   | Disconnect + close UI        |
| `<leader>dt`   | Terminate + close UI         |
| `<leader>dr`   | Toggle REPL                  |
| `<leader>dl`   | Run last                     |
| `<leader>di`   | Hover variable               |
| `<leader>d?`   | Scopes float                 |
| `<leader>df`   | Telescope DAP frames         |
| `<leader>dh`   | Telescope DAP commands       |
| `<leader>de`   | Telescope diagnostics (errors)|

**Navigation**

| Binding   | Action            |
|-----------|-------------------|
| `Alt+J`   | Next paragraph    |
| `Alt+K`   | Previous paragraph|

---

## Theme

All tools use the [onedarkpro](https://github.com/olimorris/onedarkpro.nvim) `onedark_vivid` palette as a single source of truth.

| Color  | Hex       | Used in                                                        |
|--------|-----------|----------------------------------------------------------------|
| red    | `#ef596f` | Lualine Replace mode, tmux PREFIX indicator, setup.sh errors  |
| yellow | `#e5c07b` | Lualine Command mode, tmux window activity, setup.sh warnings |
| green  | `#89ca78` | Lualine Insert mode, tmux session name, setup.sh ok           |
| cyan   | `#2bbac5` | Lualine z-section, tmux clock + copy mode, setup.sh banner    |
| blue   | `#61afef` | Lualine Normal mode, tmux active window, setup.sh banner      |
| purple | `#d55fde` | Lualine Visual mode, tmux active pane border, setup.sh banner |

Neovim uses `olimorris/onedarkpro.nvim` (`onedark_vivid`). Lualine pulls colors at runtime via `require("onedarkpro.helpers").get_colors()` — no hardcoded hex values.

Tmux status bar: session name (green) left, clock + PREFIX indicator (red) right. Active pane border purple, copy-mode selection cyan.

`setup.sh` uses the same hex values as truecolor ANSI codes. Banner gradient: cyan → blue → purple.

---

## License

Use freely for your own setup.
