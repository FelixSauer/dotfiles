---
description: Add a fish alias and sync the README alias table
argument-hint: <alias> <command>
allowed-tools: Read, Edit
---

You are adding a new fish alias to the dotfiles project. The argument is: $ARGUMENTS

Parse the argument as: first word = alias name, rest = the command it expands to.
Example: `post posting` means `alias post 'posting'`

## Step 1 — Read current config

Read `fish/.config/fish/config.fish` to understand the existing alias categories and placement.

The categories are:
- `# --- General ---` — everyday tools
- `# --- Games ---` — games and entertainment
- `# --- Network ---` — network utilities
- `# --- Media / News ---` — media and feeds

## Step 2 — Choose the right category

Pick the category that best fits the command being aliased:
- System tools, editors, version control → General
- Games or entertainment → Games
- Network diagnostics, speed tests → Network
- Music, podcasts, RSS, news → Media / News

## Step 3 — Add the alias to config.fish

Insert the alias under the chosen category, grouped with similar aliases.

Pattern: `alias <name> '<command>'`

If the command is a single word with no spaces, quotes are still fine but not required.
Stay consistent with existing style (existing aliases use single quotes).

## Step 4 — Update README.md

Read `README.md` and find the Fish Alias table in the Key Bindings Reference section.

Add a row to the table in alphabetical order by alias name:

```
| `<alias>` | `<command>` |
```

The table columns are: Alias | Expands to

After making both edits, confirm what was added and in which category.
