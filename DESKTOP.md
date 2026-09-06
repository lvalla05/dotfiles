# The desk

One keyboard entry point: Raycast. One window manager: Rectangle. The Dock is empty,
auto-hidden and size 16. App sign-ins and private data stay in the existing accounts.
Aside is the preferred Mac browser. Grok Bot is the main daily-life AI. Codex and Claude GUI are available
for technical work; Orca is an optional workspace for terminal harnesses.

## Daily controls

| Control | Result |
| --- | --- |
| Command-Space | Raycast search: launch apps, calculate, find files |
| Control-Option-V | Clipboard History, seven-day retention |
| Control-Option-Left / Right | Rectangle left / right half |
| Control-Option-Return | Rectangle maximize |
| Raycast: Today | Todoist Today, with connected calendar events and tasks together |
| Raycast: Chief | Grok Bot; open the daily chief named in the current private handoff |
| Raycast: Build | Optional Orca terminal workspace and Ghostty |
| Raycast: Brain | The START note in the registered brain vault |

In Todoist, connect the existing Google Calendar account under Settings > Calendars and enable
Show events. Check Today/Upcoming against the live calendar. Keep task-to-calendar sync off
when the existing calendar already contains the work blocks, to avoid duplicate scheduled time.

The four Desk commands launch real apps and pages; they do not claim to execute tasks inside
them. Keep Raycast's window-management commands unassigned so Rectangle owns tiling. Use the
chief for Plan today, Capture a task, and Replan unfinished work. Source apps remain usable
when an agent is unavailable. Keep one calendar and one task inbox; do not duplicate them in a
website, Things, Notion or another agent's schedule.

## Restore Raycast

The Nix declaration restores Command-Space and the Desk scripts. In Raycast Settings >
Extensions, use + > Add Script Directory and select `~/.config/raycast/scripts`. Enable launch
at login. Set Clipboard History's hotkey to Control-Option-V and retention to seven days.
Disable Spotlight's Command-Space shortcut only if it conflicts with Raycast. Verify app
launch, a harmless copied marker in clipboard history, and each Desk command once.

Import a private `.rayconfig` export to restore extension hotkeys, aliases and preferences.
Keep exports outside this public repo: they may contain personal extension data. Use Raycast's
Export Settings & Data command, select configuration categories deliberately, and save it to
the verified off-device backup. An export on the Mac being erased is not a backup. Clipboard
history is not required to restore the workflow. No Raycast Pro subscription is required for
this baseline.

## Restore Rectangle

The declaration selects Control-Option shortcuts and the launch-on-login preference. Open
Rectangle once, enable its actual Login Item and grant Accessibility through macOS. Verify
left half, right half and maximize on an expendable document. Preference values alone do not
prove the operating system registered login startup or delivered global shortcuts.

## Keep the workspace calm

Keep the daily surfaces to Grok Bot, Aside, Calendar, Todoist, the mail app and Obsidian. Launch
Codex/ChatGPT, Claude, or the optional Orca workspace through Raycast when doing technical work.
Cursor and Ghostty remain available. Installed applications can remain available without being
pinned or launched at every login. Keep the desktop clear; Finder has list view, path and
status bars. The Dock settings and these core keyboard preferences are declared in Nix.

After reset, sign into the same accounts. Read the active connector and routine inventory in
private brain before reconnecting anything. If the user reset Grok Bot, rebuild its daily chief
from the current private handoff and verify it. Otherwise reuse the current chief and routines;
reinstalling the desktop app alone does not require recreating them.

If Aside sign-in is blocked by missing recovery material, stop retrying and follow the supported
recovery/support route in private Brain. Use an authenticated Chrome/Safari session temporarily;
continue preservation and restore work. Mark Aside **pending recovery**. After account recovery,
set Aside as the default through supported settings and verify an external HTTPS link opens there.
Then qualify its browser tools. Chrome remains available for integrations that require it.
Browser installation, account access and default selection are separate checks.

References: [Raycast script commands](https://github.com/raycast/script-commands),
[Raycast export](https://manual.raycast.com/import-export),
[Rectangle](https://github.com/rxhanson/Rectangle).

## Agent execution settings

Claude uses the requested bypass-permissions mode with routine ask rules empty. Codex restores
`approval_policy = "never"` and `sandbox_mode = "danger-full-access"` while preserving the rest
of its existing configuration. These local settings do not dismiss operating-system privacy
prompts, provider sign-in challenges or tool-enforced handoffs. Use the normal supported account
flow once; record a blocked connection rather than loop endlessly.
