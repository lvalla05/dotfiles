#!/usr/bin/env bash
# Exercise the real scripts with temporary Git checkouts and no host activation.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
TEST_DIR="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-activation-test.XXXXXX")"
TEST_DIR="$(cd "$TEST_DIR" && pwd -P)"
trap 'rm -rf -- "$TEST_DIR"' EXIT
TEST_LINK="$TEST_DIR/live-link"
TEST_CALLS="$TEST_DIR/calls"
TEST_UID=501
export TEST_LINK TEST_CALLS TEST_UID

git init -q -b main "$TEST_DIR/primary"
cp "$DIR/bootstrap.sh" "$DIR/rebuild.sh" "$TEST_DIR/primary/"
git -C "$TEST_DIR/primary" add bootstrap.sh rebuild.sh
git -C "$TEST_DIR/primary" -c user.name=Test -c user.email=test@example.invalid \
  -c commit.gpgSign=false commit -qm fixture
git -C "$TEST_DIR/primary" worktree add -q --force "$TEST_DIR/worker" main

# Only operations on ~/.dotfiles are redirected. HOME itself is never changed.
test() {
  if [ "$#" -eq 2 ] && [ "$2" = "$HOME/.dotfiles" ]; then
    builtin test "$1" "$TEST_LINK"
  else
    builtin test "$@"
  fi
}
readlink() {
  if [ "$1" = "$HOME/.dotfiles" ]; then
    command readlink "$TEST_LINK"
  else
    command readlink "$@"
  fi
}
id() { printf '%s\n' "$TEST_UID"; }
curl() { printf 'curl\n' >> "$TEST_CALLS"; return 99; }
ln() {
  printf 'ln\n' >> "$TEST_CALLS"
  [ "$#" -eq 3 ] && [ "$1" = -s ] && [ "$3" = "$HOME/.dotfiles" ] || return 99
  command ln -s "$2" "$TEST_LINK"
}
export -f test readlink id curl ln

# exec sudo bypasses shell functions, so supply an executable that only records arguments.
mkdir "$TEST_DIR/bin"
# shellcheck disable=SC2016 # Expansion belongs to the fake sudo process.
printf '%s\n' '#!/bin/bash' 'printf "sudo %s\n" "$*" >> "$TEST_CALLS"' > "$TEST_DIR/bin/sudo"
chmod +x "$TEST_DIR/bin/sudo"

reject() {
  local checkout="$1" reason="$2" script status output
  for script in bootstrap.sh rebuild.sh; do
    : > "$TEST_CALLS"
    status=0
    output=$(PATH="$TEST_DIR/bin:$PATH" BASH_ENV=/dev/null \
      /bin/bash "$checkout/$script" 2>&1) || status=$?
    if [ "$status" -ne 1 ] || [[ "$output" != *"$reason"* ]] || [ -s "$TEST_CALLS" ]; then
      printf 'FAIL %s: expected rejection before curl/ln/sudo; exit %s\n%s\n' "$script" "$status" "$output"
      exit 1
    fi
  done
}

# A real linked worktree must fail even when its link would otherwise be valid.
command ln -s "$TEST_DIR/worker" "$TEST_LINK"
reject "$TEST_DIR/worker" 'primary clone'
[ "$(command readlink "$TEST_LINK")" = "$TEST_DIR/worker" ]
command rm "$TEST_LINK"
git -C "$TEST_DIR/worker" switch -q --detach

mkdir "$TEST_LINK"
reject "$TEST_DIR/primary" 'not a symlink'
[ -d "$TEST_LINK" ]
rmdir "$TEST_LINK"

printf 'keep\n' > "$TEST_LINK"
reject "$TEST_DIR/primary" 'not a symlink'
[ "$(cat "$TEST_LINK")" = keep ]
command rm "$TEST_LINK"

command ln -s "$TEST_DIR/missing" "$TEST_LINK"
reject "$TEST_DIR/primary" 'Refusing to retarget'
[ "$(command readlink "$TEST_LINK")" = "$TEST_DIR/missing" ]
command rm "$TEST_LINK"

TEST_UID=0
reject "$TEST_DIR/primary" 'ordinary user'
TEST_UID=501
# A feature branch in the primary clone is allowed (with a note), only worktrees are refused.
git -C "$TEST_DIR/primary" switch -qc feature
: > "$TEST_CALLS"
output=$(PATH="$TEST_DIR/bin:$PATH" BASH_ENV=/dev/null /bin/bash "$TEST_DIR/primary/rebuild.sh" 2>&1)
[[ "$output" == *"branch 'feature'"* ]] || { printf 'FAIL feature branch should activate with a note\n%s\n' "$output"; exit 1; }
grep -q '^sudo ' "$TEST_CALLS" || { echo 'FAIL feature branch did not reach darwin-rebuild'; exit 1; }
command rm -f "$TEST_LINK"
git -C "$TEST_DIR/primary" switch -q main

# A primary checkout can create the initial link, then reuse it without rewriting it.
for expected_links in 1 0; do
  : > "$TEST_CALLS"
  PATH="$TEST_DIR/bin:$PATH" BASH_ENV=/dev/null /bin/bash "$TEST_DIR/primary/rebuild.sh"
  [ "$(command readlink "$TEST_LINK")" = "$TEST_DIR/primary" ]
  [ "$(grep -c '^ln$' "$TEST_CALLS" || true)" -eq "$expected_links" ]
  grep -Fxq "sudo /run/current-system/sw/bin/darwin-rebuild switch --flake $TEST_DIR/primary#mac" "$TEST_CALLS"
done

echo "ok: linked worktrees, root, and conflicting links rejected; feature branch allowed; primary link created once"
