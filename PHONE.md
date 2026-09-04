# Phone

Desk is Orca plus Obsidian. The harness in a pane rotates.
The phone is a capture and approval surface, not a second ADE.

## Apps

Install from the App Store after 1Password.

1. **1Password** first. Fill and unlock everything else.
2. **Obsidian.** The vault. Daily capture, courses, research, session notes.
   Sync must be on before you trust the phone as a second copy.
3. **Things 3.** Today's list. One inbox, not five.
4. **Superhuman** and **Fantastical.** Mail and calendar faces. Drafts stay drafts.
5. **Wispr Flow.** Keyboard. Full Access.
6. **Claude** and **ChatGPT** if you want a remote into a Mac session.
   Claude Code tab uses Remote Control. ChatGPT uses Codex Remote.
   Neither is required for the vault or for Orca on the desk.
7. **Canvas** and **Teams** for school and work.

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

## Check once

Start a task that will need a yes. Lock the phone. Confirm the push arrives.
Repeat under a Focus that silences notifications.
