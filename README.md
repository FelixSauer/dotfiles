# dotfiles

Personal configuration files for my development environment.

## 📦 What's Included

### 🖥️ Terminal & Shell
- **[Alacritty](alacritty/)** - GPU-accelerated terminal emulator
  - Catppuccin color scheme
  - MesloLGS Nerd Font
  - 95% opacity with custom padding
  
- **[Fish Shell](fish/)** - User-friendly shell with smart features
  - Auto-start tmux in interactive sessions
  - SSH agent management
  - Custom aliases and functions
  - Eza integration for better `ls` output

- **[Tmux](tmux/)** - Terminal multiplexer ([detailed docs](tmux/README.md))
  - Custom prefix key (`Ctrl+a`)
  - TPM plugins (resurrect, continuum, sensible)
  - Vim-style pane navigation
  - Mouse support enabled

- **[Oh My Fish](omf/)** - Fish shell framework
  - Plugin and theme management

### ⌨️ Editor
- **[Neovim](nvim/)** - Hyperextensible Vim-based text editor
  - Lazy.nvim plugin manager
  - LSP configuration with auto-completion
  - Treesitter for advanced syntax highlighting
  - GitHub Copilot integration
  - LazyGit integration
  - Debugging support (DAP)
  - Testing framework (Neotest)
  - File explorer (nvim-tree)
  - Obsidian integration
  - Kubernetes utilities
  - Docker integration (lazydocker)
  - Harpoon for quick file navigation
  - And many more plugins...

### 🔧 Development Tools
- **[LazyGit](lazygit/)** - Terminal UI for git commands
  - Custom configuration and keybindings

## 🚀 Installation

### Prerequisites

Install required dependencies:

```bash
# On macOS
brew install fish tmux neovim alacritty lazygit eza

# On Linux (Debian/Ubuntu)
sudo apt install fish tmux neovim alacritty
```

### Quick Setup

Clone this repository:

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### Manual Installation

Create symbolic links for each configuration:

```bash
# Alacritty
ln -sf ~/dotfiles/alacritty/.config/alacritty ~/.config/

# Fish
ln -sf ~/dotfiles/fish/.config/fish ~/.config/

# Tmux
ln -sf ~/dotfiles/tmux/.config/tmux ~/.config/

# Neovim
ln -sf ~/dotfiles/nvim/.config/nvim ~/.config/

# LazyGit
ln -sf ~/dotfiles/lazygit/.config/lazygit ~/.config/
```

### Post-Installation

#### Tmux
Install TPM (Tmux Plugin Manager):
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
Then press `Prefix + I` in tmux to install plugins.

#### Neovim
Launch Neovim - Lazy.nvim will automatically install plugins on first run:
```bash
nvim
```

#### Fish
Set Fish as your default shell:
```bash
chsh -s $(which fish)
```

Install Oh My Fish:
```bash
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
```

## 📝 Key Features

### Fish Aliases
- `c` - Clear terminal
- `l` - List files with eza (long format, all files)
- `V` - Launch Neovim
- `G` - Launch LazyGit
- `q` - Exit shell
- `dev` - Navigate to dev directory
- `config` - Navigate to config directory

### Tmux Keybindings
- `Ctrl+a` - Prefix key
- `Prefix + +` - Split horizontally
- `Prefix + -` - Split vertically
- `Prefix + h/j/k/l` - Navigate panes (Vim-style)
- `Alt + Arrow keys` - Navigate panes (without prefix)
- `Prefix + r` - Reload configuration

### Neovim
- Leader key: `Space`
- See individual plugin configurations in [nvim/lua/plugins/](nvim/.config/nvim/lua/plugins/)

## 🎨 Theme & Appearance

- **Terminal Theme**: Catppuccin (Mocha)
- **Font**: MesloLGS Nerd Font (size 12)
- **Terminal**: Alacritty with 95% opacity

## 🔄 Updating

Pull the latest changes:
```bash
cd ~/dotfiles
git pull
```

Update Neovim plugins:
```bash
nvim
:Lazy sync
```

Update Tmux plugins:
```bash
# In tmux: Prefix + U
```

## 📄 License

Feel free to use these configurations for your own setup!

## 🤝 Contributing

Suggestions and improvements are welcome! Feel free to open an issue or pull request.
