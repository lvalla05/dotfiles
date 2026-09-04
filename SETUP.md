# First hour on a wiped Mac

This repo is the machine. Secrets live in 1Password. Memory lives in Obsidian.
Re-sign Automic Vault after the switch. Do not migrate from Time Machine.

Erase All Content and Settings keeps the OS already installed. Turn Beta Updates off
in Software Update first if you want public 27.0 when it ships.

## Before you click erase

This repo is at https://github.com/lvalla05/dotfiles. After erase, clone that.
Confirm Obsidian Sync (or a private git remote on the vault) actually has the vault.
This public repo does not.

## Setup Assistant

1. Not Now on migration. Local short name **`likhithvalla`** (hardcoded in `flake.nix`).
2. Apple Account from the phone. iCloud Keychain on. Touch ID on.
3. Install 1Password from the website. Sign in. Settings > Developer > Use the SSH agent.
   Integrate with 1Password CLI, Touch ID. The socket this repo declares is
   `~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock` (no `group.` segment).
4. Chrome. Sign in. It is the only browser Claude in Chrome supports.

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

1. `ssh -T git@github.com` must greet you. If it does not, the 1Password agent is off.
2. Launch Orca. Leave Agent Permissions on the vendor default so every harness starts
   with permission-bypass.
3. Sign into whichever harnesses you open. None of them is the permanent primary.
4. Open Obsidian. Sign into Sync (or clone the private vault). The layout is in `vault/`
   in this repo if you are starting empty. Point the orchestrator at that vault for
   memory, session notes, and prompts. Never commit those notes here.
5. `claude` once inside a project directory so workspace trust saves if you want the
   phone link.
6. Accessibility and mic prompts for Wispr Flow and Raycast. Those cannot be declared.
7. Continue with `PHONE.md`.
