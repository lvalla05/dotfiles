#!/usr/bin/env bash
# Exercise the pinned Firstmate installer without network access or an AI launch.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
fixture="$(mktemp -d)"
trap 'rm -rf "$fixture"' EXIT
mkdir -p "$fixture/bin" "$fixture/local-bin"
export FIRSTMATE_TEST_GIT_LOG="$fixture/git.log"

cat > "$fixture/bin/git" <<'STUB'
#!/usr/bin/env bash
set -euo pipefail
printf 'git' >> "$FIRSTMATE_TEST_GIT_LOG"
printf ' <%s>' "$@" >> "$FIRSTMATE_TEST_GIT_LOG"
printf '\n' >> "$FIRSTMATE_TEST_GIT_LOG"
if [ "${1:-}" = init ]; then
  target=${!#}
  mkdir -p "$target/.git" "$target/bin"
  printf '# test\n' > "$target/AGENTS.md"
  cat > "$target/bin/fm-bootstrap.sh" <<'BOOTSTRAP'
#!/usr/bin/env bash
if [ -n "${FIRSTMATE_TEST_BOOTSTRAP_OUTPUT:-}" ]; then
  printf '%s\n' "$FIRSTMATE_TEST_BOOTSTRAP_OUTPUT"
fi
exit "${FIRSTMATE_TEST_BOOTSTRAP_STATUS:-0}"
BOOTSTRAP
  chmod +x "$target/bin/fm-bootstrap.sh"
  exit 0
fi
[ "${1:-}" = -C ] || exit 2
root=$2
shift 2
case "$1 $2" in
  'remote add') printf '%s\n' "$4" > "$root/.git/test-origin" ;;
  'remote get-url') cat "$root/.git/test-origin" ;;
  'fetch --quiet') ;;
  'switch --quiet') printf '%s\n' "$5" > "$root/.git/test-head" ;;
  'branch --set-upstream-to=origin/main') ;;
  'rev-parse HEAD') cat "$root/.git/test-head" ;;
  'rev-parse --abbrev-ref') printf '%s\n' origin/main ;;
  'symbolic-ref --short') printf '%s\n' main ;;
  'status --porcelain') ;;
  *) printf 'unexpected fake git call:' >&2; printf ' <%s>' "$@" >&2; printf '\n' >&2; exit 2 ;;
esac
STUB
chmod +x "$fixture/bin/git"

cat > "$fixture/bin/orca" <<'STUB'
#!/usr/bin/env bash
printf '%s\n' '{"result":{"runtime":{"reachable":true,"state":"ready"}}}'
STUB
chmod +x "$fixture/bin/orca"
for tool in node gh no-mistakes gh-axi chrome-devtools-axi lavish-axi tasks-axi quota-axi; do
  printf '%s\n' '#!/usr/bin/env bash' 'exit 0' > "$fixture/bin/$tool"
  chmod +x "$fixture/bin/$tool"
done
export FIRSTMATE_TEST_PI_LOG="$fixture/pi-launched"
cat > "$fixture/bin/pi" <<'STUB'
#!/usr/bin/env bash
: > "$FIRSTMATE_TEST_PI_LOG"
STUB
chmod +x "$fixture/bin/pi"

# These stubs cover base installation and config guards. Real Git reconstruction
# and compatibility upgrades are exercised by firstmate-source.test.sh.
mkdir -p "$fixture/distribution/bin"
cp "$DIR/home/bin/firstmate" "$fixture/distribution/bin/firstmate"
script="$fixture/distribution/bin/firstmate"
PATH="$fixture/bin:$PATH" \
  FIRSTMATE_INSTALL_ROOT="$fixture/firstmate" \
  FIRSTMATE_BIN_DIR="$fixture/local-bin" \
  bash "$script" install > "$fixture/output"

grep -F 'a913539423076f12a7034c73e06e2e84653024a8' "$fixture/output" >/dev/null
[ "$(cat "$fixture/firstmate/config/backend")" = orca ]
[ "$(cat "$fixture/firstmate/config/crew-harness")" = pi ]
[ ! -e "$fixture/firstmate/.env" ]
[ ! -e "$fixture/firstmate/config/secondmate-harness" ]
jq -e '
  .rules[0].use == {"harness":"cursor", "model":"gpt-5.6-sol-high"} and
  .default == {"harness":"pi", "model":"openai-codex/gpt-5.6-luna", "effort":"xhigh"}
' "$fixture/firstmate/config/crew-dispatch.json" >/dev/null
grep -F 'exec pi --model openai-codex/gpt-5.6-luna --thinking xhigh' "$script" >/dev/null
[ "$(readlink -f "$fixture/local-bin/firstmate")" = "$(readlink -f "$script")" ]

fetches_before=$(grep -c '<fetch> <--quiet>' "$FIRSTMATE_TEST_GIT_LOG")
PATH="$fixture/bin:$PATH" \
  FIRSTMATE_INSTALL_ROOT="$fixture/firstmate" \
  FIRSTMATE_BIN_DIR="$fixture/local-bin" \
  bash "$script" install > "$fixture/output"
