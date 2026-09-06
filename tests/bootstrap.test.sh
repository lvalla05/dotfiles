#!/usr/bin/env bash
# A corrupt download must be rejected before any installer code runs.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
TEST_DIR="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-bootstrap-test.XXXXXX")"
trap 'rm -rf -- "$TEST_DIR"' EXIT
git init -q -b main "$TEST_DIR/primary"
cp "$DIR/bootstrap.sh" "$TEST_DIR/primary/bootstrap.sh"

# Redirect only the link preflight; never change HOME or the real ~/.dotfiles.
test() {
  if [ "$#" -eq 2 ] && [ "$2" = "$HOME/.dotfiles" ]; then
    return 1
  fi
  builtin test "$@"
}
id() { printf '501\n'; }

# Exclude installed Nix so bootstrap takes the download path. The fake installer
# exits 99 if verification is bypassed, before bootstrap can touch ~/.dotfiles.
if PATH=/usr/bin:/bin command -v nix >/dev/null 2>&1; then
  echo "FAIL cannot isolate the no-Nix bootstrap path"
  exit 1
fi
uname() { printf 'arm64\n'; }
curl() {
  local output=""
  while [ "$#" -gt 0 ]; do
    if [ "$1" = --output ]; then
      output="$2"
      shift 2
    else
      shift
    fi
  done
  [ -n "$output" ] || return 2
  printf '#!/bin/bash\nexit 99\n' > "$output"
}
export -f uname curl test id

status=0
output=$(PATH=/usr/bin:/bin BASH_ENV=/dev/null /bin/bash "$TEST_DIR/primary/bootstrap.sh" 2>&1) || status=$?
if [ "$status" -ne 1 ] || ! printf '%s\n' "$output" | grep -q ': FAILED'; then
  printf 'FAIL corrupt installer was not rejected by checksum verification (exit %s)\n%s\n' "$status" "$output"
  exit 1
fi
echo "ok: corrupt installer rejected before execution"
