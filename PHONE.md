# Phone

Desk is Orca plus Obsidian. The harness in a pane rotates.
The phone is a capture and remote-control surface, not a second ADE. Reserve approval prompts for
high-risk decisions instead of routine GitHub work.

## Apps

Install from the App Store after 1Password.

1. **1Password** first. Fill and unlock everything else.
2. **Obsidian.** Open the private brain vault. Obsidian Sync is the device transport; GitHub is
   Mac-side history, not a second phone-side writer.
3. **Things 3.** Today's list. One inbox, not five.
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

Do not connect Gmail or Google Calendar connectors to a consumer claude.ai
account. A cloud routine includes every connected connector.

## Mac half of a remote session

If you use Claude Remote Control:

- Cask `claude` is declared. Dispatch needs the desktop app open.
- `claude-code@latest` is the CLI.
- Run `claude` once in a project directory. Trust does not save for `$HOME`.
- Long sessions: `claude remote-control` inside `tmux`.
- Sleep stops Remote Control. Lid open plus power, or lid closed plus a display.

If you use Codex Remote, the ChatGPT desktop app is the host. Same lid rule.

For Orca Mobile, sign the Mac and phone into the intended network path, open desktop Orca, create
a fresh pairing code, and pair once. The desktop stays the source of truth and must remain open and
reachable. Tailscale is optional transport; it is not Georgia Tech's VPN.

## Check once

Keep the old Duo enrollment or another verified Georgia Tech recovery method until the replacement
phone completes a real login. Then start a harmless remote task and status notification, lock the
phone, and confirm status, reply, and both notifications work. Repeat under a Focus that silences
notifications. Do not manufacture an approval prompt.
