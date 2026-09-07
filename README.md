# dotfiles

Nix-darwin and home-manager restore this Mac from one repo. Homebrew installs the apps and
removes anything not declared here (zap). Agent tools are pinned in one lock file. Personal
context lives in a separate private `brain` repo, never here.

## What you get

- macOS defaults, Touch ID sudo, an empty hidden Dock, Raycast and Rectangle.
- Ghostty with herdr, Neovim, zsh with starship, ripgrep, fd, fzf, jq, lazygit.
- Claude Code, Codex, Grok Build and the desktop apps (Claude, ChatGPT, Grok Bot, Cursor).
- Pi with pinned defaults, pstack checks, optional Firstmate tooling and selected agent tools (`agent-tools`).
- 1Password with its SSH agent, official `gh` over HTTPS, Automic Vault as an optional secret gate.
- One 17-line `home/AGENTS.md` that every harness reads.

## Use it

```sh
git clone https://github.com/lvalla05/dotfiles.git ~/orca/dotfiles
cd ~/orca/dotfiles
./bootstrap.sh      # fresh Mac: Determinate Nix, ~/.dotfiles link, first switch
./rebuild.sh        # every later change (alias: rebuild)
./doctor.sh         # when a rebuild fails: names the failing precondition
agent-tools pi      # install the pinned Pi CLI
agent-tools --list  # other pinned tools; install only what you use
```

To install only the declared Pi version after the first switch, without running the rest of
`agent-tools`:

```sh
bash home/bin/agent-tools pi
```

Files under `home/` are live symlinks into this checkout: editing the repo edits the machine.
`~/.claude/CLAUDE.md` is the one copy (the desktop app ignores symlinks); it refreshes on rebuild.

Check without applying: `bash tests/links.test.sh`, `bash tests/bootstrap.test.sh`,
`bash tests/activation.test.sh`, `bash tests/agent-tools.test.sh`, `bash tests/firstmate.test.sh`, `bash tests/firstmate-source.test.sh`,
`bash tests/pstack-setup.test.sh`, `nix build .#darwinConfigurations.mac.system --no-link`.

## Read next

- [SETUP.md](SETUP.md): restore a wiped Mac, step by step, and prove it.
- [WORKFLOW.md](WORKFLOW.md): portable harnesses, Orca review and supervised work.
- [DESK.md](DESK.md): Mac controls, phone layout, daily surfaces.
- [BRAIN.md](BRAIN.md): what lives where (dotfiles, brain, 1Password, Todoist, Calendar).
- [AGENTS.md](AGENTS.md): decisions in this repo that agents must not revert.

## Make it yours

`user` in `flake.nix` (bootstrap offers to rewrite it), the host label `mac` in `flake.nix`,
`rebuild.sh` and `bootstrap.sh`, and the git identity in `home.nix`. Zap means the cask list
is the machine: add before you install, remove before you uninstall.

MIT No Attribution. See `LICENSE`.
