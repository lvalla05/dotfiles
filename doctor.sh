#!/usr/bin/env bash
# Preflight for ./rebuild.sh. Prints every precondition as ok/FAIL with the fix.
# Run this first when a rebuild fails; paste its output when asking for help.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
fail=0
ok()   { printf 'ok    %s\n' "$1"; }
bad()  { printf 'FAIL  %s\n      fix: %s\n' "$1" "$2"; fail=1; }
warn() { printf 'warn  %s\n      %s\n' "$1" "$2"; }

is_home_manager_link() {
  local link="$1" current_files="${2:-}"
  case "$link" in
    /nix/store/*-home-manager-files/*) return 0 ;;
  esac
  [ -n "$current_files" ] && [[ "$link" = "$current_files"/* ]]
}

current_home_manager_files() {
  local p link
  for p in "$@"; do
    [ -L "$HOME/$p" ] || continue
    link="$(readlink "$HOME/$p")"
    case "$link" in
      /nix/store/*-home-manager-files/*)
        printf '%s-home-manager-files\n' "${link%%-home-manager-files/*}"
        return 0
        ;;
    esac
  done
  return 1
}

check_home_manager_collisions() {
  local home_files="$1" target_home="$2" current_files="${3:-}"
  local source relative target link backup
  while IFS= read -r -d '' source; do
    relative="${source#"$home_files"/}"
    target="$target_home/$relative"
    [ -e "$target" ] || continue
    link="$(readlink "$target" 2>/dev/null || true)"
    is_home_manager_link "$link" "$current_files" && continue
    cmp -s "$source" "$target" && continue
    if [ -L "$target" ]; then
      bad "$target is a foreign symlink that differs from Home Manager's source" "move it aside before ./rebuild.sh"
    else
      backup="$target.backup"
      if [ -e "$backup" ]; then
        warn "$target is a real file/dir and $backup already exists" "home-manager will replace the backup, then move the current target there"
      else
        warn "$target is a real file/dir" "home-manager will move it to $backup on switch"
      fi
    fi
  done < <(find -H "$home_files" \( -type f -o -type l \) -print0)
}

main() {
fail=0

# 1. Where am I and is this the durable checkout?
branch="$(git -C "$DIR" symbolic-ref --quiet --short HEAD 2>/dev/null || echo detached)"
if [ "$branch" = detached ]; then
  bad "checkout has a detached HEAD" "switch to the branch you intend to activate in the primary clone"
elif [ "$branch" = main ]; then ok "on main"; else
  warn "activating feature branch '$branch' in the primary clone" "review its diff before ./rebuild.sh"; fi
if git -C "$DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1 && [ -f "$DIR/.git" ]; then
  bad "this is a linked worktree" "activate from the primary clone, not a worktree"; fi
if [ -n "$(git -C "$DIR" ls-files --others --exclude-standard)" ]; then
  bad "untracked files exist; nix flakes only see git-tracked files" "git -C '$DIR' add -A   (or delete the stray files)"; fi

# 2. ~/.dotfiles pointer
if [ -L "$HOME/.dotfiles" ]; then
  if [ "$(readlink "$HOME/.dotfiles")" = "$DIR" ]; then ok "link $HOME/.dotfiles -> $DIR"; else
    bad "link $HOME/.dotfiles -> $(readlink "$HOME/.dotfiles"), not $DIR" "rm '$HOME/.dotfiles' && ln -s '$DIR' '$HOME/.dotfiles'"; fi
elif [ -e "$HOME/.dotfiles" ]; then
  bad "$HOME/.dotfiles exists and is not a symlink" "move it aside: mv '$HOME/.dotfiles' '$HOME/.dotfiles.old'"
else ok "$HOME/.dotfiles will be created by rebuild.sh"; fi

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

# 5. Check the active Home Manager generation using its own collision rules.
home_manager_paths=(.config/ghostty .config/nvim .config/herdr .config/raycast/scripts .agents/AGENTS.md
  .codex/AGENTS.md .grok/AGENTS.md .grok/requirements.toml .pi/agent/AGENTS.md
  .pi/agent/settings.json .pi/agent/models.json .pi/agent/themes
  .pi/agent/extensions/calm .pi/agent/extensions/terminal-status-title.js
  .claude/settings.json .npmrc .ssh/config .local/bin/pstack-setup .local/bin/firstmate)
if home_manager_files="$(current_home_manager_files "${home_manager_paths[@]}")" && [ -d "$home_manager_files" ]; then
  check_home_manager_collisions "$home_manager_files" "$HOME" "$home_manager_files"
else
  warn "current Home Manager files could not be located" "the first switch will perform its own collision check"
fi

# 6. Homebrew state
if [ -x /opt/homebrew/bin/brew ]; then
  ok "brew $(/opt/homebrew/bin/brew --version 2>/dev/null | head -1)"
else warn "no /opt/homebrew/bin/brew" "nix-homebrew installs it on the first switch"; fi
if command -v mas >/dev/null 2>&1; then
  if mas list 2>/dev/null | grep -q .; then ok "mas sees installed App Store apps"; else
    warn "mas lists no App Store apps" "sign in to the App Store and own the three declared masApps, or brew bundle fails on that line"; fi
fi
if command -v pi >/dev/null 2>&1; then
  ok "pi $(pi --version 2>/dev/null | head -1)"
else
  warn "pi is not installed" "run bash '$DIR/home/bin/agent-tools' pi"
fi
# thaw's cask declares depends_on macos: :tahoe (26).
macos_major="$(sw_vers -productVersion 2>/dev/null | cut -d. -f1)"
if [ -n "$macos_major" ] && [ "$macos_major" -lt 26 ]; then
  bad "macOS $macos_major is older than 26; the thaw cask refuses to install" "upgrade macOS or ask to remove thaw from configuration.nix"; fi

# 7. Evaluate the flake without building (fast, catches typos and unknown options)
if command -v nix >/dev/null 2>&1; then
  if out="$(nix eval --raw "$DIR#darwinConfigurations.mac.system.drvPath" 2>&1)"; then ok "flake evaluates"; else
    bad "flake does not evaluate" "read the first 'error:' line below"; printf '%s\n' "$out" | grep -m3 -i 'error' | sed 's/^/      /'; fi
fi

[ "$fail" = 0 ] && echo "doctor: ready for ./rebuild.sh" || echo "doctor: fix the FAIL lines, then ./rebuild.sh"
return "$fail"
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
  main "$@"
fi
