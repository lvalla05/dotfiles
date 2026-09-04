# Vault

Obsidian is the memory surface. This repo is the machine. They are not the same folder.

After a wipe, restore the real vault from Obsidian Sync or a private remote.
If you are starting empty, copy this folder to `~/Documents/Vault` and open it in Obsidian.
Fill `CANON.md`. Do not commit notes, transcripts, or life context to the public machine repo.

## Layout

Karpathy's 2026 pattern: dump sources, let an LLM compile a wiki, use Obsidian as the viewer.
Tina Huang's pattern: daily log plus a to-do that both live as markdown the agent can read.
Lauren Tan's pattern: prove work on the real artifact, keep a map of how to drive it.

| Path | Job |
|---|---|
| `CANON.md` | Standing facts. Short. Loaded first. No secrets. |
| `Daily/` | One note per day. Capture. Cross off. |
| `raw/` | Immutable sources. Papers, clips, transcripts, screenshots. Never edit in place. |
| `wiki/` | Compiled pages. The LLM writes these. You rarely touch them. |
| `Inbox/` | Unsorted. Empty it. |
| `Sessions/` | One note per agent run: harness, prompt, outcome. |
| `Prompts/` | Reusable prompt text. Not a chat log. |
| `Decisions/` | Dated choices and why. |
| `Courses/` | One folder per class. |
| `Work/` | Current job, not the public repo. |
| `Career/` | Applications, target roles, narrative. |
| `Research/` | Topics the wiki has not absorbed yet. |
| `Projects/` | Status and links. Code stays in git. |

## Rules for agents

1. Read `CANON.md` first.
2. Ingest into `raw/`. Compile into `wiki/`. Do not treat chat as memory.
3. After a non-trivial run, write `Sessions/YYYY-MM-DD-short-name.md` with the verbatim prompt and the harness.
4. Decisions that must survive a wipe go in `Decisions/`.
5. Secrets stay in 1Password. Stop if a note would need a token.
6. The same vault is valid from Orca, Claude Code, Codex, Grok Build, Hermes, or Pi. Do not write per-harness copies.

## After a Mac reset

1. Sign into Obsidian. Sync or clone the private vault.
2. Point the orchestrator at that vault path plus https://github.com/lvalla05/dotfiles.
3. The orchestrator does not reconstruct your life from GitHub.
