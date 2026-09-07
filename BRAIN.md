# Brain boundary

Four stores, four jobs:

- This public `dotfiles` repo declares the Mac. Nothing personal lives here.
- The private `lvalla05/brain` repo is personal context, opened as an Obsidian vault at
  `~/orca/brain`. Sources, linked knowledge pages, decisions, research ledgers.
- 1Password holds credentials, recovery material and identity documents. Automic Vault is an
  optional gate agents go through to use a secret without seeing it.
- Todoist owns tasks and Google Calendar owns time. Brain links to them; it does not copy them.

Obsidian Sync is the intended Mac-to-phone transport; verify a round-trip edit before relying
on it. Git on the Mac is history and backup.
One writer at a time: an agent that wants to change the vault does it in the Mac checkout and
commits; other agents hand drafts to that one.

Every harness reads the same short `home/AGENTS.md`. Automatic per-tool memory stays off so
nothing personal accumulates in a second store; useful outcomes go to brain instead.

Never put secret values, 1Password exports, recovery codes, account numbers or private keys in
either repository.
