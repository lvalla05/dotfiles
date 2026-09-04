# Phone

Desk is Orca plus Obsidian. The harness in a pane rotates.
The phone is a capture and remote-control surface, not a second ADE. Reserve approval prompts for
high-risk decisions instead of routine GitHub work.

## Apps

Install from the App Store after 1Password.

1. **1Password** first. Fill and unlock everything else.
2. **Obsidian.** Open the private brain vault. Obsidian Sync is the device transport; GitHub is
   Mac-side history, not a second phone-side writer.
3. **Things 3.** Sign into the same Things Cloud account on Mac and iPhone, then confirm an
   existing to-do and its completion state match. The Mac and iPhone apps are separate purchases.
4. **Outlook** for Georgia Tech mail and calendar. Use **Superhuman** and **Fantastical** only for
   personal accounts unless Georgia Tech OIT confirms them as approved clients. Drafts stay drafts.
5. **Wispr Flow.** Keyboard. Full Access.
6. **Duo Mobile** for Georgia Tech authentication and **Tailscale** for reaching the Mac privately.
7. **Claude** and **ChatGPT** if you want a remote into a Mac session.
   Claude Code tab uses Remote Control. ChatGPT uses Codex Remote.
   Neither is required for brain or for Orca on the desk.
8. **Orca Mobile** (beta) as an optional session surface.
9. **Canvas** and **Teams** for school and work.
10. **Transact eAccounts** when Georgia Tech marks this student eligible for a Digital BuzzCard;
    add it to Apple Wallet only after confirming the physical-card transition.
11. **TransLoc** for Stinger routes and Stingerette/on-demand rides.

The active financial providers and review status live in private `brain/SERVICES.md`. Install a
banking app only for an active account whose alerts, payments, deposits, or authentication matter.
Do not publish that list in this repo.

For each Claude cloud routine, remove connectors it does not need. All current connectors are
included by default, and their tools can write without a prompt. Define the routine's authorized
calendar and mail actions. Work that needs the live local brain runs locally; cloud routines see
their selected repositories and connected services, not uncommitted files on this Mac.

## Mac half of a remote session

For unattended local work, keep the Mac on power and enable System Settings > Battery > Options >
**Prevent automatic sleeping on power adapter when the display is off**, or the host app's
keep-awake option after verifying it also covers idle time before scheduled runs.
Locking the screen is different from putting the Mac to sleep;
test the actual tools while locked because computer use and secret access can still require unlock.

Claude Remote Control is enabled automatically for interactive Claude sessions by
`remoteControlAtStartup` in `home/.claude/settings.json`. Execution stays on the Mac, but connected
session transcripts, including tool activity, are stored on Anthropic servers. A project-local
`remoteControlAtStartup: false` opts that project out of auto-connect.

For Claude Remote Control:

- `claude-code@latest` is the local Remote Control host. The declared `claude` desktop app's
  Dispatch workflow is separate; it is not required for CLI Remote Control.
- Run `claude` once in a project directory. Trust does not save for `$HOME`.
- Long sessions: `claude remote-control` inside `tmux`; tmux does not keep the Mac awake.
- Sleep pauses local work. Remote Control reconnects after wake and network recovery.
  Keep the lid open plus power, or use supported closed-display operation.

If you use Codex Remote, the ChatGPT desktop app is the host. In Settings > Connections >
**Control this Mac or PC**, complete setup, scan its QR code from the phone, and use the same
account and workspace. Same lid rule.

For Orca Mobile, sign the Mac and phone into the intended network path, open desktop Orca, create
a fresh pairing code, and pair once. The desktop stays the source of truth and must remain open and
reachable. Tailscale is optional transport; it is not Georgia Tech's VPN.

## Check once

Keep the old Duo enrollment or another verified Georgia Tech recovery method until the replacement
phone completes a real login. Then start a harmless remote task and status notification, lock the
phone, and confirm status, reply, and both notifications work. Repeat under a Focus that silences
notifications, then check again after the Mac display's idle timeout. Do not manufacture an approval prompt.
