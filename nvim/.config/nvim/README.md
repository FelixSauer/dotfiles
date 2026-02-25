# My Neovim Configuration

> A modern, feature-rich Neovim configuration focused on developer productivity and ease of use.

## Features

- **LSP Integration** - Full Language Server Protocol support with auto-installation
- **AI-Powered Coding** - GitHub Copilot integration for intelligent code completion
- **Beautiful UI** - Modern interface with customizable themes and statusline
- **Smart File Navigation** - Fuzzy finding and project navigation tools
- **Advanced Debugging** - Built-in DAP support with visual debugging features
- **Code Quality Tools** - Integrated linting and formatting
- **Rich Text Editing** - Treesitter syntax highlighting and text manipulation tools

## Requirements

- **Neovim** >= 0.9.0
- **Git** (for plugin management)
- **Node.js** (for some LSP servers and Copilot)
- A **Nerd Font** (recommended: JetBrains Mono Nerd Font)
- **Ollama** (optional, for local AI model support)

## Installation

### Quick Install
```bash
# Backup existing config (optional)
mv ~/.config/nvim ~/.config/nvim.backup

# Clone this configuration
git clone https://github.com/FelixSauer/nvim-config.git ~/.config/nvim

# Start Neovim - plugins will auto-install
nvim
```

### Manual Setup
1. **Install Neovim** (if not already installed):
   ```bash
   # macOS
   brew install neovim
   
   # Ubuntu/Debian
   sudo apt install neovim
   
   # Arch Linux
   sudo pacman -S neovim
   ```

2. **Install a Nerd Font**:
   ```bash
   # macOS with Homebrew
   brew tap homebrew/cask-fonts
   brew install font-jetbrains-mono-nerd-font
   ```

3. **Clone and setup**:
   ```bash
   git clone https://github.com/FelixSauer/nvim-config.git ~/.config/nvim
   nvim
   ```

## Configuration Structure

```
~/.config/nvim/
├── init.lua                 # Main configuration entry point
├── lua/
│   ├── core/               # Core Neovim settings
│   │   ├── keymaps.lua    # Key mappings
│   │   └── options.lua    # Neovim options
│   └── plugins/           # Plugin configurations
└── ftplugin/              # Filetype-specific settings
```

## Plugin Manager

