#!/usr/bin/env bash
# Static checks for the drift this repo can actually suffer: a declared link
# whose target does not exist, an unparseable settings file, a mutable bootstrap,
# a cask line that went missing, an untrusted tap, or private memory in this repo.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
fail=0
say_fail() { echo "FAIL $1"; fail=1; }

# every mkOutOfStoreSymlink target in home.nix exists in the repo
while IFS= read -r rel; do
  [ -e "$DIR/$rel" ] || say_fail "home.nix links $rel but it does not exist"
done < <(grep -oE 'dotfiles}/[^"]+' "$DIR/home.nix" | sed 's|dotfiles}/||' | sort -u)

# the instruction files are what every harness loads
[ -f "$DIR/home/AGENTS.md" ] || say_fail "home/AGENTS.md is missing"
[ "$(wc -l < "$DIR/home/AGENTS.md")" -le 25 ] || say_fail "home/AGENTS.md is over 25 lines; it is loaded into every session"
grep -qx '@AGENTS.md' "$DIR/CLAUDE.md" || say_fail "CLAUDE.md must import AGENTS.md with a bare @AGENTS.md line"
# shellcheck disable=SC2016
grep -q 'install -m 644 "${./home/AGENTS.md}" "$HOME/.claude/CLAUDE.md"' "$DIR/home.nix" \
  || say_fail "home.nix must install home/AGENTS.md as a plain copy at ~/.claude/CLAUDE.md (the desktop app skips symlinks and outside imports)"

# the human-facing docs bootstrap.sh and the README point at
[ -f "$DIR/README.md" ] || say_fail "README.md is missing"
[ -f "$DIR/SETUP.md" ] || say_fail "SETUP.md is missing"
[ -f "$DIR/PHONE.md" ] || say_fail "PHONE.md is missing"
[ -f "$DIR/BRAIN.md" ] || say_fail "BRAIN.md is missing"
if [ -d "$DIR/vault" ] && find "$DIR/vault" -type f -print -quit | grep -q .; then
  say_fail "the private brain is a separate repo; no public vault scaffold belongs here"
fi

# settings.json parses and keeps the few rules that protect irreversible actions
jq -e . "$DIR/home/.claude/settings.json" >/dev/null || say_fail "home/.claude/settings.json does not parse"
jq -e '.permissions.deny | index("Bash(git push --force:*)") and index("Bash(gh pr merge:*)") and index("Bash(gh repo delete:*)")' \
  "$DIR/home/.claude/settings.json" >/dev/null || say_fail "settings.json: the force-push, PR-merge, repo-delete denies are missing"
jq -e '(.permissions.ask | index("Bash(git push:*)")) == null and (.permissions.ask | index("Bash(gh pr create:*)")) == null' \
  "$DIR/home/.claude/settings.json" >/dev/null || say_fail "settings.json: routine GitHub work must not ask again"
jq -e '.attribution.commit == "" and .attribution.pr == ""' "$DIR/home/.claude/settings.json" >/dev/null \
  || say_fail "settings.json: attribution must be empty strings (no co-author lines)"
jq -e '.sandbox.enabled == true' "$DIR/home/.claude/settings.json" >/dev/null || say_fail "settings.json: the sandbox must be on"
jq -e '.autoMemoryEnabled == false' "$DIR/home/.claude/settings.json" >/dev/null \
  || say_fail "settings.json: auto memory must stay off; durable memory lives in brain"
jq -e '.remoteControlAtStartup == true and .agentPushNotifEnabled == true and .inputNeededNotifEnabled == true' \
  "$DIR/home/.claude/settings.json" >/dev/null || say_fail "settings.json: Remote Control at startup and both push toggles must stay on (the phone link)"
# a "privacy hardening" env var here silently deletes Remote Control
if jq -e '.env | type == "object"' "$DIR/home/.claude/settings.json" >/dev/null 2>&1; then
  for k in DO_NOT_TRACK DISABLE_TELEMETRY CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC DISABLE_GROWTHBOOK ANTHROPIC_BASE_URL ANTHROPIC_API_KEY ANTHROPIC_AUTH_TOKEN; do
    jq -e --arg k "$k" '.env[$k] == null' "$DIR/home/.claude/settings.json" >/dev/null \
      || say_fail "settings.json: env.$k would kill Remote Control"
  done
fi

# the casks that must never go missing, and the tokens that must never be wrong
for c in '"claude"' '"claude-code@latest"' '"chatgpt"' '"codex"' '"grok-build"' '"1password"' '"ghostty"' '"google-chrome"' '"microsoft-outlook"'; do
  grep -q "$c" "$DIR/configuration.nix" || say_fail "configuration.nix: cask $c is missing"
done
grep -q 'stablyai/orca/orca' "$DIR/configuration.nix" || say_fail "configuration.nix: cask stablyai/orca/orca is missing"
grep -qE '^[[:space:]]*"gh"[[:space:]]' "$DIR/configuration.nix" || say_fail "configuration.nix: official gh formula is missing"
if grep -qE '^[[:space:]]*"automic-vault/isotopes/gh-cli"' "$DIR/configuration.nix"; then
  say_fail "configuration.nix: Automic gh-cli prompts on every call; use official gh"
