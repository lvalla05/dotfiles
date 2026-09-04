# First hour on a wiped Mac

This repo is the machine. Secrets live in 1Password. Personal context lives in the private
`brain` repo, opened in Obsidian.
GitHub is HTTPS plus `gh`. Do not migrate from Time Machine.

## Before you click erase

Do not erase until all five checks are true:

1. `dotfiles` is committed and pushed to https://github.com/lvalla05/dotfiles.
2. `lvalla05/brain` exists, is **private**, and its working tree is committed and pushed.
3. Obsidian Sync reports the brain vault fully synced on the Mac and iPhone.
4. The 1Password Emergency Kit and recovery path work without this Mac or either GitHub repo.
5. Local-only coursework, media, and project outputs outside Git repos are backed up elsewhere or
   deliberately abandoned; check `~/Documents`, `~/Downloads`, and `~/Developer` explicitly.

This public repo contains neither personal context nor a credential backup.

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

The bootstrap accepts only Apple silicon, verifies a pinned Determinate installer, and runs the
first `darwin-rebuild` from `flake.lock`. If Nix never appears, open System Settings > General >
Login Items and enable the two Determinate `sh` background items, then re-run the script.

Open a **new** terminal. `rebuild` is an alias. Own Things 3 and 1Password for Safari in the
App Store before the next switch (`mas` cannot buy).

## After the switch, in this order

1. Prove Homebrew installed the official GitHub CLI, not Automic's approval-wrapping isotope:

   ```sh
   test "$(command -v gh)" = /opt/homebrew/bin/gh
   brew list --formula --full-name | grep -qx gh
   ! brew list --formula --full-name | grep -qx 'automic-vault/isotopes/gh-cli'
   ```

2. Authenticate over HTTPS. The Git credential helper is already declared in `home.nix`, so do
   not run a second setup command:

   ```sh
   gh auth login --web --git-protocol https
   gh auth status
   test "$(gh api user --jq .login)" = lvalla05
   ```

3. Verify the personal repo is private before cloning it:

   ```sh
   test "$(gh repo view lvalla05/brain --json visibility --jq .visibility)" = PRIVATE
   git clone https://github.com/lvalla05/brain.git ~/orca/projects/brain
   ```

   Open `~/orca/projects/brain` as the Obsidian vault, connect that vault to Obsidian Sync, and
   keep Git pushes on the Mac. Git is history; Obsidian Sync is device sync.

4. Launch Orca. Add `~/orca/projects/dotfiles` and `~/orca/projects/brain` as separate projects.
   Leave Agent Permissions on the vendor default (permission-bypass). Sign into whichever
   harnesses you use; none is permanent.

5. Restore the Spiral MCP for Codex, then complete its explicit OAuth login:

   ```sh
   codex mcp add spiral --url https://api.writewithspiral.com/mcp/
   codex mcp login spiral
   codex mcp list
   ```

6. Launch Automic Vault and use its app to install the matching `av` CLI. Start empty after the
   wipe. Do not recreate `GH_TOKEN*`, enable the GitHub hardener, or enable the Homebrew hardener.
   Those hardeners replace official tools and break this declaration. Verify the installed build:

   ```sh
   av --version
   av doctor --json
   av hardeners --json
   ```

   Keep direct secret access, detached processes, and access while locked off for general agents.
   Pre-authorize only a named, recurring local workflow; use a short temporary grant or an exact
   blessed script for a remote write. Silence notifications for operations already allowed by
   policy while keeping authorization history.

7. Sign in to Microsoft Outlook and Teams with the Georgia Tech account. Keep Georgia Tech data in
   Institute-approved apps, not personal mail or calendar clients.
8. Use ISyE VLab in the browser for course software. If a class or restricted resource requires
   Georgia Tech VPN, install GlobalProtect from the authenticated `https://vpn.gatech.edu/` portal;
   do not substitute Tailscale or an unauthenticated Homebrew cask.
9. Optional: `ssh -T git@github.com` after the 1Password agent is on. GitHub itself stays on HTTPS.
10. Grant Accessibility and microphone access to Wispr Flow and Raycast.
11. Continue with `PHONE.md`.
