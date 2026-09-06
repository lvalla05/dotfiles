# Project notes for agents

Deliberate decisions in this repo - do not silently revert them:

- `homebrew.onActivation.cleanup = "zap"` in `configuration.nix` is intentional and stays. It forces every Homebrew package to be declared here instead of installed ad hoc, which is what keeps the machine reproducible. Do not soften it to `uninstall`, `check`, or `none`.
- Because of zap, the cask list is the machine. Never remove an entry from `brews`, `casks`, or `masApps` unless the human names that specific app in the current conversation. The `claude` cask is declared on purpose; do not remove it.
- `claude-code@latest` is the cask, not `claude-code`: the two conflict, keep one. `@latest` tracks the current release channel. Its cask `zap` stanza deletes `~/.claude.json` (sign-in, MCP servers, trust decisions), so dropping the line under zap logs the human out. Never drop it.
- The Orca cask is `stablyai/orca/orca`, fully qualified. The bare token `orca` is a disabled Plotly cask. Orca is an optional workspace for terminal harnesses alongside Codex and Claude GUI workflows. Harnesses rotate; no CLI is the permanent primary.
- Orca launches every harness with permission-bypass. `home/.grok/requirements.toml` sets `disable_bypass_permissions_mode = false`. Do not flip it to true.
- Do not write agent-attribution comments in this repo (which model, which session, who generated a line). Session notes, prompts, and life context live in the private `brain` repo, never here.
- Vendor taps carry `trusted = true` (Homebrew 6 `HOMEBREW_REQUIRE_TAP_TRUST`); without it their casks are skipped silently and their brews abort the switch.
- `~/.claude/settings.json` is a live symlink into this repo (Kun Chen's pattern). Claude Code rewrites that file at runtime, so the working tree gets dirty when it does; commit the keepers, `git checkout` the rest. Never replace the symlink with a copy.
- `~/.claude/CLAUDE.md` is the one deliberate copy, installed by `home.activation.claudeInstructions` from `home/AGENTS.md`. The Claude desktop app skips a symlinked `~/.claude/CLAUDE.md` and skips `@` imports that resolve outside the working directory, so a link or an `@AGENTS.md` pointer loads nothing there. Edit `home/AGENTS.md`, then `./rebuild.sh`. Do not convert it to a symlink.
- `home/AGENTS.md` is the one instruction file for Claude Code, Codex, Grok Build, and `~/.agents/AGENTS.md`. Keep it under 25 lines; every addition names the removal that pays for it.
- The 1Password SSH agent socket is `~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock` (no `group.` segment). GitHub git uses HTTPS plus `gh auth git-credential` so a missing agent does not block push.
- Brew `gh` is the official formula. Do not install `automic-vault/isotopes/gh-cli`; it prompts on every GitHub call.
- Git identity is declared in `home.nix`. Cloners must change it before their first rebuild.
- Nothing personal lives in this repo: no life context, no secrets, no family, no health, no grades. Those live in the private `brain` repo. This repo is public.

## Maintaining this file

Keep this file for knowledge useful to almost every future agent session in this repo.
Do not repeat what the code already shows; point to the authoritative file or command instead.
Prefer rewriting or pruning existing entries over appending new ones.
