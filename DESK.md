# The desk: Mac and phone

One launcher (Raycast), one window manager (Rectangle), an empty hidden Dock, and the same
few surfaces on both devices. Nothing here needs a subscription beyond what is already paid.

## Mac controls

| Control | Result |
| --- | --- |
| Command-Space | Raycast: launch apps, calculate, find files |
| Control-Option-V | Raycast clipboard history (seven days) |
| Control-Option-Left / Right / Return | Rectangle left half / right half / maximize |
| Raycast: Today | Todoist Today with Google Calendar events shown beside tasks |
| Raycast: Chief | Grok Bot, the daily executive |
| Raycast: Build | Ghostty (herdr session with the agent panel) |
| Raycast: Brain | The START note in the brain vault |

After a rebuild: in Raycast Settings > Extensions add the script directory
`~/.config/raycast/scripts`, set the clipboard hotkey, enable launch at login. Open Rectangle
once and grant Accessibility. Grant Wispr Flow microphone and Accessibility. Import a private
Raycast `.rayconfig` export if one exists; it never goes in this repo.

In Todoist, connect Google Calendar (Settings > Calendars, show events on) and keep
task-to-calendar sync off. Google Calendar owns time. Todoist owns tasks. Brain owns memory.
Do not add a second calendar app or a second task app.

## Daily surfaces

Mac: Grok Bot, Google Calendar, Todoist, Gmail, Obsidian, the browser, Ghostty.
Technical work opens Claude Code, Codex or pi inside herdr; Claude and ChatGPT desktop apps
stay available for Cowork and cloud tasks. Everything else lives in Raycast, not the Dock.

## Phone

Phone apps come from the App Store; the Mac declaration does not install them.

1. 1Password first; it unlocks everything else.
2. Grok Bot: the daily chief. Comet (Perplexity) as the browser, set as default.
3. Obsidian with the brain vault on Obsidian Sync. Git stays on the Mac.
4. Todoist and Google Calendar, same accounts as the Mac.
5. Gmail. Outlook and Teams for Georgia Tech and TE Connectivity only.
6. Wispr Flow keyboard. Duo Mobile. Canvas. Claude and ChatGPT for their mobile features.
7. Transact eAccounts and TransLoc when Georgia Tech needs them.

One home page: calendar agenda widget and Todoist Today widget on top; Grok Bot, Obsidian,
Gmail, Outlook; Todoist, Google Calendar, 1Password, Claude. Dock: Phone, Messages, Comet,
Camera. Everything else stays in App Library. Study, Personal and Sleep Focus modes silence
marketing and duplicate agent notifications and keep people, deadlines and security alerts.

## What phone access to agents means

Grok Bot runs in the cloud and works with the Mac off. Claude Code Remote Control and Codex
cloud tasks are opt-in ways to reach a session from the phone; they need the Mac awake or a
cloud session, not a VPN. There is no always-on home server in this setup, so nothing here
depends on one.
