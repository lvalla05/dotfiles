#!/bin/bash
# @raycast.schemaVersion 1
# @raycast.title Today
# @raycast.mode silent
# @raycast.packageName Desk
# @raycast.description Open today's tasks and connected calendar events
set -euo pipefail
if [ -d /Applications/Todoist.app ]; then
  /usr/bin/open "todoist://today"
else
  /usr/bin/open "https://app.todoist.com/app/today"
fi
