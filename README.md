```
    _     _    __ _ _
 __| |___| |_ / _(_) |___ ___
/ _` / _ \  _|  _| | / -_|_-<
\__,_\___/\__|_| |_|_\___/__/
```

Personal dotfiles for macOS and Linux. Managed with [GNU Stow](https://www.gnu.org/software/stow/), installed via a single script. Covers shell, editor, multiplexer, and CLI tools — all themed consistently with the onedarkpro palette.

---

## Install

**One-liner** — clones and installs everything non-interactively:

```bash
curl -fsSL https://raw.githubusercontent.com/FelixSauer/dotfiles/main/install.sh | bash
```

**Interactive** — choose which packages to install or remove:

```bash
git clone https://github.com/FelixSauer/dotfiles.git ~/dotfiles
bash ~/dotfiles/setup.sh
```

The interactive TUI lets you toggle packages with `j/k`, `space`, `a`/`n` for all/none, and `tab` to reach Apply/Cancel. Deselecting an installed package removes it. Both modes are safe to re-run.

**Update:**

```bash
cd ~/dotfiles && git pull && bash install.sh
nvim --headless "+Lazy! sync" +qa
```

---

## Structure

Each directory mirrors `$HOME` — Stow creates symlinks automatically.

```
dotfiles/
├── install.sh          # curl-installable bootstrap (non-interactive)
├── setup.sh            # interactive installer
├── packages.config     # OS-specific stow assignments
│
├── fish/               # shell config, aliases, functions, keybindings
├── nvim/               # Neovim: Lazy.nvim, LSP, Treesitter, DAP
├── tmux/               # tmux config + TPM
├── starship/           # cross-shell prompt
└── ...
```

Stow commands:

```bash
stow fish               # link a package
stow --simulate fish    # dry run
stow --restow fish      # re-link after changes
stow --delete fish      # remove symlinks
```

---

## Packages

| Package             | OS   | Description                                            |
|---------------------|------|--------------------------------------------------------|
| bat                 | both | Cat clone with syntax highlighting                     |
| biome               | both | Fast formatter and linter for web projects             |
| cfspeedtest         | both | Cloudflare speed test                                  |
| claude-code         | both | Anthropic Claude CLI (npm, manual)                     |
| copilot-cli         | both | GitHub Copilot CLI (`gh copilot` extension)            |
| direnv              | both | Per-directory environment variables                    |
| eilmeldung          | both | TUI RSS reader                                         |
| eza                 | both | Modern `ls` replacement                                |
| fish                | both | Fish shell with aliases, functions, tmux auto-start    |
| fisher              | both | Fish plugin manager (pnpm-shell-completion included)   |
| font-hack-nerd-font | both | Hack Nerd Font                                         |
| fzf                 | both | Fuzzy finder                                           |
| gh                  | both | GitHub CLI                                             |
| go                  | both | Go toolchain                                           |
| lazydocker          | both | Terminal UI for Docker                                 |
| lazygit             | both | Terminal UI for git                                    |
| minesweep           | both | Terminal minesweeper                                   |
| mongosh             | both | MongoDB Shell                                          |
| neovim              | both | Neovim with Lazy.nvim, LSP, Treesitter, onedarkpro     |
| oh-my-fish          | both | Fish shell framework (curl installer)                  |
| ollama              | mac  | Local LLM runtime + custom Modelfiles                  |
| opencode            | mac  | AI coding assistant (SST tap)                          |
| posting             | both | TUI HTTP client                                        |
| rebels-in-the-sky   | both | Terminal space game                                    |
| rust / cargo        | both | Rust toolchain via rustup                              |
| sdkman              | both | SDK manager for JVM tools (curl installer)             |
| spotui              | both | Spotify TUI                                            |
| starship            | both | Cross-shell prompt                                     |
| taproom             | mac  | Homebrew GUI (cask)                                    |
| tmux                | both | Terminal multiplexer with TPM                          |
| tree-sitter-cli     | both | Tree-sitter CLI                                        |
| zoxide              | both | Smart directory jumper                                 |

---

## Post-Setup

**Fish as default shell:**

```bash
echo "$(which fish)" | sudo tee -a /etc/shells
chsh -s "$(which fish)"
```

**Neovim** — plugins install automatically on first launch via Lazy.nvim.

**Tmux** — press `Prefix + I` inside a session to install TPM plugins.

**Claude Code:**

```bash
npm install -g @anthropic-ai/claude-code
```

---

## Key Bindings

### German keyboard (QWERTZ)

Kitty is configured with `macos_option_as_alt left`:

- **Left Option** — Alt/Meta modifier for tmux, nvim, and fish bindings
- **Right Option** — macOS special characters (`[` `]` `{` `}` etc.)

---

### Tmux (prefix: `Ctrl+s`)

**Panes**

| Binding            | Action                     |
|--------------------|----------------------------|
| `Prefix + +`       | Split horizontally         |
| `Prefix + -`       | Split vertically           |
| `Prefix + h/j/k/l` | Navigate panes (Vim-style) |
| `Alt + h/j/k/l`    | Navigate panes (no prefix) |
| `Alt + arrows`     | Navigate panes (no prefix) |
| `Prefix + z`       | Zoom pane                  |
| `Prefix + x`       | Kill pane                  |

**Pane resizing**

| Binding                    | Action                        |
|----------------------------|-------------------------------|
| `Ctrl+Shift+Left/Right`    | Resize pane left/right (1 col, no prefix) |
| `Ctrl+Shift+Up/Down`       | Resize pane up/down (1 row, no prefix)    |
| `Prefix + H/J/K/L`        | Resize pane (5 cols/rows, repeatable)     |
| `Prefix + Ctrl+o`          | Rotate panes in layout                    |

**Windows**

| Binding        | Action                  |
|----------------|-------------------------|
| `Shift + Tab`  | Next window (no prefix) |
| `Prefix + t`   | New window              |
| `Prefix + ,`   | Rename window           |
| `Prefix + 1-9` | Switch to window        |
| `Alt + 1-9`    | Switch to window        |
| `Prefix + n/p` | Next / previous window  |
| `Prefix + &`   | Kill window             |

**Sessions**

| Binding      | Action          |
|--------------|-----------------|
| `Prefix + d` | Detach          |
| `Prefix + s` | List sessions   |
| `Prefix + $` | Rename session  |

**Copy mode**

| Binding      | Action          |
|--------------|-----------------|
| `Prefix + [` | Enter copy mode |
| `v`          | Begin selection |
| `y`          | Copy selection  |
| `Prefix + ]` | Paste buffer    |
| `q`          | Exit copy mode  |

**Other**

| Binding      | Action              |
|--------------|---------------------|
| `Prefix + r` | Reload config       |
| `Prefix + I` | Install TPM plugins |
| `Prefix + U` | Update TPM plugins  |

---

### Fish

**Keybindings**

| Binding      | Action                             |
|--------------|------------------------------------|
| `Ctrl+R`     | Fuzzy history search (fzf)         |
| `Ctrl+T`     | Fuzzy file search — inserts path   |
| `Alt+C`      | Fuzzy directory jump (fzf)         |
| `Alt+Z`      | Interactive zoxide (`zi`)          |
| `Alt+Ctrl+R` | Reload fish + tmux config          |

**Functions**

| Command       | Description                                     |
|---------------|-------------------------------------------------|
| `g`           | `lazygit` — checks for git repo first           |
| `mkcd <path>` | `mkdir -p` + `cd`                               |
| `dots`        | Jump to `~/dotfiles`, show `git status --short` |

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
| `bat`       | `bat --paging=never`                            |
| `post`      | `posting`                                       |
| `speedtest` | `cfspeedtest`                                   |
| `spot`      | `spotui`                                        |
| `news`      | `eilmeldung`                                    |
| `mines`     | `minesweep`                                     |
| `rit`       | `rebels`                                        |
| `tron`      | `ssh sshtron.zachlatta.com`                     |

---

### Neovim (leader: `Space`)

**General**

| Binding      | Action                |
|--------------|-----------------------|
| `<leader>ww` | Save                  |
| `<leader>wq` | Save and quit         |
| `<leader>qq` | Quit without saving   |
| `Cmd+S`      | Save                  |
| `Cmd+X`      | Close buffer          |
| `gx`         | Open URL under cursor |

**Splits**

| Binding        | Action                       |
|----------------|------------------------------|
| `<leader>sv`   | Split vertically             |
| `<leader>sh`   | Split horizontally           |
| `<leader>se`   | Equalize split widths        |
| `<leader>sx`   | Close split                  |
| `<leader>sj/k` | Resize height shorter/taller |
| `<leader>sl`   | Resize width wider           |
| `<leader>sm`   | Toggle maximize split        |

**Tabs**

| Binding      | Action        |
|--------------|---------------|
| `<leader>to` | New tab       |
| `<leader>tx` | Close tab     |
| `<leader>tn` | Next tab      |
| `<leader>tp` | Previous tab  |

**File Tree (Neo-tree)**

| Binding      | Action           |
|--------------|------------------|
| `<leader>ee` | Toggle file tree |

**Telescope**

| Binding      | Action                         |
|--------------|--------------------------------|
| `<leader>ff` | Find files                     |
| `<leader>fg` | Live grep                      |
| `<leader>fb` | Open buffers                   |
| `<leader>fh` | Help tags                      |
| `<leader>fs` | Fuzzy find in current buffer   |
| `<leader>fo` | LSP document symbols           |
| `<leader>fi` | LSP incoming calls             |
| `<leader>fm` | Find functions/methods         |
| `<leader>ft` | Grep in current nvim-tree node |

**Harpoon**

| Binding        | Action               |
|----------------|----------------------|
| `<leader>ha`   | Add file             |
| `<leader>hh`   | Toggle quick menu    |
| `<leader>h1-9` | Navigate to file 1-9 |

**LSP**

| Binding      | Action                   |
|--------------|--------------------------|
| `<leader>gg` | Hover docs               |
| `<leader>gd` | Go to definition         |
| `<leader>gD` | Go to declaration        |
| `<leader>gi` | Go to implementation     |
| `<leader>gt` | Go to type definition    |
| `<leader>gr` | References               |
| `<leader>gs` | Signature help           |
| `<leader>rr` | Rename symbol            |
| `<leader>gf` | Format (normal + visual) |
| `<leader>ga` | Code action              |
| `<leader>gl` | Open diagnostics float   |
| `<leader>gp` | Previous diagnostic      |
| `<leader>gn` | Next diagnostic          |
| `Ctrl+Space` | Trigger completion       |

**Diff / Merge**

| Binding      | Action                       |
|--------------|------------------------------|
| `<leader>cc` | Put diff to other            |
| `<leader>cj` | Get diff from left (local)   |
| `<leader>ck` | Get diff from right (remote) |
| `<leader>cn` | Next diff hunk               |
| `<leader>cp` | Previous diff hunk           |

**Quickfix**

| Binding      | Action             |
|--------------|--------------------|
| `<leader>qo` | Open quickfix list |
| `<leader>qf` | First item         |
| `<leader>qn` | Next item          |
| `<leader>qp` | Previous item      |
| `<leader>ql` | Last item          |
| `<leader>qc` | Close quickfix     |

**Debugging (DAP)**

| Binding      | Action                        |
|--------------|-------------------------------|
| `<leader>bb` | Toggle breakpoint             |
| `<leader>bc` | Conditional breakpoint        |
| `<leader>bl` | Log point                     |
| `<leader>br` | Clear breakpoints             |
| `<leader>ba` | List breakpoints              |
| `<leader>dc` | Continue                      |
| `<leader>dj` | Step over                     |
| `<leader>dk` | Step into                     |
| `<leader>do` | Step out                      |
| `<leader>dd` | Disconnect + close UI         |
| `<leader>dt` | Terminate + close UI          |
| `<leader>dr` | Toggle REPL                   |
| `<leader>dl` | Run last                      |
| `<leader>di` | Hover variable                |
| `<leader>d?` | Scopes float                  |
| `<leader>df` | Telescope DAP frames          |
| `<leader>dh` | Telescope DAP commands        |
| `<leader>de` | Telescope diagnostics (errors)|

**Navigation**

| Binding | Action             |
|---------|--------------------|
| `Alt+J` | Next paragraph     |
| `Alt+K` | Previous paragraph |

---

## Theme

All tools use the [onedarkpro](https://github.com/olimorris/onedarkpro.nvim) `onedark_vivid` palette.

| Color  | Hex       | Used in                                                        |
|--------|-----------|----------------------------------------------------------------|
| red    | `#ef596f` | Lualine Replace mode, tmux PREFIX indicator, setup.sh errors  |
| yellow | `#e5c07b` | Lualine Command mode, tmux window activity, setup.sh warnings |
| green  | `#89ca78` | Lualine Insert mode, tmux session name, setup.sh ok           |
| cyan   | `#2bbac5` | Lualine z-section, tmux clock + copy mode, setup.sh banner    |
| blue   | `#61afef` | Lualine Normal mode, tmux active window, setup.sh banner      |
| purple | `#d55fde` | Lualine Visual mode, tmux active pane border, setup.sh banner |

Neovim uses `olimorris/onedarkpro.nvim` (`onedark_vivid`). Lualine pulls colors at runtime via `require("onedarkpro.helpers").get_colors()`. Tmux and `setup.sh` use the same hex values as truecolor ANSI codes.

---

## License

Use freely for your own setup.
