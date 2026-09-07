#!/usr/bin/env bash
# Exercise installer selection without downloading or changing real packages.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
fixture="$(mktemp -d)"
trap 'rm -rf "$fixture"' EXIT
mkdir -p "$fixture/bin"
export INSTALL_LOG="$fixture/installs"
for installer in npm go; do
  cat > "$fixture/bin/$installer" <<'STUB'
#!/usr/bin/env bash
printf '%s' "${0##*/}" >> "$INSTALL_LOG"
printf ' <%s>' "$@" >> "$INSTALL_LOG"
printf '\n' >> "$INSTALL_LOG"
STUB
  chmod +x "$fixture/bin/$installer"
done
export PATH="$fixture/bin:$PATH"
script="$DIR/home/bin/agent-tools"
bash "$script" --list > "$fixture/list"
[ ! -e "$INSTALL_LOG" ] || { echo 'FAIL: listing installed packages'; exit 1; }
for expected in \
  'treehouse      github.com/kunchenguid/treehouse@v2.3.0' \
  'no-mistakes    github.com/kunchenguid/no-mistakes/cmd/no-mistakes@v1.68.0' \
  'chrome-devtools-axi chrome-devtools-axi@0.1.34' \
  'lavish-axi     lavish-axi@0.1.66' \
  'tasks-axi      tasks-axi@0.2.5' \
  'quota-axi      quota-axi@0.1.38' \
  'gh-axi         gh-axi@0.1.35' \
  'gnhf           gnhf@0.1.49' \
  'pi             @earendil-works/pi-coding-agent@0.85.1'; do
  grep -F "$expected" "$fixture/list" >/dev/null
done
if bash "$script" pi unknown-tool > "$fixture/error" 2>&1; then
  echo 'FAIL: invalid selection was accepted'; exit 1
fi
[ ! -e "$INSTALL_LOG" ] || { echo 'FAIL: invalid selection partially installed'; exit 1; }
bash "$script" pi > "$fixture/output"
[ "$(wc -l < "$INSTALL_LOG" | tr -d ' ')" = 1 ]
grep -F 'npm <install> <--global> <--ignore-scripts> <--prefix>' "$INSTALL_LOG" >/dev/null
grep -F "<$HOME/.local> <@earendil-works/pi-coding-agent@" "$INSTALL_LOG" >/dev/null
: > "$INSTALL_LOG"
bash "$script" treehouse quota-axi > "$fixture/output"
[ "$(wc -l < "$INSTALL_LOG" | tr -d ' ')" = 2 ]
grep -F 'go <install> <github.com/kunchenguid/treehouse@' "$INSTALL_LOG" >/dev/null
grep -F 'npm <install> <--global> <--prefix>' "$INSTALL_LOG" >/dev/null
grep -F '<quota-axi@' "$INSTALL_LOG" >/dev/null
: > "$INSTALL_LOG"
bash "$script" no-mistakes chrome-devtools-axi lavish-axi tasks-axi > "$fixture/output"
[ "$(wc -l < "$INSTALL_LOG" | tr -d ' ')" = 4 ]
grep -F 'go <install> <github.com/kunchenguid/no-mistakes/cmd/no-mistakes@v1.68.0>' "$INSTALL_LOG" >/dev/null
for package in chrome-devtools-axi lavish-axi tasks-axi; do
  grep -F "npm <install> <--global> <--ignore-scripts> <--prefix> <$HOME/.local> <$package@" "$INSTALL_LOG" >/dev/null
done
echo 'ok: exact lock listing, all-or-nothing selection validation, pinned targeted installers'
