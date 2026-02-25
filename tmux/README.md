# Tmux Configuration

My personal tmux configuration with sensible defaults and useful plugins.

## Features

### Prefix Key
- **Prefix**: `Ctrl+a` (changed from default `Ctrl+b`)

### Window & Pane Management
- **Split horizontally**: `Prefix + +`
- **Split vertically**: `Prefix + -`
- **Reload config**: `Prefix + r`
- Windows start at 1 (not 0)
- Auto-renumber windows when closed

### Navigation
**Vim-style pane navigation** (with prefix):
- `h` - left
- `j` - down
- `k` - up
- `l` - right

**Arrow keys** (without prefix):
- `Alt+Left/Right/Up/Down` - switch panes

### Mouse Support
✅ Mouse mode enabled - click to select panes, resize, and scroll

### Status Bar
- Custom color scheme with 256 colors
- Shows current date and time
- Activity monitoring enabled

### Performance
- Increased scrollback buffer: 10,000 lines
- Reduced escape time for faster command sequences
- 256-color terminal support

## Plugins (TPM)

This config uses [Tmux Plugin Manager (TPM)](https://github.com/tmux-plugins/tpm):

- **tmux-sensible**: Basic tmux settings everyone can agree on
- **tmux-resurrect**: Save and restore tmux sessions
- **tmux-continuum**: Continuous saving of tmux environment (auto-save every 15min)

### Installing Plugins

1. Install TPM:
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

2. Start tmux and install plugins:
```bash
tmux
# Press: Prefix + I (capital i)
```

### Plugin Keybindings
- `Prefix + I` - Install plugins
- `Prefix + U` - Update plugins
- `Prefix + alt + u` - Uninstall plugins not in config

### Session Persistence
- Sessions are automatically saved every 15 minutes
- Last session is automatically restored when tmux starts
- Manual save: `Prefix + Ctrl+s`
- Manual restore: `Prefix + Ctrl+r`

## Installation

This config is managed with GNU Stow:

```bash
cd ~/dotfiles
stow tmux
```

This creates: `~/.config/tmux/tmux.conf` → `~/dotfiles/tmux/.config/tmux/tmux.conf`

## Quick Reference

| Action | Key Binding |
|--------|-------------|
| Prefix | `Ctrl+a` |
| Split horizontal | `Prefix + +` |
| Split vertical | `Prefix + -` |
| Navigate panes | `Prefix + h/j/k/l` or `Alt+Arrows` |
| Reload config | `Prefix + r` |
| Install plugins | `Prefix + I` |
| Save session | `Prefix + Ctrl+s` |
| Restore session | `Prefix + Ctrl+r` |
| New window | `Prefix + c` |
| Next window | `Prefix + n` |
| Previous window | `Prefix + p` |
| Kill pane | `Prefix + x` |

## Notes

- Config location changed to XDG standard: `~/.config/tmux/tmux.conf`
- Old location `~/.tmux.conf` can be a symlink for compatibility
- Pane contents are captured and restored with sessions
- Neovim sessions are preserved across tmux restarts
