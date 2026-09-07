#!/usr/bin/env bash
# Reconstruct the compatibility distribution with real Git, without network access.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
fixture=$(mktemp -d)
export GIT_CONFIG_NOSYSTEM=1
export GIT_CONFIG_GLOBAL=/dev/null
export GIT_ALLOW_PROTOCOL=file

cleanup() {
  local rc=$?
  if [ "$rc" -ne 0 ]; then
    echo 'FAIL: Firstmate real-Git distribution fixture stopped unexpectedly' >&2
    if [ -s "$fixture/output" ]; then
      echo '--- captured Firstmate output ---' >&2
      sed -n '1,160p' "$fixture/output" >&2
    fi
  fi
  rm -rf "$fixture"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_equal() { # <expected> <actual> <description>
  local expected=$1 actual=$2 description=$3
  [ "$actual" = "$expected" ] || fail "$description (expected '$expected', got '$actual')"
}

assert_contains() { # <needle> <path> <description>
  local needle=$1 path=$2 description=$3
  grep -Fq -- "$needle" "$path" || fail "$description"
}

assert_clean_source() { # <description>
  local description=$1 status
  status=$(git -C "$fixture/installed" status --porcelain)
  [ -z "$status" ] || fail "$description (status: $status)"
}

run_firstmate() {
  bash "$fixture/home/bin/firstmate" "$@"
}

expect_failure() { # <expected-message> <command> [args...]
  local expected=$1
  shift
  : > "$fixture/output"
  if "$@" > "$fixture/output" 2>&1; then
    fail "command unexpectedly succeeded while expecting: $expected"
  fi
  assert_contains "$expected" "$fixture/output" "failure did not explain: $expected"
}

mkdir -p "$fixture/upstream/bin" "$fixture/home/bin" \
  "$fixture/home/share/firstmate" "$fixture/local-bin" "$fixture/tools"
git -C "$fixture/upstream" init --quiet --initial-branch=main
git -C "$fixture/upstream" config user.name 'Fixture'
git -C "$fixture/upstream" config user.email 'fixture@localhost'
printf '# Firstmate fixture\n' > "$fixture/upstream/AGENTS.md"
printf 'config/\n' > "$fixture/upstream/.gitignore"
printf '#!/usr/bin/env bash\nexit 0\n' > "$fixture/upstream/bin/fm-bootstrap.sh"
chmod +x "$fixture/upstream/bin/fm-bootstrap.sh"
git -C "$fixture/upstream" add .
git -C "$fixture/upstream" -c commit.gpgsign=false commit --quiet -m 'Fixture base'
base=$(git -C "$fixture/upstream" rev-parse HEAD)

printf '# Firstmate fixture with Orca compatibility\n' > "$fixture/upstream/AGENTS.md"
printf 'new helper\n' > "$fixture/upstream/bin/new-helper"
git -C "$fixture/upstream" add -N bin/new-helper
git -C "$fixture/upstream" diff --binary --full-index > "$fixture/home/share/firstmate/orca.patch"
git -C "$fixture/upstream" add .
tree=$(git -C "$fixture/upstream" write-tree)
revision=$(printf '%s\n' 'Orca runtime compatibility' | \
  GIT_AUTHOR_NAME='Firstmate local distribution' GIT_AUTHOR_EMAIL='firstmate@localhost' \
  GIT_COMMITTER_NAME='Firstmate local distribution' GIT_COMMITTER_EMAIL='firstmate@localhost' \
  GIT_AUTHOR_DATE='2000-01-01T00:00:00 +0000' GIT_COMMITTER_DATE='2000-01-01T00:00:00 +0000' \
  git -C "$fixture/upstream" commit-tree "$tree" -p "$base")
digest=$(shasum -a 256 "$fixture/home/share/firstmate/orca.patch" | cut -d ' ' -f 1)
jq -n --arg base "$base" --arg revision "$revision" --arg tree "$tree" --arg digest "$digest" \
  '{baseRevision:$base,revision:$revision,tree:$tree,patchSha256:$digest}' \
  > "$fixture/home/share/firstmate/orca.lock.json"

python3 - "$DIR/home/bin/firstmate" "$fixture" "$base" <<'PY'
import pathlib, shlex, sys
source, fixture, base = sys.argv[1:]
s = pathlib.Path(source).read_text()
repository_pin = 'repository=https://github.com/kunchenguid/firstmate.git'
revision_pin = 'revision=a913539423076f12a7034c73e06e2e84653024a8'
if s.count(repository_pin) != 1 or s.count(revision_pin) != 1:
    raise SystemExit('fixture could not locate the exact Firstmate source pins')
s = s.replace(repository_pin, 'repository=' + shlex.quote(fixture + '/upstream'), 1)
s = s.replace(revision_pin, 'revision=' + base, 1)
pathlib.Path(fixture + '/home/bin/firstmate').write_text(s)
PY

cat > "$fixture/tools/orca" <<'STUB'
#!/usr/bin/env bash
printf '%s\n' '{"result":{"runtime":{"reachable":true,"state":"ready"}}}'
STUB
chmod +x "$fixture/tools/orca"
for tool in gh no-mistakes gh-axi chrome-devtools-axi lavish-axi tasks-axi quota-axi pi; do
  printf '%s\n' '#!/usr/bin/env bash' 'exit 0' > "$fixture/tools/$tool"
  chmod +x "$fixture/tools/$tool"
done

export FIRSTMATE_INSTALL_ROOT="$fixture/installed"
export FIRSTMATE_BIN_DIR="$fixture/local-bin"
export PATH="$fixture/tools:$PATH"

run_firstmate install > "$fixture/output" 2>&1
assert_equal "$revision" "$(git -C "$fixture/installed" rev-parse HEAD)" \
  'clean install did not select the deterministic compatibility revision'
assert_equal "$tree" "$(git -C "$fixture/installed" rev-parse 'HEAD^{tree}')" \
  'clean install did not reconstruct the reviewed compatibility tree'
assert_clean_source 'clean install left source changes'
assert_equal 'new helper' "$(cat "$fixture/installed/bin/new-helper")" \
  'clean install omitted the patched helper'
assert_equal origin/main "$(git -C "$fixture/installed" rev-parse --abbrev-ref '@{upstream}')" \
  'clean install did not retain the updateable upstream branch'
assert_equal "$fixture/upstream" "$(git -C "$fixture/installed" remote get-url origin)" \
  'clean install changed the pinned source origin'
assert_equal "$(readlink -f "$fixture/home/bin/firstmate")" \
  "$(readlink -f "$fixture/local-bin/firstmate")" \
  'clean install did not link the fixture wrapper'

source_head=$(git -C "$fixture/installed" rev-parse HEAD)
source_tree=$(git -C "$fixture/installed" rev-parse 'HEAD^{tree}')
cp -R "$fixture/installed/config" "$fixture/config.before-verify"
run_firstmate verify > "$fixture/output" 2>&1
assert_contains 'source, configuration, required tools, and Orca readiness verified' \
  "$fixture/output" 'verify did not complete against the clean fixture'
assert_equal "$source_head" "$(git -C "$fixture/installed" rev-parse HEAD)" \
  'verify changed the installed revision'
assert_equal "$source_tree" "$(git -C "$fixture/installed" rev-parse 'HEAD^{tree}')" \
  'verify changed the installed tree'
assert_clean_source 'verify changed the source checkout'
diff -r "$fixture/config.before-verify" "$fixture/installed/config" >/dev/null \
  || fail 'verify changed local configuration'

printf 'retained operational state\n' > "$fixture/installed/config/retained"
run_firstmate install > "$fixture/output" 2>&1
assert_equal "$revision" "$(git -C "$fixture/installed" rev-parse HEAD)" \
  'idempotent install changed the compatibility revision'
assert_equal 'retained operational state' "$(cat "$fixture/installed/config/retained")" \
  'idempotent install overwrote operational state'
assert_clean_source 'idempotent install left source changes'

cp "$fixture/home/share/firstmate/orca.lock.json" "$fixture/orca.lock.valid"
jq '.baseRevision = "0000000000000000000000000000000000000000"' \
  "$fixture/orca.lock.valid" > "$fixture/home/share/firstmate/orca.lock.json"
expect_failure 'invalid Orca compatibility manifest' run_firstmate install
assert_equal "$revision" "$(git -C "$fixture/installed" rev-parse HEAD)" \
  'tampered manifest changed the installed revision'
assert_equal 'retained operational state' "$(cat "$fixture/installed/config/retained")" \
  'tampered manifest changed operational state'
mv "$fixture/orca.lock.valid" "$fixture/home/share/firstmate/orca.lock.json"

cp "$fixture/home/share/firstmate/orca.patch" "$fixture/orca.patch.valid"
printf 'tamper\n' >> "$fixture/home/share/firstmate/orca.patch"
expect_failure 'Orca compatibility patch checksum differs' run_firstmate install
assert_equal "$revision" "$(git -C "$fixture/installed" rev-parse HEAD)" \
  'tampered patch changed the installed revision'
assert_equal 'retained operational state' "$(cat "$fixture/installed/config/retained")" \
  'tampered patch changed operational state'
mv "$fixture/orca.patch.valid" "$fixture/home/share/firstmate/orca.patch"

# Upgrading an existing clean upstream checkout must preserve private state.
git clone --quiet "$fixture/upstream" "$fixture/upgrade"
mkdir -p "$fixture/upgrade/config"
printf 'existing private state\n' > "$fixture/upgrade/config/retained"
FIRSTMATE_INSTALL_ROOT="$fixture/upgrade" run_firstmate install > "$fixture/output" 2>&1
assert_equal "$revision" "$(git -C "$fixture/upgrade" rev-parse HEAD)" \
  'existing upstream checkout did not fast-forward to the compatibility pin'
assert_equal 'existing private state' "$(cat "$fixture/upgrade/config/retained")" \
  'compatibility upgrade overwrote existing private state'
assert_equal '' "$(git -C "$fixture/upgrade" status --porcelain)" \
  'compatibility upgrade left source changes'

# A second compatibility release must reconstruct on a fresh install and
# fast-forward the first release while retaining private operational state.
cp "$fixture/home/share/firstmate/orca.patch" "$fixture/home/share/firstmate/orca-first.patch"
printf 'second helper\n' > "$fixture/upstream/bin/new-helper"
git -C "$fixture/upstream" diff --binary --full-index "$revision" > "$fixture/home/share/firstmate/orca.patch"
git -C "$fixture/upstream" add .
next_tree=$(git -C "$fixture/upstream" write-tree)
next_revision=$(printf '%s\n' 'Orca runtime compatibility' | \
  GIT_AUTHOR_NAME='Firstmate local distribution' GIT_AUTHOR_EMAIL='firstmate@localhost' \
  GIT_COMMITTER_NAME='Firstmate local distribution' GIT_COMMITTER_EMAIL='firstmate@localhost' \
  GIT_AUTHOR_DATE='2000-01-01T00:00:00 +0000' GIT_COMMITTER_DATE='2000-01-01T00:00:00 +0000' \
  git -C "$fixture/upstream" commit-tree "$next_tree" -p "$revision")
next_digest=$(shasum -a 256 "$fixture/home/share/firstmate/orca.patch" | cut -d ' ' -f 1)
jq --arg rev "$next_revision" --arg tree "$next_tree" --arg digest "$next_digest" \
  '.history = [{revision:.revision,tree:.tree,patch:"orca-first.patch",patchSha256:.patchSha256}] |
    .revision=$rev | .tree=$tree | .patchSha256=$digest' \
  "$fixture/home/share/firstmate/orca.lock.json" > "$fixture/next.lock"
mv "$fixture/next.lock" "$fixture/home/share/firstmate/orca.lock.json"
run_firstmate install > "$fixture/output" 2>&1
assert_equal "$next_revision" "$(git -C "$fixture/installed" rev-parse HEAD)" 'second release did not fast-forward'
assert_equal 'retained operational state' "$(cat "$fixture/installed/config/retained")" 'second release changed private state'
assert_clean_source 'second release left source changes'
FIRSTMATE_INSTALL_ROOT="$fixture/fresh-chain" FIRSTMATE_BIN_DIR="$fixture/fresh-bin" \
  run_firstmate install > "$fixture/output" 2>&1
assert_equal "$next_revision" "$(git -C "$fixture/fresh-chain" rev-parse HEAD)" 'fresh install did not reconstruct history'
assert_equal 'second helper' "$(cat "$fixture/fresh-chain/bin/new-helper")" 'fresh history has wrong source'
cp "$fixture/home/share/firstmate/orca-first.patch" "$fixture/history.valid"
printf 'tamper\n' >> "$fixture/home/share/firstmate/orca-first.patch"
expect_failure 'compatibility history patch checksum differs' run_firstmate verify
mv "$fixture/history.valid" "$fixture/home/share/firstmate/orca-first.patch"
revision=$next_revision

printf 'foreign edit\n' >> "$fixture/installed/AGENTS.md"
expect_failure 'unexpected worktree changes' run_firstmate install
assert_contains 'foreign edit' "$fixture/installed/AGENTS.md" \
  'dirty-source refusal overwrote the foreign edit'
assert_equal 'retained operational state' "$(cat "$fixture/installed/config/retained")" \
  'dirty-source refusal changed operational state'

echo 'ok: clean deterministic reconstruction, state-preserving upgrade, idempotence, read-only verify, and tamper/dirty refusal'
