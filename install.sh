#!/usr/bin/env bash
# install.sh — Bootstrap: clone (if needed) then install all packages non-interactively
# Usage (curl):  curl -fsSL https://raw.githubusercontent.com/FelixSauer/dotfiles/main/install.sh | bash
# Usage (local): bash install.sh

set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
REPO="https://github.com/FelixSauer/dotfiles.git"

# When piped via curl, BASH_SOURCE[0] is empty or "bash" — no local file exists.
# When run from disk, use the script's own directory directly.
if [[ -n "${BASH_SOURCE[0]:-}" && "${BASH_SOURCE[0]}" != "bash" && -f "${BASH_SOURCE[0]}" ]]; then
  DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
elif [[ -d "$DOTFILES_DIR/.git" ]]; then
  echo "Updating existing dotfiles..."
  git -C "$DOTFILES_DIR" pull --quiet
else
  echo "Cloning dotfiles..."
  git clone --quiet "$REPO" "$DOTFILES_DIR"
fi

exec bash "$DOTFILES_DIR/setup.sh" --yes
