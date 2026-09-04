#!/usr/bin/env bash
# Check source-file contracts, parsed settings, and the evaluated Nix declaration.
# These checks do not install apps or activate the machine configuration.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
fail=0
say_fail() { echo "FAIL $1"; fail=1; }

# Check lexically listed live-link targets exist; this does not run activation.
while IFS= read -r rel; do
  [ -e "$DIR/$rel" ] || say_fail "home.nix links $rel but it does not exist"
done < <(grep -oE 'dotfiles}/[^"]+' "$DIR/home.nix" | sed 's|dotfiles}/||' | sort -u)

# Instruction source files and the root Claude import are byte-level contracts.
[ -f "$DIR/home/AGENTS.md" ] || say_fail "home/AGENTS.md is missing"
[ "$(wc -l < "$DIR/home/AGENTS.md")" -le 25 ] || say_fail "home/AGENTS.md is over 25 lines; it is loaded into every session"
grep -qx '@AGENTS.md' "$DIR/CLAUDE.md" || say_fail "CLAUDE.md must import AGENTS.md with a bare @AGENTS.md line"

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
jq -e '(.timeFormat // "auto") as $format | ($format | type) == "string" and
  ((["auto", "12-hour", "24-hour", "24-hour-utc"] | index($format)) != null or ($format | contains("%")))' \
  "$DIR/home/.claude/settings.json" >/dev/null || say_fail "settings.json: timeFormat must be a supported preset or strftime pattern"
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

# Inspect effective values, so comments and disabled declarations cannot pass.
# shellcheck disable=SC2016
if declaration=$(nix eval --json "$DIR#darwinConfigurations.mac.config" --apply '
  c: let hm = c.home-manager.users.${c.system.primaryUser}; in {
    cleanup = c.homebrew.onActivation.cleanup;
    brews = map (x: x.name) c.homebrew.brews;
    casks = map (x: x.name) c.homebrew.casks;
    taps = map (x: { inherit (x) name trusted; }) c.homebrew.taps;
    grok = builtins.fromTOML (builtins.readFile c.environment.etc."grok/requirements.toml".source);
    homeDirectory = hm.home.homeDirectory;
    sshAuthSock = hm.home.sessionVariables.SSH_AUTH_SOCK;
    sshConfig = hm.home.file.".ssh/config".text;
  }'); then
  jq -e '.casks as $installed |
    all(["claude", "claude-code@latest", "chatgpt", "codex", "grok-build", "1password",
         "ghostty", "google-chrome", "microsoft-outlook", "stablyai/orca/orca"][];
        . as $required | $installed | index($required)) and
    ($installed | index("claude-code") == null and index("orca") == null)' \
    <<< "$declaration" >/dev/null || say_fail "Nix declaration: required cask missing or conflicting Claude/Orca cask declared"
  jq -e '.brews | index("gh") != null and index("automic-vault/isotopes/gh-cli") == null' \
    <<< "$declaration" >/dev/null || say_fail "Nix declaration: use official gh without the Automic isotope"
  jq -e '.cleanup == "zap"' <<< "$declaration" >/dev/null \
    || say_fail "Nix declaration: cleanup must stay zap"
  jq -e '(.taps | map(.name)) as $names |
    ($names | index("automic-vault/isotopes") != null and index("stablyai/orca") != null) and
    all(.taps[]; .trusted == true)' <<< "$declaration" >/dev/null \
    || say_fail "Nix declaration: required vendor taps must be present and trusted"
  jq -e '.grok.ui.disable_bypass_permissions_mode == false' <<< "$declaration" >/dev/null \
    || say_fail "Nix declaration: installed Grok requirements must allow bypass"
  jq -e '(.homeDirectory + "/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock") as $socket |
    .sshAuthSock == $socket and (.sshConfig | contains("IdentityAgent \"" + $socket + "\""))' \
    <<< "$declaration" >/dev/null || say_fail "Nix declaration: SSH must use the correct 1Password agent socket"
else
  say_fail "Nix declaration could not be evaluated"
fi

# Validate persisted plugin identities, not whether the plugins execute successfully.
jq -e 'type == "object" and length > 0 and has("lazy.nvim") and
  all(.[]; type == "object" and
    (.commit | type == "string" and test("^[0-9a-f]{40}$")) and
    (.branch | type == "string" and length > 0))' \
  "$DIR/home/.config/nvim/lazy-lock.json" >/dev/null \
  || say_fail "lazy-lock.json: require lazy.nvim and a valid commit and branch for every plugin"

# scripts parse
for s in "$DIR"/bootstrap.sh "$DIR"/rebuild.sh "$DIR"/tests/*.sh; do bash -n "$s" || say_fail "$s does not parse"; done
shellcheck "$DIR/bootstrap.sh" "$DIR/rebuild.sh" "$DIR"/tests/*.sh || say_fail "ShellCheck failed"

# no em dash in anything an agent reads
if git -C "$DIR" ls-files -z 2>/dev/null | (cd "$DIR" && xargs -0 grep -lF $'\xe2\x80\x94' 2>/dev/null) | grep -q .; then say_fail "em dash found in a tracked file"; fi

if [ "$fail" = 0 ]; then echo "ok: file contracts, settings, evaluated Nix policy, lock data, shell syntax/lint, no em dash"; fi
exit "$fail"
