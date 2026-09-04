# Restore a wiped Mac

This repo is the machine. Secrets live in 1Password. Personal context lives in the private
`brain` repo, opened in Obsidian.
GitHub is HTTPS plus official `gh`. Set up as a new Mac; restore selected data, not the old
machine configuration. Keep this page open on the phone:
https://github.com/lvalla05/dotfiles/blob/main/SETUP.md.

## Before you click erase

Do not erase until all five checks are true:

1. `dotfiles` is committed and pushed to https://github.com/lvalla05/dotfiles.
2. `lvalla05/brain` exists, is **private**, and its working tree is committed and pushed.
3. A fresh download/clone of both repositories contains the latest work, and any phone-only notes
   have a separate backup. Obsidian Sync will be configured **after** reset; it is not the backup gate.
4. The 1Password Emergency Kit and recovery path work without this Mac or either GitHub repo.
5. Local-only coursework, media, and project outputs outside Git repos are backed up elsewhere or
   deliberately abandoned; check `~/Documents`, `~/Downloads`, and `~/Developer` explicitly.

This public repo contains neither personal context nor a credential backup. Test Apple Account,
1Password, GitHub, the AI subscription account, and Georgia Tech/Duo recovery without using this
Mac. Keep the recovery material off the Mac and out of Git. A clean Git status is not proof of a
remote backup. Do not erase while either repository has unpublished work.

## Setup Assistant

1. Connect power and Wi-Fi. Choose **set up as a new Mac** instead of migrating the old system.
   Local short name **`likhithvalla`**. Complete Setup Assistant and available macOS updates.
2. Apple Account from the phone. iCloud Keychain on. Touch ID on.

## Safari first: bring up the setup assistant

