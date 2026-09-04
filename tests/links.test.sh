#!/usr/bin/env bash
# Static checks for the drift this repo can actually suffer: a declared link
# whose target does not exist, an unparseable settings file, a cask line that
# went missing, an untrusted tap, an em dash in an instruction file.
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
[ "$(wc -l < "$DIR/home/AGENTS.md")" -le 30 ] || say_fail "home/AGENTS.md is over 30 lines; it is loaded into every session"
grep -qx '@AGENTS.md' "$DIR/CLAUDE.md" || say_fail "CLAUDE.md must import AGENTS.md with a bare @AGENTS.md line"
grep -q 'install -m 644 "${./home/AGENTS.md}" "$HOME/.claude/CLAUDE.md"' "$DIR/home.nix" \
  || say_fail "home.nix must install home/AGENTS.md as a plain copy at ~/.claude/CLAUDE.md (the desktop app skips symlinks and outside imports)"

# the human-facing docs bootstrap.sh and the README point at
[ -f "$DIR/README.md" ] || say_fail "README.md is missing"
[ -f "$DIR/SETUP.md" ] || say_fail "SETUP.md is missing"
[ -f "$DIR/PHONE.md" ] || say_fail "PHONE.md is missing"

# settings.json parses and keeps the few rules that protect irreversible actions
jq -e . "$DIR/home/.claude/settings.json" >/dev/null || say_fail "home/.claude/settings.json does not parse"
jq -e '.permissions.deny | index("Bash(git push --force:*)") and index("Bash(gh pr merge:*)") and index("Bash(gh repo delete:*)")' \
  "$DIR/home/.claude/settings.json" >/dev/null || say_fail "settings.json: the force-push, PR-merge, repo-delete denies are missing"
jq -e '.attribution.commit == "" and .attribution.pr == ""' "$DIR/home/.claude/settings.json" >/dev/null \
  || say_fail "settings.json: attribution must be empty strings (no co-author lines)"
jq -e '.sandbox.enabled == true' "$DIR/home/.claude/settings.json" >/dev/null || say_fail "settings.json: the sandbox must be on"
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
for c in '"claude"' '"claude-code@latest"' '"chatgpt"' '"codex"' '"grok-build"' '"1password"' '"ghostty"' '"google-chrome"'; do
  grep -q "$c" "$DIR/configuration.nix" || say_fail "configuration.nix: cask $c is missing"
done
grep -q 'stablyai/orca/orca' "$DIR/configuration.nix" || say_fail "configuration.nix: cask stablyai/orca/orca is missing"
if grep -qE '"claude-code"[^@]' "$DIR/configuration.nix"; then say_fail "configuration.nix: the stable claude-code cask conflicts with claude-code@latest"; fi
if grep -qE '^\s*"orca"' "$DIR/configuration.nix"; then say_fail "configuration.nix: bare orca token resolves to a disabled Plotly cask; use stablyai/orca/orca"; fi
grep -q 'cleanup = "zap"' "$DIR/configuration.nix" || say_fail "configuration.nix: cleanup must stay zap"
while IFS= read -r tap; do
  grep -q "name = \"$tap\"; trusted = true;" "$DIR/configuration.nix" || say_fail "configuration.nix: tap $tap must carry trusted = true"
done < <(grep -oE 'name = "[^"]+"' "$DIR/configuration.nix" | sed 's/name = "//; s/"//')

# the 1Password agent path is the real one
grep -q '2BUA8C4S2C.com.1password/t/agent.sock' "$DIR/home.nix" || say_fail "home.nix: 1Password agent socket path is wrong"
if grep -q 'group.com.1password' "$DIR/home.nix"; then say_fail "home.nix: '2BUA8C4S2C.group.com.1password' is not a real container"; fi

# scripts parse
for s in "$DIR"/bootstrap.sh "$DIR"/rebuild.sh "$DIR"/tests/*.sh; do bash -n "$s" || say_fail "$s does not parse"; done

# no em dash in anything an agent reads
if git -C "$DIR" ls-files -z 2>/dev/null | (cd "$DIR" && xargs -0 grep -lF $'\xe2\x80\x94' 2>/dev/null) | grep -q .; then say_fail "em dash found in a tracked file"; fi

if [ "$fail" = 0 ]; then echo "ok: links, instruction files, docs, settings, casks, taps, agent path, scripts, no em dash"; fi
exit "$fail"
