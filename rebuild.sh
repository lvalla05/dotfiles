#!/usr/bin/env bash
# Apply the declaration. Edit files, run this, done.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# Live settings must never depend on a disposable worker checkout.
if [ "$(id -u)" -eq 0 ]; then
  echo "Run ./rebuild.sh as your ordinary user, not with sudo."
  exit 1
fi
# A linked worktree (.git is a file, not a directory) is disposable; never activate from one.
if [ ! -d "$DIR/.git" ]; then
  echo "Activate only from the primary clone, not a linked worktree."
  echo "Build and test in worktrees; merge the result into the primary clone before activating."
  exit 1
fi
branch="$(git -C "$DIR" symbolic-ref --quiet --short HEAD || echo detached)"
if [ "$branch" != main ]; then
  echo "note: activating from branch '$branch' (not main). Live symlinks now track this branch."
fi
if test -L "$HOME/.dotfiles"; then
  if [ "$(readlink "$HOME/.dotfiles")" != "$DIR" ]; then
    echo "Refusing to retarget ~/.dotfiles. Resolve its existing destination manually."
    exit 1
  fi
elif test -e "$HOME/.dotfiles"; then
  echo "Refusing to replace ~/.dotfiles: it exists and is not a symlink."
  exit 1
fi
if ! test -L "$HOME/.dotfiles"; then
  ln -s "$DIR" "$HOME/.dotfiles"
fi
# Absolute path: a shell opened before the first switch has no /run/current-system on PATH.
exec sudo /run/current-system/sw/bin/darwin-rebuild switch --flake "$DIR#mac"
