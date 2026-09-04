# Phone

Desk is Orca. The harness in a pane rotates. Phone is the Claude iOS app, Code tab.
Do not rebuild ntfy plus Tailscale plus Termius plus Orca-mobile.

Orca iOS push is still broken in the background (stablyai/orca #8129, 2026-09-02).
It is not the front door.

## Stack

**Primary.** Claude iOS, Code tab. Remote Control for files on this Mac. Dispatch (Pro/Max,
desktop app open) for a task you message from the phone.

**Fallback.** Codex Remote in the ChatGPT app. Set it up once. Do not use it daily.

**Not the link.** ntfy, Pushover, Orca mobile, Hermes, Termius as the daily driver.

## Mac

1. Cask `claude` is declared. Dispatch needs the desktop app open.
2. `claude --version` is 2.1.260 or later (`claude-code@latest`).
3. This must print nothing:

   ```sh
   env | grep -E 'DO_NOT_TRACK|DISABLE_TELEMETRY|CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC|DISABLE_GROWTHBOOK|ANTHROPIC_BASE_URL|ANTHROPIC_API_KEY|ANTHROPIC_AUTH_TOKEN'
   ```

4. Run `claude` once in a project directory. Trust does not save for `$HOME`.
5. `home/.claude/settings.json` already has Remote Control at startup and both push toggles.
6. Long sessions: `claude remote-control` inside `tmux`.

## Phone

1. 1Password, then Claude by Anthropic, same claude.ai account. Allow notifications.
2. Wispr Flow keyboard, Full Access.
3. Code tab. This Mac should show as a device card.
4. Hit a permission on purpose, lock the phone, confirm the push. Repeat under a Focus
   that silences notifications.

Do not connect Gmail or Google Calendar to the claude.ai account. A cloud routine includes
every connected connector, and per-tool Blocked is Team/Enterprise only.

## Lid shut

Sleep stops Remote Control. Lid open plus power, or lid closed plus an external display.
Anything that must run while the machine sleeps is a cloud session, and it does not see
the vault.
