# Project notes for agents

Deliberate decisions in this repo - do not silently revert them:

- `homebrew.onActivation.cleanup = "zap"` in `configuration.nix` is intentional and stays. It forces every Homebrew package to be declared here instead of installed ad hoc, which is what keeps the machine reproducible. Do not soften it to `uninstall`, `check`, or `none`.
- Because of zap, the cask list is the machine. Never remove an entry from `brews`, `casks`, or `masApps` unless the human names that specific app in the current conversation. A previous rebuild dropped the Claude desktop app this way and it was missed. The `claude` cask is declared on purpose; do not remove it.
- `claude-code@latest` is the cask, not `claude-code`: the two conflict, keep one. `@latest` tracks the channel Fable 5.1 and the sandbox need. Its cask `zap` stanza deletes `~/.claude.json` (sign-in, MCP servers, trust decisions), so dropping the line under zap logs the human out. Never drop it.
- The Orca cask is `stablyai/orca/orca`, fully qualified. The bare token `orca` is a disabled Plotly cask. Orca is the ADE. Harnesses rotate (Claude Code, Codex, Grok Build, Hermes, Pi). Do not treat any CLI as the permanent primary. Almanac is retired; do not resurrect it.
- Orca launches every harness with permission-bypass. That is intentional. Do not pin Grok or Claude bypass off.
- Vendor taps carry `trusted = true` (Homebrew 6 `HOMEBREW_REQUIRE_TAP_TRUST`); without it their casks are skipped silently and their brews abort the switch.
- `~/.claude/settings.json` is a live symlink into this repo (Kun Chen's pattern). Claude Code rewrites that file at runtime, so the working tree gets dirty when it does; commit the keepers, `git checkout` the rest. Never replace the symlink with a copy.
- `~/.claude/CLAUDE.md` is the one deliberate copy, installed by `home.activation.claudeInstructions` from `home/AGENTS.md`. The Claude desktop app skips a symlinked `~/.claude/CLAUDE.md` and skips `@` imports that resolve outside the working directory, so a link or an `@AGENTS.md` pointer loads nothing there. Edit `home/AGENTS.md`, then `./rebuild.sh`. Do not convert it to a symlink.
- `home/AGENTS.md` is the one instruction file for Claude Code, Codex, Grok Build, and `~/.agents/AGENTS.md`. Keep it under 25 lines; every addition names the removal that pays for it.
- The 1Password SSH agent socket is `~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock` (no `group.` segment). The old repo had the wrong path and SSH to GitHub silently failed. Do not "correct" it back.
- Git identity is declared in `home.nix`. Cloners must change it before their first rebuild.
- Nothing personal lives in this repo: no life context, no secrets, no family, no health, no grades. Those live in the private vault. The repo is public.

## Maintaining this file

Keep this file for knowledge useful to almost every future agent session in this repo.
Do not repeat what the code already shows; point to the authoritative file or command instead.
Prefer rewriting or pruning existing entries over appending new ones.
