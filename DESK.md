# The desk: Mac and phone

Raycast launches apps, Rectangle manages windows, and the Dock stays empty and hidden.
The public configuration supplies controls and applications. Personal account choices,
notifications, schedules and the current phone AI entry point live in the private brain.

## Mac controls

| Control | Result |
| --- | --- |
| Command-Space | Raycast: apps, calculations and files |
| Control-Option-V | Raycast clipboard history |
| Control-Option-Left / Right / Return | Rectangle left half / right half / maximize |
| Raycast: Today | Todoist Today |
| Raycast: Chief | Grok Bot launcher; qualify the account before relying on it |
| Raycast: Build | Ghostty; Orca is available for visual project work |
| Raycast: Brain | START note in the private brain vault |

After rebuilding, add `~/.config/raycast/scripts` in Raycast Settings > Extensions. Configure
its clipboard shortcut and launch at login. Grant Rectangle Accessibility and Wispr Flow the
microphone and Accessibility permissions it needs. Private Raycast exports stay outside Git.

For Computer Use, use `orca computer permissions --json`, then test a real window read with
`orca computer get-app-state --app <bundle-id> --json`. A granted permission alone does not
prove the capture works. If the provider reports stale Accessibility, refresh that permission
in macOS Settings and inspect the intended window again.

## Phone surfaces

Use one primary AI conversation for delegating work. Calendar and Todoist remain direct views
of time and tasks; a lookup browser can serve quick research. Keep additional AI clients in
App Library unless they perform a distinct job. Choose the actual products and notification
rules in the private brain, where they can change without leaking personal context here.

Install phone apps through the App Store; the Mac declaration does not install them. Set up
1Password first, then the task, calendar, mail, research and required organizational apps.
Obsidian uses Sync between devices; Git stays on the Mac. An agenda widget and a Today task
widget can show the day without opening several AI conversations.

Google Calendar owns accepted time and Todoist owns task identity/completion. When connecting
them, decide explicitly whether tasks should also appear as calendar events; duplicate writes
from a planner and task sync can produce conflicting blocks. Only one system should schedule
a particular routine. A notification should call for an action or decision, not repeat a
summary already available elsewhere.

## Verify the connection

Read a known task and calendar event through the chosen AI runtime. Check source identifiers,
current dates and failure behavior. Then issue a new phone request with the Mac shut down and
confirm delivery. A cloud runtime can operate elsewhere; remote control of the Mac cannot.
Verify a phone Obsidian edit reaches the Mac as a separate test. Keep actual results in brain.
