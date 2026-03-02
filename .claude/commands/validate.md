---
description: Consistency check across all config files — reports OK / WARN / ERROR
allowed-tools: Read, Bash
---

Run a full consistency check across all dotfiles configs. This command takes no arguments.

Read all relevant files and perform each check below. Output a structured report at the end.

## Files to read

Read all of these upfront:
- `setup.sh`
- `packages.config`
- `fish/.config/fish/config.fish`
- `opencode/.config/opencode/opencode.json`
- `tmux/.config/tmux/tmux.conf`
- `nvim/.config/nvim/lua/plugins/nvim-colorscheme.lua`
- `nvim/.config/nvim/lua/plugins/nvim-lualine.lua`
- `README.md`
- All files matching `ollama/*.Modelfile`

## Check 1 — Stow packages vs directories

For every package listed in `packages.config`, verify that a matching top-level directory
exists in the dotfiles root (e.g. `fish` → `fish/` directory must exist).

Report:
- OK if all stow packages have a directory
- ERROR for any package in packages.config without a corresponding directory

## Check 2 — Fish aliases vs installed tools

For each alias in `fish/config.fish`, extract the command it expands to (first word).

Cross-reference against tools installed in `setup.sh`:
- If the command is a standard system tool (clear, exit, ssh), mark as OK
- If the command appears in setup.sh as an installed binary, mark as OK
- If the command cannot be traced to setup.sh OR a standard system tool, mark as WARN

Report each alias with its status.

## Check 3 — opencode.json vs Modelfiles

For every model ID in `opencode.json` under `provider.ollama.models`:
- Convert the model ID to the expected Modelfile name: replace `:` with `-`, append `.Modelfile`
  Example: `llama3.2:3b` → `llama3.2-3b.Modelfile`
- Check if `ollama/<filename>` exists

Report:
- OK if Modelfile exists
- ERROR if Modelfile is missing

Also check the reverse: for every `.Modelfile` in `ollama/`, verify it has a corresponding
entry in opencode.json. Report WARN for orphaned Modelfiles.

## Check 4 — Tmux colors vs onedark_vivid palette

The expected onedark_vivid hex values are:
- red:    #ef596f
- yellow: #e5c07b
- green:  #89ca78
- cyan:   #2bbac5
- blue:   #61afef
- purple: #d55fde

Read `tmux/.config/tmux/tmux.conf` and extract all hex color values used.
Compare them against this palette.

Report:
- OK for each hex value that matches the palette
- WARN for hex values that don't match any palette color (might be intentional)

## Check 5 — README drift

**Aliases drift**: Compare aliases in `fish/config.fish` against the Fish Alias table in
`README.md`. Report any aliases present in config but missing from README, and any rows
in README that no longer exist in config.

**Packages drift**: Compare packages in `packages.config` against the Packages table in
`README.md`. Report any packages missing from or added to the README table.

## Output format

Print a structured report:

```
=== Dotfiles Validation Report ===

[Check 1] Stow packages vs directories
  OK    fish
  OK    nvim
  ERROR missing-pkg  — in packages.config but no directory found

[Check 2] Fish aliases vs installed tools
  OK    c     → clear (system)
  OK    g     → lazygit (setup.sh)
  WARN  xyz   → unknowntool (not found in setup.sh)

[Check 3] opencode.json vs Modelfiles
  OK    llama3.2:3b   → ollama/llama3.2-3b.Modelfile
  ERROR deepseek-r1:32b → ollama/deepseek-r1-32b.Modelfile missing

[Check 4] Tmux colors vs onedark_vivid
  OK    #89ca78  green
  WARN  #ffffff  not in palette

[Check 5] README drift
  Aliases:  OK (all aliases match)
  Packages: WARN  sshtron — in README but not in packages.config

=== Summary ===
  OK:    N
  WARN:  N
  ERROR: N
```

If there are no issues, print a clean summary. If there are ERRORs, list them prominently
at the end so they are easy to spot.
