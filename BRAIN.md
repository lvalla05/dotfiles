# Brain boundary

The system has separate stores with separate jobs:

- This public `dotfiles` repo declares the Mac.
- The private `lvalla05/brain` repo is personal context and is opened directly in Obsidian.
- 1Password is the source of truth for credentials, recovery material, identity documents, and financial account details.
- Automic Vault is an optional local delivery and policy layer. Its state is reconstructible after a wipe; it is not a backup or a second password manager.

`brain` uses a source-backed Markdown wiki with linked domain pages, scoped local retrieval and explicit correction rules. Read its `MEMORY.md` and `SCHEMA.md`. Add infrastructure only when a demonstrated workflow needs it. Grok Bot is the daily/mobile executive; Codex/Claude GUI or optional Orca terminal workspaces handle technical work. One process writes the vault at a time.

Obsidian Sync, configured after reset, moves the working vault between Apple devices. GitHub is private Mac-side history. Do not run a competing Git writer on the phone. New personal decisions belong in brain. Read the latest private reset handoff for any separately authorized cloud cleanup; saved context, account access and disposable conversations are different objects.

After a wipe, follow `SETUP.md` through package installation, authentication and verification. Open `~/orca/projects/brain` itself in Obsidian. In the selected technical app, keep `dotfiles` and `brain` as separate projects so personal context is loaded only for work that needs it.

If an always-on host is adopted later, transfer canonical agent-writing and Git checkpointing to
one stable brain checkout there. The official [Obsidian Headless Sync](https://obsidian.md/help/sync/headless)
client can connect that checkout to the same Sync vault without a desktop app; it needs an active
Sync subscription and is currently beta. Test a disposable vault first. Never connect worker
branches separately, run competing desktop/headless sync on one device, or put its authentication
state in Git. Mac and iPhone then receive vault content through Sync; a Git push alone cannot
deliver it. Open Obsidian on the phone to receive updates, since continuous background iOS sync
is not guaranteed. This host migration is not performed by the Mac bootstrap.

Never put secret values, 1Password exports, recovery codes, account numbers, private keys, or identity-document contents in either GitHub repository.

After restoration, open Claude and the private Brain’s `POST-RESET-AUDIT.md` for the requested fresh research and practical qualification. Its source manifest covers all supplied transcripts; the public repo carries no personal research content.
