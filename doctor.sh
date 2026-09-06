#!/usr/bin/env bash
# Preflight for ./rebuild.sh. Prints every precondition as ok/FAIL with the fix.
# Run this first when a rebuild fails; paste its output when asking for help.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
fail=0
ok()   { printf 'ok    %s\n' "$1"; }
bad()  { printf 'FAIL  %s\n      fix: %s\n' "$1" "$2"; fail=1; }
warn() { printf 'warn  %s\n      %s\n' "$1" "$2"; }

# 1. Where am I and is this the durable checkout?
branch="$(git -C "$DIR" symbolic-ref --quiet --short HEAD 2>/dev/null || echo detached)"
if [ "$branch" = main ]; then ok "on main"; else
  bad "checkout is on '$branch', not main" "git -C '$DIR' switch main   (merge or pull the branch you want first)"; fi
if git -C "$DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1 && [ -f "$DIR/.git" ]; then
  bad "this is a linked worktree" "activate from the primary clone, not a worktree"; fi
if [ -n "$(git -C "$DIR" ls-files --others --exclude-standard)" ]; then
  bad "untracked files exist; nix flakes only see git-tracked files" "git -C '$DIR' add -A   (or delete the stray files)"; fi

# 2. ~/.dotfiles pointer
if [ -L "$HOME/.dotfiles" ]; then
  if [ "$(readlink "$HOME/.dotfiles")" = "$DIR" ]; then ok "~/.dotfiles -> $DIR"; else
    bad "~/.dotfiles -> $(readlink "$HOME/.dotfiles"), not $DIR" "rm '$HOME/.dotfiles' && ln -s '$DIR' '$HOME/.dotfiles'"; fi
elif [ -e "$HOME/.dotfiles" ]; then
  bad "~/.dotfiles exists and is not a symlink" "move it aside: mv '$HOME/.dotfiles' '$HOME/.dotfiles.old'"
else ok "~/.dotfiles will be created by rebuild.sh"; fi

# 3. Toolchain
if [ "$(uname -m)" = arm64 ]; then ok "Apple silicon"; else bad "not arm64" "this flake targets aarch64-darwin"; fi
if command -v nix >/dev/null 2>&1; then ok "nix $(nix --version 2>/dev/null | head -1)"; else
  bad "nix missing" "run ./bootstrap.sh"; fi
if [ -x /nix/var/nix/profiles/default/bin/nix ]; then ok "Determinate Nix profile present"; else
  warn "no /nix/var/nix/profiles/default/bin/nix" "configuration.nix sets nix.enable=false for Determinate Nix; a different installer needs nix.enable=true"; fi
if [ -x /run/current-system/sw/bin/darwin-rebuild ]; then ok "darwin-rebuild present"; else
  warn "no /run/current-system/sw/bin/darwin-rebuild" "first switch has not happened; use ./bootstrap.sh"; fi
if pkgutil --pkg-info=com.apple.pkg.CLTools_Executables >/dev/null 2>&1; then ok "Command Line Tools"; else
  bad "Command Line Tools missing" "xcode-select --install"; fi

# 4. Username matches the flake
flake_user="$(sed -nE 's/^[[:space:]]*user = "([^"]+)";.*/\1/p' "$DIR/flake.nix" | head -n1)"
if [ "$flake_user" = "$(whoami)" ]; then ok "flake user = $flake_user"; else
  bad "flake.nix user is '$flake_user' but you are '$(whoami)'" "edit the one user = line in flake.nix"; fi

# 5. Files home-manager would need to move aside (a stale *.backup blocks the switch)
for p in .config/ghostty .config/nvim .config/herdr .config/raycast/scripts .agents/AGENTS.md \
         .codex/AGENTS.md .grok/AGENTS.md .grok/requirements.toml .claude/settings.json .npmrc .ssh/config; do
  t="$HOME/$p"
  if [ -e "$t.backup" ]; then bad "$t.backup exists; home-manager refuses to overwrite it" "rm -r '$t.backup'"; fi
  if [ -e "$t" ] && [ ! -L "$t" ]; then warn "$t is a real file/dir" "home-manager will move it to $t.backup on switch"; fi
done

# 6. Homebrew state
if [ -x /opt/homebrew/bin/brew ]; then
  ok "brew $(/opt/homebrew/bin/brew --version 2>/dev/null | head -1)"
  if [ -f "$HOME/.local/state/homebrew/bundle.lock" ] || [ -f /opt/homebrew/.bundle.lock ]; then :; fi
else warn "no /opt/homebrew/bin/brew" "nix-homebrew installs it on the first switch"; fi
if command -v mas >/dev/null 2>&1; then
  if mas account >/dev/null 2>&1; then ok "App Store signed in"; else
    warn "mas cannot see an App Store sign-in" "sign in to the App Store or the masApps line will fail"; fi
fi

# 7. Evaluate the flake without building (fast, catches typos and unknown options)
if command -v nix >/dev/null 2>&1; then
  if out="$(nix eval --raw "$DIR#darwinConfigurations.mac.system.drvPath" 2>&1)"; then ok "flake evaluates"; else
    bad "flake does not evaluate" "read the first 'error:' line below"; printf '%s\n' "$out" | grep -m3 -i 'error' | sed 's/^/      /'; fi
fi

[ "$fail" = 0 ] && echo "doctor: ready for ./rebuild.sh" || echo "doctor: fix the FAIL lines, then ./rebuild.sh"
exit "$fail"