fi

# Grok bypass stays allowed. Do not flip this to true.
[ -f "$DIR/home/.grok/requirements.toml" ] || say_fail "home/.grok/requirements.toml is missing"
grep -q 'disable_bypass_permissions_mode = false' "$DIR/home/.grok/requirements.toml" \
  || say_fail "home/.grok/requirements.toml must set disable_bypass_permissions_mode = false"
if grep -q 'disable_bypass_permissions_mode = true' "$DIR/home/.grok/requirements.toml"; then
  say_fail "home/.grok/requirements.toml must not pin bypass off"
fi
grep -q 'etc."grok/requirements.toml"' "$DIR/configuration.nix" \
  || say_fail "configuration.nix must install home/.grok/requirements.toml to /etc/grok/requirements.toml"
if grep -qE '"claude-code"[^@]' "$DIR/configuration.nix"; then say_fail "configuration.nix: the stable claude-code cask conflicts with claude-code@latest"; fi
if grep -qE '^\s*"orca"' "$DIR/configuration.nix"; then say_fail "configuration.nix: bare orca token resolves to a disabled Plotly cask; use stablyai/orca/orca"; fi
grep -q 'cleanup = "zap"' "$DIR/configuration.nix" || say_fail "configuration.nix: cleanup must stay zap"
while IFS= read -r tap; do
  grep -q "name = \"$tap\"; trusted = true;" "$DIR/configuration.nix" || say_fail "configuration.nix: tap $tap must carry trusted = true"
done < <(grep -oE 'name = "[^"]+"' "$DIR/configuration.nix" | sed 's/name = "//; s/"//')

# Fresh-machine executables are immutable before they run.
grep -q 'NIX_INSTALLER_VERSION="v3.22.3"' "$DIR/bootstrap.sh" \
  || say_fail "bootstrap.sh: Determinate installer version is not pinned"
grep -q '61dbd9b6c74a66cc580d36e80214438bd19455bbab7efd79f2903445e16e82b9' "$DIR/bootstrap.sh" \
  || say_fail "bootstrap.sh: Determinate installer checksum is missing"
if grep -q 'install.determinate.systems/nix' "$DIR/bootstrap.sh"; then
  say_fail "bootstrap.sh: mutable pipe-to-shell Determinate installer returned"
fi
# shellcheck disable=SC2016
grep -q 'run "$DIR#darwin-rebuild"' "$DIR/bootstrap.sh" \
  || say_fail "bootstrap.sh: first darwin-rebuild must use the local locked flake app"
grep -q 'apps.aarch64-darwin.darwin-rebuild' "$DIR/flake.nix" \
  || say_fail "flake.nix: locked darwin-rebuild app is missing"
if grep -qE 'github:nix-darwin/.+#darwin-rebuild' "$DIR/bootstrap.sh"; then
  say_fail "bootstrap.sh: mutable remote darwin-rebuild returned"
fi

# lazy.nvim is checked out to the lock commit before any of its Lua runs.
jq -e 'all(.[]; .commit | test("^[0-9a-f]{40}$"))' "$DIR/home/.config/nvim/lazy-lock.json" >/dev/null \
  || say_fail "lazy-lock.json: every plugin needs a 40-character commit"
grep -q 'lazy-lock.json' "$DIR/home/.config/nvim/lua/plugin.lua" \
  || say_fail "plugin.lua: lazy.nvim bootstrap does not read the lock"
grep -q "'fetch'" "$DIR/home/.config/nvim/lua/plugin.lua" \
  || say_fail "plugin.lua: lazy.nvim bootstrap does not fetch the locked commit"
grep -q "'checkout', '--detach'" "$DIR/home/.config/nvim/lua/plugin.lua" \
  || say_fail "plugin.lua: lazy.nvim bootstrap does not detach at the locked commit"
if grep -q -- '--branch=stable' "$DIR/home/.config/nvim/lua/plugin.lua"; then
  say_fail "plugin.lua: mutable lazy.nvim stable bootstrap returned"
fi

# the 1Password agent path is the real one
grep -q '2BUA8C4S2C.com.1password/t/agent.sock' "$DIR/home.nix" || say_fail "home.nix: 1Password agent socket path is wrong"
if grep -q 'group.com.1password' "$DIR/home.nix"; then say_fail "home.nix: '2BUA8C4S2C.group.com.1password' is not a real container"; fi

# scripts parse
for s in "$DIR"/bootstrap.sh "$DIR"/rebuild.sh "$DIR"/tests/*.sh; do bash -n "$s" || say_fail "$s does not parse"; done

# no em dash in anything an agent reads
if git -C "$DIR" ls-files -z 2>/dev/null | (cd "$DIR" && xargs -0 grep -lF $'\xe2\x80\x94' 2>/dev/null) | grep -q .; then say_fail "em dash found in a tracked file"; fi

if [ "$fail" = 0 ]; then echo "ok: links, instruction files, docs, settings, casks, taps, agent path, scripts, no em dash"; fi
exit "$fail"
