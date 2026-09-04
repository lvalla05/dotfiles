# Vault

This is the memory system. It is not the machine.

The machine is https://github.com/lvalla05/dotfiles. This folder is the layout for
the Obsidian vault. After a wipe, restore the real vault from Obsidian Sync or a
private remote. If you are starting empty, copy this folder to `~/Documents/Vault`
and open it in Obsidian.

Do not commit vault notes, session transcripts, prompts, or life context to the
dotfiles repo. That repo is public.

## What lives here

| Path | Job |
|---|---|
| `CANON.md` | Standing facts an agent may load. Short. No secrets. |
| `Inbox/` | Unsorted captures. Empty this. Do not let it become the system. |
| `Sessions/` | One note per agent run: date, harness, prompt, outcome, files touched. |
| `Prompts/` | Reusable prompt text you want again. Not a chat log. |
| `Decisions/` | Dated choices and why. One file per decision. |
| `Projects/` | One folder per live project. Link out. Do not duplicate the git repo. |

## Rules for agents

1. Read `CANON.md` before acting on life context.
2. After a non-trivial run, write `Sessions/YYYY-MM-DD-short-name.md`. Include the
   exact prompt and the harness (Orca pane, Claude Code, Codex, Grok Build, other).
3. If a decision should survive the next wipe, put it in `Decisions/`, not in a
   chat and not in the public dotfiles.
4. Secrets stay in 1Password. If a note would need a token, stop.
5. Health, family, grades, and anything that must not be in a public git remote
   stay in this vault. They never go in `lvalla05/dotfiles`.

## After a Mac reset

1. Sign into Obsidian. Sync or clone the private vault.
2. Point the orchestrator at that vault path plus https://github.com/lvalla05/dotfiles.
3. The orchestrator reads `CANON.md` and `SETUP.md` in the machine repo. It does
   not reconstruct memory from GitHub.
