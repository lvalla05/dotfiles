#!/bin/bash
# @raycast.schemaVersion 1
# @raycast.title Build
# @raycast.mode silent
# @raycast.packageName Desk
# @raycast.description Open the optional Orca terminal workspace and Ghostty
set -euo pipefail
/usr/bin/open -a Orca
/usr/bin/open -a Ghostty
