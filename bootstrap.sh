#!/usr/bin/env bash
# Takes a fresh Mac from nothing to a built nix-darwin config.
# Run this once. After it finishes, use ./rebuild.sh for every later change.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# Live settings must never depend on a disposable worker checkout.
if [ "$(id -u)" -eq 0 ]; then
  echo "Run ./bootstrap.sh as your ordinary user, not with sudo."
  exit 1
fi
if [ ! -d "$DIR/.git" ] || [ "$(git -C "$DIR" symbolic-ref --quiet --short HEAD)" != main ]; then
  echo "Activate only from the primary checkout on main, not a linked worktree."
  echo "Build and test in worktrees; merge the result into main before activating."
  exit 1
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

NIX_INSTALLER_VERSION="v3.22.3"
NIX_INSTALLER_SHA256="61dbd9b6c74a66cc580d36e80214438bd19455bbab7efd79f2903445e16e82b9"
NIX_INSTALLER_URL="https://github.com/DeterminateSystems/nix-installer/releases/download/${NIX_INSTALLER_VERSION}/nix-installer-aarch64-darwin"
NIX_INSTALLER_DIR=""
NIX_INSTALLER_FILE=""

cleanup_installer() {
  if [ -n "$NIX_INSTALLER_FILE" ]; then
    rm -f -- "$NIX_INSTALLER_FILE"
  fi
  if [ -n "$NIX_INSTALLER_DIR" ]; then
    rmdir -- "$NIX_INSTALLER_DIR" 2>/dev/null || true
  fi
}
trap cleanup_installer EXIT

if [ "$(uname -m)" != "arm64" ]; then
  echo "This flake and pinned installer target Apple silicon (arm64)."
  exit 1
fi

echo "==> Step 1: Determinate Nix"
if command -v nix >/dev/null 2>&1; then
  echo "    nix already installed, skipping"
else
  NIX_INSTALLER_DIR="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-nix-installer.XXXXXX")"
  NIX_INSTALLER_FILE="$NIX_INSTALLER_DIR/nix-installer"
  curl --proto '=https' --tlsv1.2 --fail --location --silent --show-error \
    --output "$NIX_INSTALLER_FILE" "$NIX_INSTALLER_URL"
  printf '%s  %s\n' "$NIX_INSTALLER_SHA256" "$NIX_INSTALLER_FILE" | shasum -a 256 -c -
  chmod 700 "$NIX_INSTALLER_FILE"
  "$NIX_INSTALLER_FILE" install --no-confirm
  # shellcheck disable=SC1091
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

echo "==> Step 2: symlink this repo to ~/.dotfiles"
# home.nix resolves its mkOutOfStoreSymlink paths through ~/.dotfiles, so this
# has to exist before the first switch or the build will fail to find them.
if ! test -L "$HOME/.dotfiles"; then
  ln -s "$DIR" "$HOME/.dotfiles"
fi

echo "==> Step 3: personalize the configured username"
# Do this before any sudo call: sudo resets $USER to root, so whoami has to
# run as the real interactive user first.
REAL_USER="$(whoami)"
FLAKE_USER="$(sed -nE 's/^[[:space:]]*user = "([^"]+)";.*/\1/p' "$DIR/flake.nix" | head -n1)"
if [ -z "$FLAKE_USER" ]; then
  echo "    Could not find the single \"user = \" line in flake.nix."
  echo "    Edit flake.nix yourself before continuing."
  exit 1
elif [ "$FLAKE_USER" != "$REAL_USER" ]; then
  echo "    flake.nix is configured for user \"$FLAKE_USER\", but you are \"$REAL_USER\"."
  read -r -p "    Rewrite flake.nix's \"user = \" line to \"$REAL_USER\"? [y/N] " REPLY
  if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ]; then
    sed -i '' -E "s/^([[:space:]]*user = \")[^\"]+(\";.*)/\1${REAL_USER}\2/" "$DIR/flake.nix"
    echo "    Updated. Review the change with: git diff flake.nix"
  else
    echo "    Skipped. Edit the single \"user = \" line in flake.nix yourself before continuing."
    exit 1
  fi
else
  echo "    flake.nix already matches \"$REAL_USER\", nothing to do."
fi

echo "==> Step 4: first darwin-rebuild switch (locked by flake.lock)"
# darwin-rebuild does not exist yet on a fresh machine. The local flake exposes
# the runner from its locked nix-darwin input, so no mutable branch runs as root.
NIX_BIN="/nix/var/nix/profiles/default/bin/nix"
if [ ! -x "$NIX_BIN" ]; then
  echo "Expected Determinate Nix at $NIX_BIN, but it is missing."
  exit 1
fi
# "mac" is the flake host label - if you renamed it, change it in flake.nix
# and rebuild.sh too.
sudo "$NIX_BIN" run "$DIR#darwin-rebuild" -- switch --flake "$DIR#mac"

echo "==> Done. Open a NEW terminal window (this one has no /run/current-system on its PATH),"
echo "    then use ./rebuild.sh for future changes. Continue with SETUP.md."
