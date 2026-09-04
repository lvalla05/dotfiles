# First hour on a wiped Mac

This repo is the machine. Secrets live in 1Password. Memory lives in Obsidian.
GitHub is HTTPS plus `gh`. Do not migrate from Time Machine.

## Before you click erase

This repo is at https://github.com/lvalla05/dotfiles. After erase, clone that.
Confirm Obsidian Sync (or a private git remote on the vault) actually has the vault.
This public repo does not.

## Setup Assistant

1. Not Now on migration. Local short name **`likhithvalla`**.
2. Apple Account from the phone. iCloud Keychain on. Touch ID on.
3. Install 1Password from the website. Sign in.
   Settings > Developer > Use the SSH agent. Integrate with 1Password CLI, Touch ID.
   The socket this repo declares is
   `~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock`
   (no `group.` segment).
4. Chrome. Sign in.

## Bootstrap

```sh
git clone https://github.com/lvalla05/dotfiles.git ~/orca/projects/dotfiles
cd ~/orca/projects/dotfiles
./bootstrap.sh
```

If sudo cannot find `nix`, open a new terminal and re-run. If Nix never appears, System Settings >
General > Login Items > Allow in the Background, enable the two `sh` entries.

Open a **new** terminal. `rebuild` is an alias. Own Things 3 and 1Password for Safari in the
App Store before the next switch (`mas` cannot buy).

## After the switch, in this order

1. `gh auth login` with HTTPS, not SSH. `gh auth setup-git`. Then
   `gh api user --jq .login` must print `lvalla05`. Push and pull do not wait on SSH.
2. Optional: `ssh -T git@github.com` after the 1Password agent is on. If it fails, keep using HTTPS.
3. Launch Orca. Leave Agent Permissions on the vendor default (permission-bypass).
4. Sign into whichever harnesses you open. None of them is the permanent primary.
5. Open Obsidian. Sign into Sync (or clone the private vault). If you are starting empty,
   copy `vault/` from this repo to `~/Documents/Vault` and open that. Fill `CANON.md`.
   Point the orchestrator at the vault plus this git repo. Never commit vault notes here.
6. Accessibility and mic prompts for Wispr Flow and Raycast.
7. Continue with `PHONE.md`.
