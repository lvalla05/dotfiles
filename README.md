# dotfiles

Nix-darwin plus home-manager restore the declared Mac setup. Nix inputs are locked;
Homebrew apps intentionally update on rebuild.

Grok Bot is the daily and mobile executive. Technical work can use Codex or Claude GUI,
or Orca's optional workspace for terminal harnesses. Harnesses rotate. Aside is the Mac browser;
Comet is the phone browser. Memory lives in the private `brain` repo, opened in Obsidian.

The [working loop](WORKFLOW.md) is one Grok executive chief, bounded engineering workers,
optional local HTML review, and one scheduler per automation. It does not require another agent
platform or a global npm toolchain.

## What you get

- macOS defaults, Touch ID sudo, zap Homebrew
- Aside as the Mac browser, Chrome for required integrations, Ghostty and 1Password
- Codex/Claude GUI and optional Orca (parallel terminal sessions, worktrees, diffs)
- Declared harness CLIs, none primary
- Official `gh` over HTTPS
- One `home/AGENTS.md` every harness reads
- Obsidian as the memory surface, backed by a separate private `brain` repo

## Fresh Mac

Use built-in Safari to read the [complete reset and restore guide](SETUP.md). Bootstrap installs
Mac apps through the Nix/Homebrew declaration; App Store is used only for the declared apps
that require it. Then open the installed assistant, complete sign-ins and Computer Use permissions,
and verify the restored workflows. Obsidian Sync is configured after reset.

Before these commands, finish the guide's Command Line Tools and App Store prerequisites:

```sh
git clone https://github.com/lvalla05/dotfiles.git ~/orca/projects/dotfiles
cd ~/orca/projects/dotfiles
./bootstrap.sh
```

Continue with `SETUP.md` after the switch, then `PHONE.md`. The bootstrap cannot restore
account sign-ins, approve macOS permissions, or recover secrets for you.

Check without applying:

```sh
nix flake check --no-build
nix build .#darwinConfigurations.mac.system --dry-run
bash tests/links.test.sh
bash tests/bootstrap.test.sh
bash tests/activation.test.sh
```

For changes to the Nix configuration, build the complete system without activating it:

```sh
nix build .#darwinConfigurations.mac.system --no-link
```

Evaluation and dry-run checks do not prove that a build succeeds. A build does not apply macOS
settings, install Homebrew apps, or verify authenticated Mac/iPhone workflows.

See [the desk](DESKTOP.md) for the actual launcher, clipboard, tiling and daily app flow.

## Daily use

Make project changes in an isolated worktree using the selected technical tool. After verification and publishing, advance the durable
primary checkout to the accepted revision. Activate only from that primary checkout, never a
disposable worker worktree:

```sh
cd ~/orca/projects/dotfiles
./rebuild.sh
```

Files under `home/` that are live-symlinked take effect when the primary checkout changes; worker
edits remain isolated. The scripts refuse to silently move an existing `~/.dotfiles` pointer.

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
