# dotfiles

This is the only machine repo.

Nix-darwin plus home-manager. One command. A wiped Mac comes back the same.
Memory, session notes, and prompts live in the Obsidian vault, not here.

The layout is Kun Chen's (https://youtu.be/5N-okeDdIuI). Orca is the ADE. The CLI in a pane is
whatever harness that job needs (Claude Code, Codex, Grok Build, Hermes, Pi). None of them is
permanent. pstack (https://x.com/poteto/article/2094457600259842065) is how a pane does rigorous
work, not a reason to freeze the harness.

## What you get

- macOS defaults, Touch ID sudo, zap Homebrew
- Ghostty, Chrome, 1Password, the declared GUI apps
- Orca as the ADE (parallel sessions, worktrees, diffs)
- The declared harness CLIs, none of them primary
- One `home/AGENTS.md` every harness reads
- Claude desktop for the phone Remote Control host. ChatGPT desktop for Codex Remote.

## Fresh Mac

Wipe it. Then:

```sh
git clone https://github.com/lvalla05/dotfiles.git ~/orca/projects/dotfiles
cd ~/orca/projects/dotfiles
./bootstrap.sh
```

Read `SETUP.md` for the clicks no file can make (1Password SSH agent, Orca, Obsidian).
Read `PHONE.md` for the phone.

Check without applying:

```sh
nix flake check --no-build
nix build .#darwinConfigurations.mac.system --dry-run
bash tests/links.test.sh
```

## Daily use

Edit in place. For package lists or macOS defaults:

```sh
./rebuild.sh
```

Symlinked files under `home/` do not need a rebuild.

## Make it yours

- **Username.** `user = "likhithvalla"` in `flake.nix`, or let `bootstrap.sh` rewrite it.
- **Host label** `"mac"` in `flake.nix`, `rebuild.sh`, and `bootstrap.sh`. All three must match.
- **Git identity** in `home.nix`. Change it before your first rebuild if this is not your machine.

**Zap.** Anything not in `brews` / `casks` / `masApps` is removed on switch. The `claude` desktop
app stays. `claude-code@latest` stays (`claude-code` conflicts). Orca is `stablyai/orca/orca`,
never the bare token `orca`.

**Bypass.** Orca launches harnesses with permission-bypass.
`/etc/grok/requirements.toml` sets `disable_bypass_permissions_mode = false`. Do not flip it.

**CLAUDE.md** is a copy of `home/AGENTS.md`, not a symlink. The desktop app skips a symlink.
`~/.claude/settings.json` is a live symlink. Commit the keepers, check out the rest.

## What to watch

1. Orca (the ADE)
2. Ghostty
3. Chrome (the only browser Claude in Chrome supports)
4. The harness CLIs declared in `configuration.nix` (rotate freely)
5. 1Password plus Automic Vault

A sixth surface needs a named job.

## License

MIT No Attribution. See `LICENSE`.