1. In Safari, open the [official ChatGPT download page](https://chatgpt.com/download/).
   Install the Mac app in Applications, open it, and sign into the existing subscription account.
   Do not purchase another subscription. A separate Codex CLI install is not needed yet.
2. In the app's surface dropdown, choose **Codex**, then **New chat**. Select **GPT-6 Astra**
   beneath the composer if it is available to the account. Otherwise use the strongest available
   coding model; a rollout or model name must not block restoring the machine.
3. Open **Plugins > Computer Use**, choose **Install plugin** or **Enable**, enable its server
   and skill, and choose **Try now**. In **System Settings > Privacy & Security**, grant the
   relevant **Codex Computer Use** entry **Accessibility** and **Screen & System Audio Recording**
   access. Approve app access as needed in ChatGPT's Computer Use settings. Test opening a harmless
   page in Safari before relying on it. Do not grant unrelated Full Disk Access or microphone access.
4. Paste the following handoff into that Codex chat:

   > Restore this Mac from https://github.com/lvalla05/dotfiles. Read AGENTS.md, SETUP.md,
   > BRAIN.md, PHONE.md, and the bootstrap scripts fully before acting. Follow SETUP.md in order.
   > Orca is my ADE; harnesses rotate. Use official gh over HTTPS, 1Password for credentials,
   > and the separate private lvalla05/brain repo as the only durable personal memory.
   > Obsidian Sync comes after the Mac restore. Use your structured shell for terminal work
   > and Computer Use for supported apps. Ask me to perform administrator authentication,
   > sign-in, and macOS security prompts directly. Never ask for secret values in chat.
   > Keep a checkpoint list in this conversation; report each verification as pass, fail,
   > or not tested. Resume failed stages without reinstalling completed stages. Do not
   > remove declared apps, weaken zap, replace official gh, or build a second memory system.
   > Finish the verification section, including a harmless Orca task and private brain readback.
   > Installation is not evidence that an integration or automation works. Do not erase data,
   > buy subscriptions, or create unrelated automations.

OpenAI Computer Use cannot operate terminal apps or ChatGPT itself, enter administrator
credentials, or approve macOS security/privacy prompts. Those steps are human-operated; Codex's
structured shell can do ordinary command-line work when available. If Computer Use is unavailable,
the commands below still work manually. Never work around a denied permission with a different tool.

## Before bootstrap

1. Open the Mac App Store and sign into the account that owns **Things 3 for Mac**.
   Confirm Things 3 and **1Password for Safari** are in that account's library before
   the first rebuild. The declared `masApps` run during bootstrap; `mas` cannot buy a paid app.
2. If sign-in requires it, install [1Password](https://1password.com/downloads/mac/) now and
   recover the existing account. Otherwise the rebuild installs it. Do not export the vault.

## Bootstrap

Install Apple's Command Line Tools before cloning. Run this once, finish the system installer,
then run the clone commands below. If the tools are already installed, continue.

```sh
xcode-select --install
```

Finish Apple's Install/license/Done dialog. Verify the Command Line Tools receipt before cloning:

```sh
pkgutil --pkg-info=com.apple.pkg.CLTools_Executables
```

Codex can clone with its structured shell. Run `./bootstrap.sh` as the ordinary user in Terminal,
not with `sudo ./bootstrap.sh`; enter the administrator password directly when the script requests it.

```sh
git clone https://github.com/lvalla05/dotfiles.git ~/orca/projects/dotfiles
cd ~/orca/projects/dotfiles
./bootstrap.sh
```

The bootstrap accepts only Apple silicon, verifies a pinned Determinate installer, and runs the
first `darwin-rebuild` from `flake.lock`. It installs the declared apps, including Orca and the
harness CLIs. Do not install a parallel Homebrew, Nix, or global npm toolchain yourself.
If a stage fails, keep its exact error. Check any blocked Determinate background items in System
Settings > General > Login Items, or App Store ownership/sign-in for a `mas` failure. Re-run the
bootstrap only after diagnosing the failed stage. Do not erase again or uninstall Nix as a generic fix.

Open a **new** terminal. `rebuild` is an alias.

## After the switch, in this order

1. Prove Homebrew installed the official GitHub CLI, not Automic's approval-wrapping isotope:

   ```sh
   test "$(command -v gh)" = /opt/homebrew/bin/gh &&
   brew list --formula --full-name | grep -qx gh &&
   ! brew list --formula --full-name | grep -qx 'automic-vault/isotopes/gh-cli'
   ```

   All three checks must succeed. Then `test -z "${GH_TOKEN-}${GITHUB_TOKEN-}"` must succeed;
   if it fails, remove the stale startup override without printing its value, and reopen the app/shell.

2. Authenticate over HTTPS. The Git credential helper is already declared in `home.nix`, so do
   not run a second setup command:

   ```sh
   gh auth login --web --git-protocol https &&
   gh auth status &&
   test "$(gh api user --jq .login)" = lvalla05
   ```

3. Open 1Password and sign into the existing vault. Enable Settings > Developer > **Use the SSH
   agent**, **Integrate with 1Password CLI**, and Touch ID. Never paste a token, Secret Key, recovery
   code, or private key into this chat. The configured socket is
   `~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock` (no `group.` segment).
   Restore existing SSH Key items; create a new key only for a named destination that needs one.
   GitHub uses HTTPS and needs no SSH key. A new SSH key also needs its public half authorized on
   the destination; merely turning on the agent does not establish remote access.

4. Verify the personal repo is private before cloning it:

   ```sh
   test "$(gh repo view lvalla05/brain --json visibility --jq .visibility)" = PRIVATE &&
   git clone https://github.com/lvalla05/brain.git ~/orca/projects/brain
   ```

   Open `~/orca/projects/brain` as the Obsidian vault, connect that vault to Obsidian Sync, and
   keep Git pushes on the Mac. Git is history; Obsidian Sync is device sync.
   On each device, enable **Sync all other types** so imported HTML and other source files travel
   with the notes. Sync settings are device-specific; `.git` and ordinary hidden files do not
   sync, while selected `.obsidian` configuration settings can.

5. Launch Orca. Add `~/orca/projects/dotfiles` and `~/orca/projects/brain` as separate projects.
   Leave Agent Permissions on the vendor default (permission-bypass). Sign into whichever
   harnesses you use; none is permanent.
   Fully restart Orca after `gh` authentication, then refresh its GitHub/Source Control view for
   both projects. Orca uses the host's `gh` credentials. Keep `GH_TOKEN` and `GITHUB_TOKEN` out of
   shell and GUI startup environments so stale values cannot override the credential store.
   Register Orca's CLI in its Settings and verify `orca status --json`. Check each chosen harness's
   signed-in account and loaded MCP servers. Grok Build can import Claude and Cursor MCP settings;
   review those imports for duplicates or unwanted access. Remote Orca hosts need their own
   provider and `gh` authentication; this Mac's login does not transfer.
   Follow `WORKFLOW.md` for the one-coordinator research and implementation loop. Enable Orca
   Orchestration in Experimental settings if needed; test a bounded read-only worker and its
   structured completion before depending on it. Keep recurring automations disabled until their
   inputs, output, duplicate-run behavior, and notifications have been tested.
   Inspect each project's setup hook. Dotfiles and brain are not npm projects: clear a generic
   `pnpm install` hook if Orca supplies or restores one. In Settings, select the repository and
   host, then Worktree Hooks → Setup Script; clear the command and leave the field to save it.
   Check Advanced / Script Source for a shared `orca.yaml` hook as well. A placeholder is not a
   configured command. Do not put `bootstrap.sh` or `rebuild.sh`
   in a worktree setup hook; creating a worker must not activate or zap the whole machine.

6. Restore the Spiral MCP for Codex, then complete its explicit OAuth login:

   ```sh
   codex mcp add spiral --url https://api.writewithspiral.com/mcp/
   codex mcp login spiral
   codex mcp list
   ```

   If `spiral` already exists, inspect `codex mcp get spiral` before changing it. Test a read-only
   Spiral operation; appearing in the list is not proof of authorization. Authenticate other MCPs
   only when a selected workflow needs them; do not import an old server list wholesale.

7. Apply the **Memory boundary** below before resuming personal work.

8. Launch Automic Vault and use its app to install the matching `av` CLI. Start empty after the
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

   First prove a harmless allowed operation completes without a repeated prompt, and that a
   protected operation still stops. Do not use a real transfer, email send, or deletion as the test.
   Bypass in a harness does not unlock 1Password, grant OAuth, or change Automic policy.

9. Sign in to Chrome and the selected desktop/harness accounts using their native login flows.
   Confirm the intended subscription is active before enabling any metered API billing.
10. Sign in to Microsoft Outlook and Teams with the Georgia Tech account. Keep Georgia Tech data in
   Institute-approved apps, not personal mail or calendar clients.
11. Use ISyE VLab in the browser for course software. If a class or restricted resource requires
   Georgia Tech VPN, install GlobalProtect from the authenticated `https://vpn.gatech.edu/` portal;
   do not substitute Tailscale or an unauthenticated Homebrew cask.
12. Grant Wispr Flow its microphone/Accessibility permissions. Grant Raycast or other apps only
    the permissions needed by enabled features. Finish `PHONE.md`, including Things Cloud and a
    real remote-session test if remote control is wanted.

## Memory boundary

`brain` is the only durable personal knowledge base. This does not mean cloud providers retain
no messages, tool output, attachments, or safety records. Turn off training separately where
available. Do not put credentials in brain or upload the whole vault to every provider.
Preserve wanted existing memories and instructions privately in brain before clearing or resetting
them. These account controls are not a substitute for a complete export of wanted conversations.

- **ChatGPT:** Settings > Personalization > Memory: turn **Enable memory** off; inspect both
  **Manage** (memory summary) and **saved memories** (older entries). The summary's menu offers
  **Delete and turn off memory**; legacy entries need their own deletion check. Clear personal custom
  instructions/About you fields. Turn **Reference record history** and **Reference my writing
  style** off. Older interfaces may show separate saved-memory and chat-history-reference
  switches instead. Disabling a switch does not prove stored content was erased. Keep desktop
  **Computer History** off as well.
- **Codex:** Settings > Personalization > **Enable memories** off. Inspect `/memories` in the
  active chat to ensure it neither uses nor contributes memory. The CLI config equivalent is
  `[features] memories = false`; preserve the rest of its generated configuration. Do not restore
  `~/.codex/memories` from the old Mac.
- **Claude cloud:** Settings > Memory: disable **Generate memory from chats** and **Search and
  reference chats**. Use **Reset**, not Pause, when clearing existing memories, including project
  memories. Remove old account/project instructions separately. Claude Code automatic memory is
  already disabled by this repo; cloud memory is a separate setting.
- **Grok Build:** use `--no-memory` for sessions. Do not enable experimental cross-session memory.
  Consumer Grok and Grok Bot have separate personalization, instructions, files, and routine state;
  inspect those account controls rather than assuming a CLI setting clears them.

Existing cloud-data deletion is a separate, explicitly scoped operation. Account deletion is not
required and would threaten subscriptions. Export wanted context privately before deleting chats,
projects, uploads, or routines; an account wipe must not silently discard information absent from brain.

## Prove the restore

Run each check in a new terminal from `~/orca/projects/dotfiles`. Check each exit status and output
individually; the final command's success does not excuse an earlier failure:

```sh
test "$(readlink "$HOME/.dotfiles")" = "$HOME/orca/projects/dotfiles"
git config --get user.name
git config --get user.email
git config --get credential.https://github.com.helper
gh auth status
git ls-remote origin HEAD
git -C "$HOME/orca/projects/brain" ls-remote origin HEAD
nix --version
node --version
claude --version
codex --version
grok --version
orca status --json
bash tests/links.test.sh
bash tests/bootstrap.test.sh
```

Then verify the actual workflows, not just the installed binaries:

- Both Git remotes are the intended HTTPS URLs. Brain remains private. In Orca, both projects
  show their GitHub state and a harmless read-only task succeeds with a chosen authenticated harness.
- Open a known source note in the restored brain. Run `git status --short` there and confirm there
  are no accidental imports or generated private files queued for publication. When Sync is ready,
  create a harmless temporary note, read it on the phone, and remove it through Obsidian.
- For an actual SSH destination, verify the public-key fingerprint and complete a login. If there
  is no destination, record **not needed**, not a fabricated SSH success.
- GitHub reads succeed repeatedly without Automic approvals. Routine writes use official `gh`
  when a real authorized repo task needs them; do not manufacture a PR just to test authentication.
- A second `./rebuild.sh` completes. Before running it, review the declaration and `git diff`;
  Homebrew upgrade/zap run immediately, with no package-confirmation preview. Monitor activation
  output. A successful Nix build alone does not test this activation.
- Open one school resource with Duo, verify Things Cloud, and run the phone check in `PHONE.md`
  if enabled. No scheduled life-management agent is considered working until its inputs, one
  harmless complete run, output destination, and failure notification have been tested.

Do not report "fully restored" with failed or untested required checks. Record omissions in the
private brain, not this public repo. If interrupted, the next agent reads this page and resumes at
the first unverified stage; it does not rebuild the system design from scratch.

## Primary references

- [Apple Setup Assistant](https://support.apple.com/guide/macbook-pro/apd831707cb3/mac) and
  [Command Line Tools](https://developer.apple.com/documentation/xcode/installing-the-command-line-tools/).
- [ChatGPT desktop](https://learn.chatgpt.com/docs/app), [Codex quickstart](https://learn.chatgpt.com/docs/quickstart),
  [Computer Use and its limits](https://learn.chatgpt.com/docs/computer-use), and
  [Codex memory controls](https://learn.chatgpt.com/docs/customization/memories).
- [Claude memory](https://support.claude.com/en/articles/11817273-use-claude-s-chat-search-and-memory-to-build-on-previous-context)
  and [Grok Build CLI](https://docs.x.ai/build/cli/reference).
