# Restore a wiped Mac

This repo is the machine. Secrets live in 1Password. Personal context lives in the private
`brain` repo. Keep this page open on the phone:
https://github.com/lvalla05/dotfiles/blob/main/SETUP.md

## Before you erase

1. `dotfiles` and `brain` are committed and pushed; a fresh clone of each has your latest work.
   Check every worktree: `git worktree list` and `git status` in each.
2. 1Password works on the phone (or you hold the Emergency Kit). Keep the phone intact until
   the new Mac is signed in everywhere.
3. Anything outside Git that you want (`~/Documents`, `~/Downloads`, `~/Developer`, project
   outputs) is backed up somewhere else.

## Fresh Mac

1. Setup Assistant: set up as new, short name `likhithvalla`, Apple Account, iCloud Keychain,
   Touch ID.
2. App Store: sign in, so the declared `masApps` can install.
3. Terminal:

```sh
xcode-select --install          # finish Apple's dialog, then:
git clone https://github.com/lvalla05/dotfiles.git ~/orca/projects/dotfiles
cd ~/orca/projects/dotfiles
./bootstrap.sh                  # installs Determinate Nix, links ~/.dotfiles, first switch
```

Open a new terminal afterwards. From then on, edit files and run `rebuild` (an alias for
`./rebuild.sh`). If anything fails, run `./doctor.sh` first; it names the failing precondition.

## After the first switch, in order

1. GitHub over HTTPS: `gh auth login --web --git-protocol https`, then `gh auth status`.
2. 1Password: sign in, enable Settings > Developer > SSH agent, CLI integration and Touch ID.
   The agent socket path is already declared in `home.nix`.
3. Brain: `git clone https://github.com/lvalla05/brain.git ~/orca/projects/brain`, open it as
   the Obsidian vault, connect Obsidian Sync on Mac and phone.
4. Harnesses: run `agent-tools` once to install pi and the pinned agent CLIs, then sign into
   Claude Code (`claude`), Codex (`codex login`), Grok Build (`grok`) and pi (`/login`) with the
   existing subscriptions. Do not create API keys just to sign in. Orca setup is in `WORKFLOW.md`.
5. Desk: follow `DESK.md` for Raycast, Rectangle, Wispr Flow permissions and the phone.
6. Grok Bot: open it, sign in, and rebuild the daily chief from the handoff note in brain.
7. School: Outlook and Teams with the Georgia Tech account; Duo on the phone.

## Prove it

```sh
./doctor.sh
bash tests/links.test.sh && bash tests/bootstrap.test.sh && bash tests/activation.test.sh
gh auth status && git -C ~/orca/projects/brain ls-remote origin HEAD
claude --version && codex --version && grok --version
```

Then do one real thing on each surface: a Claude Code task in a worktree, a Grok Bot request
from the phone with the Mac closed, a Todoist task showing next to a calendar event, a note
edited on the phone appearing on the Mac. Record what failed in brain, not here.

## Notes that save you an hour

- Zap is on: anything not declared in `configuration.nix` is uninstalled on every rebuild.
- `claude-code@latest` is the Claude Code cask. Its zap stanza deletes `~/.claude.json`
  (sign-in, MCP servers). Never remove the line.
- Nix only sees git-tracked files. `git add` new files before rebuilding.
- home-manager moves an existing real file aside as `*.backup`; if that backup already
  exists the switch fails. `./doctor.sh` lists them.
- `~/.claude/settings.json` is a live symlink into this repo. Commit the changes you want
  to keep and `git checkout` the rest.
