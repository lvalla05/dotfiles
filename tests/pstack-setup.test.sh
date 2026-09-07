#!/usr/bin/env bash
# Exercise pstack readiness and rule preservation without a live account or AI call.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
fixture="$(mktemp -d)"
trap 'rm -rf "$fixture"' EXIT
mkdir -p "$fixture/bin" "$fixture/home"
export PSTACK_TEST_LOG="$fixture/cursor.log"

cat > "$fixture/bin/cursor-agent" <<'STUB'
#!/usr/bin/env bash
set -euo pipefail
printf 'cursor-agent' >> "$PSTACK_TEST_LOG"
printf ' <%s>' "$@" >> "$PSTACK_TEST_LOG"
printf '\n' >> "$PSTACK_TEST_LOG"
if [ "${1:-}" = plugin ]; then
  printf '%s\n' '[{"name":"cursor-public","scope":"global"}]'
elif [ "${1:-}" = models ]; then
  for model in claude-fable-5-1-high gemini-3.8-flash-high gpt-5.6-luna-xhigh gpt-5.6-sol-high cursor-grok-4.6-xhigh; do
    printf '%s - available\n' "$model"
  done
else
  if [ "${PSTACK_TEST_SLEEP:-0}" = 1 ]; then sleep 10; fi
  if [ "${PSTACK_TEST_FAIL:-0}" = 1 ]; then exit 7; fi
  printf '%s\n' "${PSTACK_TEST_PROBE_OUTPUT:-evacuate-ratchet-endgame}"
fi
STUB
chmod +x "$fixture/bin/cursor-agent"

script="$DIR/home/bin/pstack-setup"
HOME="$fixture/home" CURSOR_AGENT="$fixture/bin/cursor-agent" \
  zsh "$script" --check > "$fixture/output"
grep -F 'verified active skill: /technical-writing' "$fixture/output" >/dev/null
grep -F 'model rule: absent' "$fixture/output" >/dev/null
[ ! -e "$fixture/home/.cursor/rules/pstack-models.mdc" ]
grep -F '<--mode> <ask>' "$PSTACK_TEST_LOG" >/dev/null
grep -F '</technical-writing Use only the loaded skill instructions' "$PSTACK_TEST_LOG" >/dev/null

if HOME="$fixture/home" CURSOR_AGENT="$fixture/bin/cursor-agent" \
  PSTACK_TEST_PROBE_OUTPUT=unavailable zsh "$script" --check > "$fixture/error" 2>&1; then
  echo 'FAIL: inactive pstack skill was accepted'
  exit 1
fi
grep -F '/technical-writing was not proven active' "$fixture/error" >/dev/null
[ ! -e "$fixture/home/.cursor/rules/pstack-models.mdc" ]

for scenario in timeout nonzero; do
  if env HOME="$fixture/home" CURSOR_AGENT="$fixture/bin/cursor-agent" \
    PSTACK_PROBE_TIMEOUT_SECONDS=1 PSTACK_TEST_SLEEP="$([ "$scenario" = timeout ] && echo 1 || echo 0)" \
    PSTACK_TEST_FAIL="$([ "$scenario" = nonzero ] && echo 1 || echo 0)" \
    zsh "$script" --apply > "$fixture/error" 2>&1; then
    echo "FAIL: $scenario probe was accepted"
    exit 1
  fi
  [ ! -e "$fixture/home/.cursor/rules/pstack-models.mdc" ]
done
grep -F 'exited with status 7' "$fixture/error" >/dev/null

HOME="$fixture/home" CURSOR_AGENT="$fixture/bin/cursor-agent" \
  zsh "$script" --apply > "$fixture/output"
rule="$fixture/home/.cursor/rules/pstack-models.mdc"
[ -f "$rule" ]
[ "$(stat -f '%Lp' "$rule")" = 600 ]
rule_hash="$(shasum -a 256 "$rule")"
printf '%s\n' 'local preference' > "$rule"
HOME="$fixture/home" CURSOR_AGENT="$fixture/bin/cursor-agent" \
  zsh "$script" --apply > "$fixture/output"
[ "$(cat "$rule")" = 'local preference' ]
grep -F 'preserved existing file' "$fixture/output" >/dev/null
[ "$rule_hash" != "$(shasum -a 256 "$rule")" ]

rm "$rule"
ln -s "$fixture/home/missing-local-preference" "$rule"
HOME="$fixture/home" CURSOR_AGENT="$fixture/bin/cursor-agent" \
  zsh "$script" --apply > "$fixture/output"
[ -L "$rule" ]
[ "$(readlink "$rule")" = "$fixture/home/missing-local-preference" ]
grep -F 'preserved existing file' "$fixture/output" >/dev/null

if grep -Eq 'plugin_cache|sort -r|\.cache-complete' "$script"; then
  echo 'FAIL: helper still selects marketplace cache hashes'
  exit 1
fi
echo 'ok: fresh named-skill proof, model checks, bounded apply, and existing-rule preservation'
