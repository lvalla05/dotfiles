#!/usr/bin/env bash
# Apply the declaration. Edit files, run this, done.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles
# Absolute path: a shell opened before the first switch has no /run/current-system on PATH.
exec sudo /run/current-system/sw/bin/darwin-rebuild switch --flake ~/.dotfiles#mac
