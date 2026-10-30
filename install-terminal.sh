#!/usr/bin/env bash
# Symlinks the kitty + herdr config into ~/.config. Existing real files are moved
# aside with a timestamped .bak suffix; re-running is a no-op once linked.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
STAMP="$(date +%Y%m%d%H%M%S)"

link() {
  local src="$1" dest="$2"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "ok      $dest"
    return
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mv "$dest" "$dest.bak-$STAMP"
    echo "backup  $dest -> $dest.bak-$STAMP"
  fi
  ln -s "$src" "$dest"
  echo "linked  $dest -> $src"
}

mkdir -p "$HOME/.config/herdr"

# kitty's whole dir is config; herdr's dir also holds sockets, logs, and session
# state, so only its config.toml is linked.
link "$DOTFILES/kitty" "$HOME/.config/kitty"
link "$DOTFILES/herdr/config.toml" "$HOME/.config/herdr/config.toml"
