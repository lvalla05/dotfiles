# Restore a wiped Mac

This repo is the machine. Secrets live in 1Password. Personal context lives in the private
`brain` repo, opened in Obsidian.
GitHub is HTTPS plus official `gh`. Set up as a new Mac; restore selected data, not the old
machine configuration. Keep this page open on the phone:
https://github.com/lvalla05/dotfiles/blob/main/SETUP.md.

This guide performs a **Mac-only reset**. Cloud conversation cleanup is a separate operation;
use the latest explicitly confirmed scope in the private Brain rather than an old chat or this
guide as deletion authority. Preserve saved work and account access. The machine
restore and an always-on executive workflow are separate acceptance checks; a successful install
does not mean a phone-accessible cloud agent has been deployed.

## Before you click erase

Do not erase until all five checks are true:

1. `dotfiles` is committed and pushed to https://github.com/lvalla05/dotfiles.
2. `lvalla05/brain` exists, is **private**, and its working tree is committed and pushed.
3. A fresh download/clone of both repositories contains the latest work, and any phone-only notes
   have a separate backup. Inventory `git worktree list --porcelain` in every wanted project:
   inspect dirty/untracked files and unpushed commits in each worktree, not only `main`. Push wanted
   branches and read their commits back from GitHub. Obsidian Sync will be configured **after**
   reset; it is not the backup gate.
4. A 1Password sign-in/recovery path works without this Mac or either GitHub repo: an unlocked,
   signed-in phone retained through restoration can approve the new-device QR sign-in, or use an
   Emergency Kit with the account password and any required second factor.
5. Local-only coursework, media, and project outputs outside Git repos are backed up elsewhere or
   deliberately abandoned; check `~/Documents`, `~/Downloads`, and `~/Developer` explicitly.

This public repo contains neither personal context nor a credential backup. Confirm Apple Account,
Google/GitHub, the AI subscription account, and Georgia Tech/Duo credentials and verification factors
are accessible from the retained phone or another independent recovery method. The actual restored
Mac sign-ins are tested after reset. Keep recovery material out of Git. A clean Git status is not
proof of a remote backup. Do not erase while either repository has unpublished work.

