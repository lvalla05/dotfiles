# Brain boundary

The system has separate stores with separate jobs:

- This public `dotfiles` repo declares the Mac.
- The private `lvalla05/brain` repo is personal context and is opened directly in Obsidian.
- 1Password is the source of truth for credentials, recovery material, identity documents, and financial account details.
- Automic Vault is an optional local delivery and policy layer. Its state is reconstructible after a wipe; it is not a backup or a second password manager.

`brain` starts by preserving dated sources. Do not add a router, memory database, role forest, or automatic compiler until a real repeated workflow proves it is needed. One Orca session is the orchestrator and one process writes the vault at a time.

Obsidian Sync, configured after reset, moves the working vault between Apple devices. GitHub is private Mac-side history. Do not run a competing Git writer on the phone. Disable separate provider/CLI memory stores using the checklist in `SETUP.md`; ordinary chat retention is a different control.

After a wipe, follow `SETUP.md` from Safari through authentication and verification. Open `~/orca/projects/brain` itself in Obsidian. Add `dotfiles` and `brain` to Orca as separate projects so personal context is loaded only for work that needs it.

Never put secret values, 1Password exports, recovery codes, account numbers, private keys, or identity-document contents in either GitHub repository.
