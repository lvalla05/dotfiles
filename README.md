# dotfiles

Nix-darwin plus home-manager. One command. A wiped Mac comes back the same.

Orca is the ADE. The CLI in a pane is whichever harness the job needs.
None of them is permanent. Memory lives in the private `brain` repo, opened in Obsidian.

## What you get

- macOS defaults, Touch ID sudo, zap Homebrew
- Ghostty, Chrome, 1Password
- Orca (parallel sessions, worktrees, diffs)
- Declared harness CLIs, none primary
- Official `gh` over HTTPS
- One `home/AGENTS.md` every harness reads
- Obsidian as the memory surface, backed by a separate private `brain` repo

## Fresh Mac

```sh
git clone https://github.com/lvalla05/dotfiles.git ~/orca/projects/dotfiles
cd ~/orca/projects/dotfiles
./bootstrap.sh
```

Then `SETUP.md` (1Password, official `gh`, private brain, Orca, Obsidian). Then `PHONE.md`.

Check without applying:

```sh
nix flake check --no-build
nix build .#darwinConfigurations.mac.system --dry-run
bash tests/links.test.sh
```

## Daily use

```sh
./rebuild.sh
```

Files under `home/` that are live-symlinked do not need a rebuild.

## Make it yours

- **Username.** `user = "likhithvalla"` in `flake.nix`, or let `bootstrap.sh` rewrite it.
- **Host label** `"mac"` in `flake.nix`, `rebuild.sh`, and `bootstrap.sh`. All three must match.
- **Git identity** in `home.nix`. Change it before your first rebuild if this is not your machine.

**Zap.** Anything not in `brews` / `casks` / `masApps` is removed on switch.
Keep `claude` and `claude-code@latest`. Orca is `stablyai/orca/orca`, never the bare token `orca`.

**GitHub.** HTTPS plus `gh auth login`. SSH is optional after the 1Password agent is on.

**Memory.** See `BRAIN.md`. Personal context never enters this public repo.

**Bypass.** Orca launches harnesses with permission-bypass.
`/etc/grok/requirements.toml` sets `disable_bypass_permissions_mode = false`. Do not flip it.

**`~/.claude/CLAUDE.md`** is a copy of `home/AGENTS.md`. The desktop app skips a symlink.
`~/.claude/settings.json` is a live symlink. Commit the keepers, check out the rest.

## License

MIT No Attribution. See `LICENSE`.