1Password documents [new-device QR sign-in](https://support.1password.com/qr-code-security/) and
[finding account setup details on an existing device](https://support.1password.com/secret-key/).
Keep the trusted phone intact until the restored Mac works. Full activation of the installation
being erased, phone layout, and always-on agent tests are not pre-erase preservation gates.

## Setup Assistant

1. Connect power and Wi-Fi. Choose **set up as a new Mac** instead of migrating the old system.
   Local short name **`likhithvalla`**. Complete Setup Assistant and available macOS updates.
2. Apple Account from the phone. iCloud Keychain on. Touch ID on.

## Before bootstrap

Use built-in Safari to read this guide while bringing up the fresh Mac. Install desktop apps
through the Nix/Homebrew declaration, not individual DMG downloads or a second package manager.
Bootstrap installs ChatGPT/Codex, Claude, Grok Bot, Aside, 1Password and the other declared apps.
Use the App Store only for the declared apps that require it. Apple's Command Line Tools and
the pinned Nix/Homebrew bootstrap are the prerequisites, not a parallel app-installation route.

1. Open the Mac App Store and sign into the existing account for the declared apps:
   **1Password for Safari**, **Dynamic wallpaper**, and **uBlock Origin Lite**.
   The declared `masApps` run during bootstrap; `mas` reinstalls acquired apps.
   Todoist is the task system and is installed by Homebrew.
2. Use the retained phone's 1Password and account verification to complete those sign-ins.
   The rebuild installs 1Password on the Mac; do not export the vault or download a duplicate app.

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

Run these initial commands in Terminal. Run `./bootstrap.sh` as the ordinary user,
not with `sudo ./bootstrap.sh`; enter the administrator password directly when the script requests it.

```sh
git clone https://github.com/lvalla05/dotfiles.git ~/orca/projects/dotfiles
cd ~/orca/projects/dotfiles
./bootstrap.sh
```

The bootstrap accepts only Apple silicon, verifies a pinned Determinate installer, and runs the
first `darwin-rebuild` from `flake.lock`. It installs the declared GUI apps and harness CLIs,
including the optional Orca workspace. Do not install a parallel Homebrew, Nix, or global npm toolchain yourself.
The rebuild also sets `[features.context_management] experimental_mode = true` in
`~/.codex/config.toml` for the Astra context-management experiment, preserving the selected
model, plugins and other settings. Start a new Astra task to use it; enabling the flag does
not retroactively change a running task. See [experimental context management](https://learn.chatgpt.com/docs/models#experimental-context-management).
If a stage fails, keep its exact error. A malformed existing Codex TOML produces a warning and
leaves that file untouched so the rest of the restore can proceed; repair that reported config
before marking Codex ready. Check any blocked Determinate background items in System
Settings > General > Login Items, or App Store ownership/sign-in for a `mas` failure. Re-run the
bootstrap only after diagnosing the failed stage. Do not erase again or uninstall Nix as a generic fix.
Both scripts refuse root execution, a linked worktree, or an existing `~/.dotfiles` pointing
elsewhere. Resolve the reported checkout/pointer mismatch rather than deleting or overwriting it.

Open a **new** terminal. `rebuild` is an alias.

## Open an installed technical assistant

Use Codex in the installed ChatGPT app, Claude's GUI, or a terminal harness in Orca. These are
alternative technical surfaces, not prerequisites for one another. Sign into the existing account
and select the appropriate available model. Do not purchase another subscription or route through
another app solely to follow this guide. The private post-reset handoff names any requested audit.

Enable the selected app's supported Computer Use integration and complete the required macOS
Accessibility and Screen Recording approvals. Test a harmless page read before relying on it.
Use its structured shell for ordinary command-line work where available. Protected OS approvals,
secret unlocks and any tool-required human steps remain native handoffs; never work around a denial.

Paste this handoff into the selected assistant:

> Continue restoring this Mac from https://github.com/lvalla05/dotfiles. Read AGENTS.md, SETUP.md,
> BRAIN.md, PHONE.md and the bootstrap scripts fully. Bootstrap owns Mac app installation through
> Nix/Homebrew; App Store is only for required apps. Do not reinstall completed stages.
> Grok Bot is the daily/mobile executive. Aside is the Mac browser; Comet is the phone browser.
> Technical work can use Codex or Claude GUI, or optional Orca terminal harnesses. Harnesses rotate.
> Use official gh over HTTPS, 1Password for credentials, and private lvalla05/brain for personal context.
> Obsidian Sync follows the Mac restore. Use supported tools and already-authorized native account
> selections/passkeys. Ask only for a step the tool or OS requires the human to perform; never ask
> for secret values in chat. Report checks as pass, fail or not tested. Keep declared apps, zap,
> official gh and one canonical Brain. Verify the selected technical app and a private Brain readback;
> do not require an unused Orca flow. Read the latest private reset handoff before rebuilding Grok Bot,
> changing cloud conversations or resuming the audit. Installation is not integration proof. Do not
> buy subscriptions or create unrelated automations. Activate only from the durable main checkout,
> never from a disposable worker worktree.

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

5. **Only when using Orca:** launch it and add `~/orca/projects/dotfiles` and
   `~/orca/projects/brain` as separate projects. Codex/Claude GUI workflows can use their own
   project and task controls without an Orca wrapper. Keep private context scoped to Brain.
   Leave Agent Permissions on the vendor default (permission-bypass). Sign into whichever
   harnesses you use; none is permanent.
   Fully restart Orca after `gh` authentication, then refresh its GitHub/Source Control view for
   both projects. Orca uses the host's `gh` credentials. Keep `GH_TOKEN` and `GITHUB_TOKEN` out of
   shell and GUI startup environments so stale values cannot override the credential store.
   Register Orca's CLI in its Settings and verify `orca status --json`. Check each chosen harness's
   signed-in account and loaded MCP servers. Grok Build can import Claude and Cursor MCP settings;
   review those imports for duplicates or unwanted access. Remote Orca hosts need their own
   provider and `gh` authentication; this Mac's login does not transfer.
   Follow `WORKFLOW.md` for the bounded engineering worker and review loop. Enable Orca
   Orchestration in Experimental settings if needed; test a bounded read-only worker and its
   structured completion before depending on it. Keep recurring automations disabled until their
   inputs, output, duplicate-run behavior, and notifications have been tested.
   Inspect each project's setup hook. Dotfiles and brain are not npm projects: clear a generic
   `pnpm install` hook if Orca supplies or restores one. In Settings, select the repository and
   host, then Worktree Hooks → Setup Script; clear the command and leave the field to save it.
   Check Advanced / Script Source for a shared `orca.yaml` hook as well. A placeholder is not a
   configured command. Do not put `bootstrap.sh` or `rebuild.sh`
   in a worktree setup hook; creating a worker must not activate or zap the whole machine.

6. Restore only MCPs needed by the selected workflows. Do not reinstall a canceled service
   from an older setup list. If the current private service inventory calls for Spiral, add it
   and complete its explicit OAuth login:

   ```sh
   codex mcp add spiral --url https://api.writewithspiral.com/mcp/
   codex mcp login spiral
   codex mcp list
   ```

   If `spiral` already exists, inspect `codex mcp get spiral` before changing it. Test a read-only
   Spiral operation; appearing in the list is not proof of authorization. Authenticate other MCPs
   only when a selected workflow needs them; do not import an old server list wholesale.

7. Read the **Memory boundary** below and the latest private reset handoff before personal work.

8. **Only if a selected local workflow needs Automic:** launch Automic Vault and use its app to
   install the matching `av` CLI. Otherwise record **installed, not needed yet** and continue.
   Start empty after the wipe. Do not recreate `GH_TOKEN*`, enable the GitHub hardener, or enable the Homebrew hardener.
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

9. Sign in to Aside and the selected desktop/harness accounts using their native login flows.
   If Aside needs a missing password or recovery key, stop repeated login attempts and follow the
   provider's supported recovery/support route recorded in private Brain. Use an already-authenticated
   Chrome or Safari session temporarily; on a fresh Mac, restore that fallback through normal sign-in.
   Continue preservation and restoration while recovery is pending. Record Aside as **pending recovery**,
   not working. Do not set it as the default or qualify its MCP tools until account access is resolved.
   Confirm the intended subscription is active before enabling any metered API billing.
   After recovery, set Aside as the Mac's default and verify an HTTPS link from another app opens there.
   The declaration installs its [official Homebrew cask](https://formulae.brew.sh/cask/aside).
   Keep 1Password as the password store. Follow the browser-worker
   section in `WORKFLOW.md`: native sign-in, 1Password integration, CLI/MCP setup, then a harmless
   page-read test from the chosen harness. Do not bulk-import passwords, buy a plan, or create a
   Slack bot as part of the basic restore. Keep Chrome for required integrations and this temporary fallback.
10. Sign in to Microsoft Outlook and Teams with the Georgia Tech account. Keep Georgia Tech data in
   Institute-approved apps, not personal mail or calendar clients.
11. Use ISyE VLab in the browser for course software. If a class or restricted resource requires
   Georgia Tech VPN, verify the approved distribution at `https://vpn.gatech.edu/` and a supported
   declarative installation before adding GlobalProtect. If that route is unavailable, record the
   blocker instead of an ad hoc install. Do not substitute Tailscale or an unverified cask.
12. Restore the desk from `DESKTOP.md`: Raycast launcher and clipboard, Rectangle tiling,
    an empty hidden Dock, and the existing calendar/task accounts. Import the private Raycast
    settings export after installing Raycast; do not add its contents to this public repo.
    Grant Wispr Flow its microphone/Accessibility permissions. Grant Raycast or other apps only
    the permissions needed by enabled features. Finish `PHONE.md`, including its home-screen layout,
    Todoist, and native phone workflows. Remote Control is optional and does not auto-start.
13. Open Grok Bot as the daily/mobile executive. Read the latest private handoff: if the user reset
    Bot, rebuild the chief from its saved context; otherwise reuse the current one. Verify its
    identity, mail, calendar and Todoist through the current adapters. Reconcile routines against
    that handoff; do not restore stale bot IDs or create duplicate executive schedules in other apps.
    Verify where each background job runs. Test Grok's phone and Mac-off path separately from
    optional Orca engineering access. Without an independent Orca host, laptop-off Orca work is
    **not configured**; it is not a prerequisite for the Grok daily interface. Do not buy a server
    or create another scheduler silently. A cloud backup account is not a running agent host.

## Memory boundary

Brain is the canonical destination for new personal context, decisions, and outcomes. Cloud
conversation cleanup needs its own explicit scope and is not performed by bootstrap or rebuild.
Read the latest private reset handoff for that scope. Conversations, saved memories, project
files, account instructions and routines are different objects; do not treat one deletion request
as authority to remove all of them. Retained history is evidence, not another maintained source
of truth or a replacement for the fresh post-restore audit.

Claude Code's new-device automatic memory is disabled by the declared configuration. Avoid
creating another automatic personal-memory store in a new local tool; send useful outcomes to
brain instead. Do not overwrite a signed-in account's existing settings to enforce that preference.
Do not restore old local caches as the canonical brain. Provider chat retention and training are
separate account controls, not guarantees made by this repo. Review them without silently changing
the user's cloud configuration. Never place credentials in brain or upload the whole vault to
every provider.

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
bash tests/links.test.sh
bash tests/bootstrap.test.sh
bash tests/activation.test.sh
python3 tests/configure_codex_test.py
```

Then verify the actual workflows, not just the installed binaries:

- Both Git remotes are the intended HTTPS URLs. Brain remains private. The selected Codex/Claude
  GUI or Orca harness completes a harmless read-only task with the intended authenticated account.
  If using Orca, also verify `orca status --json` and both projects' GitHub state; otherwise record
  that optional route as **not selected**.
- After account recovery, an external HTTPS link opens in Aside and its selected browser tools pass
  a harmless read. While recovery is pending, verify the Chrome/Safari fallback, record Aside as
  **pending recovery**, and continue the Mac restore; do not claim the final Aside workflow passed.
  The Grok Bot daily entry points to the intended chief
  from the current private handoff; an old pinned bot is not automatically the right destination.
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
- Open one school resource with Duo, verify Todoist, and run the phone check in `PHONE.md`
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
