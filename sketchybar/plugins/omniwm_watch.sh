#!/bin/bash
# ~/.config/sketchybar/plugins/omniwm_watch.sh
# Emits a sketchybar event whenever OmniWM's active workspace changes.
# Runs under launchd, so PATH must be set explicitly.
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

while true; do
  omniwmctl watch active-workspace --exec /bin/bash -c '/opt/homebrew/bin/sketchybar --trigger omniwm_workspace_change'
  sleep 2
done