This configuration uses [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management, which provides:
- Fast startup times with lazy loading
- Automatic plugin installation
- Easy plugin updates
- Plugin performance monitoring

## Plugins Overview

### Core Development Tools
| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **nvim-lspconfig** | LSP client configuration | Auto-completion, diagnostics, go-to-definition |
| **mason.nvim** | LSP server management | Automatic LSP server installation |
| **nvim-cmp** | Completion engine | Intelligent autocompletion with multiple sources |
| **nvim-treesitter** | Syntax highlighting | Advanced parsing and code understanding |

### AI & Code Assistance
| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **copilot.vim** | AI code completion | GitHub Copilot integration |
| **CopilotChat.nvim** | AI chat interface | Interactive AI assistance for coding |
| **ollama.nvim** | Local AI models | Run AI models locally with Ollama (DeepSeek R1) |

### Navigation & Search
| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **telescope.nvim** | Fuzzy finder | File search, grep, symbols, and more |
| **harpoon** | Quick navigation | Mark and jump between important files |
| **nvim-tree.nvim** | File explorer | Modern file tree with git integration |

### UI & Visual Enhancements
| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **lualine.nvim** | Statusline | Customizable and informative status bar |
| **colorscheme** | Color scheme | Beautiful themes with variants |
| **indent-blankline.nvim** | Indentation guides | Visual indentation helpers |
| **noice.nvim** | Enhanced UI | Better notifications and command line |
| **snacks.nvim** | Dashboard | Stylish startup screen with utilities |
| **bufferline.nvim** | Buffer tabs | Enhanced buffer management |
| **mini-icons.nvim** | Icons | Minimal and fast icon provider |

### Development Tools
| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **conform.nvim** | Code formatting | Automatic code formatting on save |
| **nvim-lint** | Linting | Real-time code linting and error detection |
| **nvim-dap** | Debugging | Debug Adapter Protocol support |
| **nvim-dap-ui** | Debug interface | Visual debugging with breakpoints |
| **nvim-dap-virtual-text** | Debug info | Virtual text for debug variables |
| **neotest.nvim** | Testing | Advanced test runner and results |
| **autopairs** | Auto pairs | Automatic bracket and quote pairing |
| **bigfile-nvim** | Large files | Better handling of large files |

### Git Integration
| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **lazygit.nvim** | Git interface | Interactive git operations |
| **git-blame.nvim** | Git annotations | Line-by-line git blame information |

### Specialized Tools
| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **obsidian.nvim** | Note taking | Obsidian vault integration |
| **nvim-surround** | Text objects | Easy manipulation of surrounding characters |
| **kube-utils** | Kubernetes | K8s cluster management tools |
| **lazydocker.nvim** | Docker | Docker container management |
| **piple.nvim** | Pipeline tools | Development pipeline utilities |

## Key Mappings

### Leader Key
The leader key is set to `Space`.

### File & Buffer Management
| Shortcut | Action | Mode |
|----------|--------|------|
| `Space + w + w` | Save file | Normal |
| `Space + w + q` | Save and quit | Normal |
| `Space + q + q` | Quit without saving | Normal |
| `Cmd + S` | Save file | Insert/Normal/Visual |
| `Cmd + X` | Close buffer | Insert/Normal/Visual |
| `g + x` | Open URL under cursor | Normal |
| `Space + e + e` | Toggle Neo-tree file explorer | Normal |

### Telescope (Search & Navigation)
| Shortcut | Action | Mode |
|----------|--------|------|
| `Space + f + f` | Find files | Normal |
| `Space + f + g` | Live grep (search in files) | Normal |
| `Space + f + b` | Find open buffers | Normal |
| `Space + f + h` | Find help tags | Normal |
| `Space + f + s` | Search in current buffer | Normal |
| `Space + f + o` | Find LSP document symbols | Normal |
| `Space + f + i` | Find LSP incoming calls | Normal |
| `Space + f + m` | Find methods/functions | Normal |
| `Space + f + t` | Grep in current tree node | Normal |

### Harpoon (Quick Navigation)
| Shortcut | Action | Mode |
|----------|--------|------|
| `Space + h + a` | Add file to Harpoon | Normal |
| `Space + h + h` | Toggle Harpoon menu | Normal |
| `Space + h + 1` | Jump to Harpoon file 1 | Normal |
| `Space + h + 2` | Jump to Harpoon file 2 | Normal |
| `Space + h + 3` | Jump to Harpoon file 3 | Normal |
| `Space + h + 4` | Jump to Harpoon file 4 | Normal |
| `Space + h + 5` | Jump to Harpoon file 5 | Normal |
| `Space + h + 6` | Jump to Harpoon file 6 | Normal |
| `Space + h + 7` | Jump to Harpoon file 7 | Normal |
| `Space + h + 8` | Jump to Harpoon file 8 | Normal |
| `Space + h + 9` | Jump to Harpoon file 9 | Normal |

### Window & Split Management
| Shortcut | Action | Mode |
|----------|--------|------|
| `Space + s + v` | Split window vertically | Normal |
| `Space + s + h` | Split window horizontally | Normal |
| `Space + s + e` | Make split windows equal | Normal |
| `Space + s + x` | Close split window | Normal |
| `Space + s + j` | Make split shorter | Normal |
| `Space + s + k` | Make split taller | Normal |
| `Space + s + l` | Make split wider | Normal |
| `Space + s + m` | Toggle maximize window | Normal |

### Tab Management
| Shortcut | Action | Mode |
|----------|--------|------|
| `Space + t + o` | Open new tab | Normal |
| `Space + t + x` | Close current tab | Normal |
| `Space + t + n` | Go to next tab | Normal |
| `Space + t + p` | Go to previous tab | Normal |

### Diff & Merge
| Shortcut | Action | Mode |
|----------|--------|------|
| `Space + c + c` | Put diff to other side | Normal |
| `Space + c + j` | Get diff from left (local) | Normal |
| `Space + c + k` | Get diff from right (remote) | Normal |
| `Space + c + n` | Next diff hunk | Normal |
| `Space + c + p` | Previous diff hunk | Normal |

### Quickfix List
| Shortcut | Action | Mode |
|----------|--------|------|
| `Space + q + o` | Open quickfix list | Normal |
| `Space + q + c` | Close quickfix list | Normal |
| `Space + q + f` | Jump to first item | Normal |
| `Space + q + l` | Jump to last item | Normal |
| `Space + q + n` | Jump to next item | Normal |
| `Space + q + p` | Jump to previous item | Normal |

### LSP (Language Server)
| Shortcut | Action | Mode |
|----------|--------|------|
| `Space + g + g` | Show hover information | Normal |
| `Space + g + d` | Go to definition | Normal |
| `Space + g + D` | Go to declaration | Normal |
| `Space + g + i` | Go to implementation | Normal |
| `Space + g + t` | Go to type definition | Normal |
| `Space + g + r` | Find references | Normal |
| `Space + g + s` | Show signature help | Normal |
| `Space + r + r` | Rename symbol | Normal |
| `Space + g + f` | Format code | Normal/Visual |
| `Space + g + a` | Code actions | Normal |
| `Space + g + l` | Show line diagnostics | Normal |
| `Space + g + p` | Go to previous diagnostic | Normal |
| `Space + g + n` | Go to next diagnostic | Normal |
| `Space + t + r` | Show document symbols | Normal |
| `Ctrl + Space` | Trigger completion | Insert |

### Debugging (DAP)
| Shortcut | Action | Mode |
|----------|--------|------|
| `Space + b + b` | Toggle breakpoint | Normal |
| `Space + b + c` | Set conditional breakpoint | Normal |
| `Space + b + l` | Set log point | Normal |
| `Space + b + r` | Clear all breakpoints | Normal |
| `Space + b + a` | List all breakpoints | Normal |
| `Space + d + c` | Continue debugging | Normal |
| `Space + d + j` | Step over | Normal |
| `Space + d + k` | Step into | Normal |
| `Space + d + o` | Step out | Normal |
| `Space + d + d` | Disconnect debugger | Normal |
| `Space + d + t` | Terminate debugging | Normal |
| `Space + d + r` | Toggle REPL | Normal |
| `Space + d + l` | Run last debug config | Normal |
| `Space + d + i` | Hover debug info | Normal |
| `Space + d + ?` | Show debug scopes | Normal |
| `Space + d + f` | Show debug frames | Normal |
| `Space + d + h` | Show debug commands | Normal |
| `Space + d + e` | Show error diagnostics | Normal |

### Ollama (Local AI)
| Shortcut | Action | Mode |
|----------|--------|------|
| `Space + o + o` | Open Ollama prompt | Normal/Visual |
| `Space + o + G` | Generate code with Ollama | Normal/Visual |

### Miscellaneous
| Shortcut | Action | Mode |
|----------|--------|------|
| `Space + x + r` | Run REST query | Normal |

*All keybindings are defined in [lua/core/keymaps.lua](lua/core/keymaps.lua)*

## Customization

### Adding New Plugins
1. Create a new file in `lua/plugins/`
2. Follow the lazy.nvim plugin specification
3. Restart Neovim to install the plugin

Example:
```lua
-- lua/plugins/my-plugin.lua
return {
  "author/plugin-name",
  config = function()
    -- Plugin configuration
  end
}
```

### Modifying Settings
- **Neovim options**: Edit `lua/core/options.lua`
- **Key mappings**: Edit `lua/core/keymaps.lua`
- **Plugin configs**: Edit files in `lua/plugins/`

## Troubleshooting

### Common Issues

1. **Plugins not installing**:
   ```bash
   # Try manually syncing plugins
   :Lazy sync
   ```

2. **LSP servers not working**:
   ```bash
   # Install LSP servers manually
   :Mason
   ```

3. **Fonts not displaying correctly**:
   - Ensure you have a Nerd Font installed
   - Set your terminal to use the Nerd Font

### Health Check
Run `:checkhealth` in Neovim to diagnose configuration issues.

## Contributing

Feel free to:
- Report bugs by opening an issue
- Suggest new features or improvements
- Submit pull requests with enhancements
