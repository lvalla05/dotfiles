# Phone

The phone is a usable daily interface, not a miniature terminal or a remote desktop.
Grok Bot is the main daily-life and mobile AI. Comet is the phone browser; Aside is the Mac browser.
Obsidian opens brain. Mail, calendar, and tasks remain
usable in their own native apps even when no agent is running.

For Grok cloud routines, verify a run with the MacBook off and inspect its actual service output.
Optional engineering access is described below; it is not a prerequisite for the Grok Bot daily flow.

## Apps

Phone apps use the App Store; the Mac's Nix/Homebrew declaration does not install iPhone apps.

1. **1Password** first. Fill and unlock everything else.
2. **Grok Bot.** Open the daily chief through the supported mobile surface named in the current
   private handoff. If the user reset Bot, rebuild from that saved handoff before verifying the
   conversation, tasks and routine results. A generic Grok chat is not automatically the chief.
3. **[Comet](https://apps.apple.com/us/app/comet-ai-browser-assistant/id6748622471).** Install the
   Perplexity AI, Inc. browser from the App Store (iOS 18 or later). Select Comet as the default
   browser in iOS settings, then verify an external HTTPS link opens there. Keep 1Password as the
   credential source. Comet browsing does not replace the Grok daily chief or automatically sync
   with Aside. [Official supported platforms](https://www.perplexity.ai/comet).
4. **Obsidian.** Open the private brain vault. Obsidian Sync is the device transport; GitHub is
   Mac-side history, not a second phone-side writer.
5. **Todoist.** Sign into the same existing account on Mac and iPhone. Confirm an existing task,
   due date and completion state match. Enable the existing Google Calendar connection to show
   events beside tasks in Today/Upcoming; keep task-to-calendar sync off when AI Plan already
   schedules the work. Use Google Calendar for individual event colors. Todoist is the one task system.
6. **Outlook** for Georgia Tech mail and calendar. Use **Superhuman** and **Fantastical** only for
   personal accounts unless Georgia Tech OIT confirms them as approved clients. Draft requests stay
   drafts; send only within explicit authorization.
7. **Wispr Flow.** Keyboard. Full Access.
8. **Duo Mobile** for Georgia Tech authentication and **Tailscale** if using a selected private host.
9. **Claude** and **ChatGPT** remain available for their native mobile capabilities. Cloud tasks and continuation of
   a local Mac session are different execution modes; inspect the selected mode before relying on it.
10. **Canvas** and **Teams** for school and work.
11. **Transact eAccounts** when Georgia Tech marks this student eligible for a Digital BuzzCard;
    add it to Apple Wallet only after confirming the physical-card transition.
12. **TransLoc** for Stinger routes and Stingerette/on-demand rides.

The active financial providers and review status live in private `brain/SERVICES.md`. Install a
banking app only for an active account whose alerts, payments, deposits, or authentication matter.
Do not publish that list in this repo.

## One home screen

Use one understated wallpaper and the system's dark/tinted icons; do not install an icon-pack
launcher or duplicate apps through Shortcuts just for appearance. Keep one main page:

- Top: a calendar agenda widget and Todoist Today widget.
- First row: the Grok Bot daily entry, Obsidian, the personal mail app, Outlook.
- Second row: Todoist, the calendar app, 1Password, the active research app.
- Dock: Phone, Messages, Comet, Camera. Everything else is in App Library.

Create Study, Personal, and Sleep Focus modes. Allow the people, calendar reminders, agent
completion alerts, and authentication/security alerts that matter in each mode. Silence marketing
and duplicate agent-status notifications. Check delivery with the screen locked; an attractive
layout that hides a real deadline is a failed setup.

## Chat, browser work, and background work

For optional engineering work through Orca Mobile, use a verified execution host. Laptop-off
Orca work requires an **always-on host independent of the MacBook**; cloud storage, Tailscale and
a model subscription do not supply one. Until it is configured and tested, record that optional
route as **not configured**, without blocking the Grok daily interface.

Orca Mobile talks to that runtime. A remote server can own it without the MacBook attached;
a desktop-hosted browser tab still needs its desktop. Unattended browser jobs must use a
server-hosted browser or a separately verified cloud browser. Native Mac app computer use cannot
be assumed to work on a Linux server. See [remote servers](https://www.onorca.dev/docs/remote-servers)
and [mobile](https://www.onorca.dev/docs/mobile).

Aside's Slack, Telegram, and Discord channels are conversational task interfaces. Do not install
another chat app merely to add another coordinator. The [Slack setup guide](https://docs.aside.com/help/channels-slack.md)
requires Aside running on the device. [Pro pricing](https://aside.com/pricing) advertises Cloud
handoff, but that alone does not prove Slack, authenticated browsing, or scheduled jobs work with
the Mac off. Test that exact path before making it a dependency. Aside remains a browser worker
under the workflow in `WORKFLOW.md`; there is no assumed native Aside iPhone app.

Cloud tasks in a provider app can be useful before an always-on Orca host exists, but they are a
separate task surface, not an automatic cross-harness handoff. Give each job one owner and only the
connectors it needs. Cloud jobs cannot see uncommitted laptop files. Consult the provider's actual
[execution and schedule modes](https://learn.chatgpt.com/docs/automations).

## Optional local continuation

Claude Remote Control and Codex Remote are opt-in fallbacks, not this setup's phone foundation.
`remoteControlAtStartup` is false. Keep the Mac awake and its host app running when explicitly
using either. `tmux`, a locked screen, and a Tailscale connection do not prevent machine sleep.
Test locked-device behavior separately from sleep; secret access and computer use may need unlock.

## Check once

Keep a verified Duo recovery method until the phone completes a real login. Verify an external link
opens in Comet and a selected site's 1Password-assisted login works. Confirm brain Sync,
Todoist, mail, and calendar independently. Then send a harmless research request to the
Grok chief, lock the phone, receive a completion alert, and reply in the same conversation.
Repeat under Study Focus and with the MacBook **shut down**, not merely its display turned off.
Record the Grok cloud result independently from any local Mac worker. For optional Orca Mobile,
repeat against its selected host; without an independent host, laptop-off engineering is **not
configured**, not passed.
Verify the saved result in brain and the actual provider record for any authorized service write.