[ "$(grep -c '<fetch> <--quiet>' "$FIRSTMATE_TEST_GIT_LOG")" -eq "$fetches_before" ]

mv "$fixture/firstmate/config/backend" "$fixture/backend.saved"
if PATH="$fixture/bin:$PATH" \
  FIRSTMATE_INSTALL_ROOT="$fixture/firstmate" \
  FIRSTMATE_BIN_DIR="$fixture/local-bin" \
  bash "$script" verify > "$fixture/error" 2>&1; then
  echo 'FAIL: verify accepted a missing configuration file'
  exit 1
fi
[ ! -e "$fixture/firstmate/config/backend" ] || { echo 'FAIL: verify mutated configuration'; exit 1; }
grep -F 'config/backend is missing' "$fixture/error" >/dev/null
mv "$fixture/backend.saved" "$fixture/firstmate/config/backend"

cp -R "$fixture/firstmate/config" "$fixture/config.before"
PATH="$fixture/bin:$PATH" \
  FIRSTMATE_TEST_BOOTSTRAP_OUTPUT='BOOTSTRAP_INFO: benign test fact' \
  FIRSTMATE_INSTALL_ROOT="$fixture/firstmate" \
  FIRSTMATE_BIN_DIR="$fixture/local-bin" \
  bash "$script" verify > "$fixture/output"
diff -r "$fixture/config.before" "$fixture/firstmate/config" >/dev/null
grep -F 'required tools, and Orca readiness verified' "$fixture/output" >/dev/null

if PATH="$fixture/bin:$PATH" \
  FIRSTMATE_TEST_BOOTSTRAP_OUTPUT='MISSING: no-mistakes (test fixture)' \
  FIRSTMATE_INSTALL_ROOT="$fixture/firstmate" \
  FIRSTMATE_BIN_DIR="$fixture/local-bin" \
  bash "$script" verify > "$fixture/error" 2>&1; then
  echo 'FAIL: verify accepted an exit-zero bootstrap readiness problem'
  exit 1
fi
grep -F 'MISSING: no-mistakes (test fixture)' "$fixture/error" >/dev/null
grep -F 'bootstrap reported readiness problems' "$fixture/error" >/dev/null
diff -r "$fixture/config.before" "$fixture/firstmate/config" >/dev/null

if PATH="$fixture/bin:$PATH" \
  FIRSTMATE_TEST_BOOTSTRAP_OUTPUT='MISSING: no-mistakes (test fixture)' \
  FIRSTMATE_INSTALL_ROOT="$fixture/firstmate" \
  FIRSTMATE_BIN_DIR="$fixture/local-bin" \
  bash "$script" launch > "$fixture/error" 2>&1; then
  echo 'FAIL: launch accepted an exit-zero bootstrap readiness problem'
  exit 1
fi
[ ! -e "$FIRSTMATE_TEST_PI_LOG" ] || { echo 'FAIL: rejected launch reached Pi'; exit 1; }

if PATH="$fixture/bin:$PATH" \
  FIRSTMATE_TEST_BOOTSTRAP_OUTPUT='detector crashed (test fixture)' \
  FIRSTMATE_TEST_BOOTSTRAP_STATUS=7 \
  FIRSTMATE_INSTALL_ROOT="$fixture/firstmate" \
  FIRSTMATE_BIN_DIR="$fixture/local-bin" \
  bash "$script" verify > "$fixture/error" 2>&1; then
  echo 'FAIL: verify accepted a failed bootstrap detector'
  exit 1
fi
grep -F 'detector crashed (test fixture)' "$fixture/error" >/dev/null
grep -F 'bootstrap detection failed' "$fixture/error" >/dev/null
diff -r "$fixture/config.before" "$fixture/firstmate/config" >/dev/null

# Persistent secondmates use Firstmate's own configuration resolver.
# Verification must preserve an explicitly configured supported profile.
printf '%s\n' 'pi openai-codex/gpt-5.6-luna xhigh' > "$fixture/firstmate/config/secondmate-harness"
PATH="$fixture/bin:$PATH" \
  FIRSTMATE_INSTALL_ROOT="$fixture/firstmate" \
  FIRSTMATE_BIN_DIR="$fixture/local-bin" \
  bash "$script" verify > "$fixture/output"
[ "$(cat "$fixture/firstmate/config/secondmate-harness")" = 'pi openai-codex/gpt-5.6-luna xhigh' ]

printf '%s\n' tmux > "$fixture/firstmate/config/backend"
if PATH="$fixture/bin:$PATH" \
  FIRSTMATE_INSTALL_ROOT="$fixture/firstmate" \
  FIRSTMATE_BIN_DIR="$fixture/local-bin" \
  bash "$script" install > "$fixture/error" 2>&1; then
  echo 'FAIL: installer overwrote divergent local configuration'
  exit 1
fi
[ "$(cat "$fixture/firstmate/config/backend")" = tmux ]
grep -F 'refusing to overwrite local configuration' "$fixture/error" >/dev/null

echo 'ok: pinned source, preserved config, read-only verification, and faithful bootstrap diagnostics'
