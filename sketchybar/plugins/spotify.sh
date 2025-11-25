
#!/usr/bin/env bash

hide_spotify() {
  sketchybar \
    --set spotify         drawing=off popup.drawing=off \
    --set spotify.cover   drawing=off \
    --set spotify.title   drawing=off \
    --set spotify.artist  drawing=off \
    --set spotify.album   drawing=off \
    --set spotify.state   drawing=off \
    --set spotify.controls background.drawing=off \
    --set spotify.prev    drawing=off \
    --set spotify.play    drawing=off \
    --set spotify.next    drawing=off
}

update_spotify() {
  # Is Spotify running?
  if ! pgrep -x "Spotify" >/dev/null 2>&1; then
    hide_spotify
    exit 0
  fi

  state=$(osascript -e 'tell application "Spotify" to get player state' 2>/dev/null)

  if [ "$state" != "playing" ] && [ "$state" != "paused" ]; then
    hide_spotify
    exit 0
  fi

  title=$(osascript -e 'tell application "Spotify" to get name of current track' 2>/dev/null)
  artist=$(osascript -e 'tell application "Spotify" to get artist of current track' 2>/dev/null)
  album=$(osascript -e 'tell application "Spotify" to get album of current track' 2>/dev/null)
  position=$(osascript -e 'tell application "Spotify" to get player position as integer' 2>/dev/null)
  duration_ms=$(osascript -e 'tell application "Spotify" to get duration of current track as integer' 2>/dev/null)

  if [ -z "$title" ]; then
    hide_spotify
    exit 0
  fi

  # Convert duration ms -> seconds
  duration=$((duration_ms / 1000))
  [ "$duration" -eq 0 ] && duration=1

  # Clamp position
  if [ "$position" -gt "$duration" ]; then
    position=$duration
  fi

  # Percentage for slider (0–100)
  percent=$((100 * position / duration))

  # Time format
  current_minutes=$((position / 60))
  current_seconds=$((position % 60))
  total_minutes=$((duration / 60))
  total_seconds=$((duration % 60))

  current_time=$(printf "%d:%02d" "$current_minutes" "$current_seconds")
  total_time=$(printf "%d:%02d" "$total_minutes" "$total_seconds")

  # Play/Pause icon (emoji so it works with default fonts)
  play_icon="⏸️"   # show pause when currently playing
  [ "$state" = "paused" ] && play_icon="▶️"

  sketchybar \
    --set spotify        drawing=on \
    --set spotify.cover  drawing=on \
    --set spotify.title  drawing=on label="$title" \
    --set spotify.artist drawing=on label="$artist" \
    --set spotify.album  drawing=on label="$album" \
    --set spotify.state  drawing=on icon="$current_time" label="$total_time" slider.percentage="$percent" \
    --set spotify.controls background.drawing=on \
    --set spotify.prev   drawing=on \
    --set spotify.play   drawing=on icon="$play_icon" \
    --set spotify.next   drawing=on
}

case "$SENDER" in
  "routine"|"forced")
    update_spotify
    ;;
  # If you later hook a Spotify event (like com.spotify.client.PlaybackStateChanged)
  # and name it "spotify_change", this will also handle that:
  "spotify_change")
    update_spotify
    ;;
esac

