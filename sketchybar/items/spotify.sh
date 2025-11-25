
#!/usr/bin/env bash

# Simple safe defaults; if you already have these in colors.sh, it's fine:
SPOTIFY_GREEN=${TEXT_SPOTIFY_GREEN:-0xff1DB954}
WHITE=${TEXT_WHITE:-0xffffffff}
GREY=0xffa0a0a0
BACKGROUND=0xaa000000

POPUP_TOGGLE='sketchybar --set $NAME popup.drawing=toggle'

# ────────────────────────────────────────────────────────────────
# Anchor item on the bar (click to toggle popup)
# ────────────────────────────────────────────────────────────────
spotify_anchor=(
  script="$PLUGIN_DIR/spotify.sh"
  updates=on
  update_freq=2

  click_script="$POPUP_TOGGLE"

  popup.horizontal=on
  popup.align=center
  popup.height=140

  icon=""
  icon.color="$SPOTIFY_GREEN"

  label.drawing=off
  drawing=on
  y_offset=0
)

sketchybar --add item spotify right \
           --set spotify "${spotify_anchor[@]}"

# ────────────────────────────────────────────────────────────────
# Cover (square block on the left; can later be album art)
# ────────────────────────────────────────────────────────────────
spotify_cover=(
  label.drawing=off
  icon.drawing=off

  padding_left=12
  padding_right=10

  background.drawing=on
  background.corner_radius=8
  background.color="$BACKGROUND"
  background.image.drawing=off        # turn on if you set a background.image

  width=60
  height=60
  drawing=off
)

sketchybar --add item spotify.cover popup.spotify \
           --set spotify.cover "${spotify_cover[@]}"

# ────────────────────────────────────────────────────────────────
# Title, artist, album (text on the right)
# ────────────────────────────────────────────────────────────────
spotify_title=(
  icon.drawing=off
  padding_left=0
  padding_right=0
  width=0
  label.font="SF Pro:Heavy:15.0"
  label.color="$WHITE"
  label.max_chars=30
  y_offset=55
  drawing=off
)

spotify_artist=(
  icon.drawing=off
  padding_left=0
  padding_right=0
  width=0
  label.color="$GREY"
  label.font="SF Pro:Regular:12.0"
  label.max_chars=35
  y_offset=30
  drawing=off
)

spotify_album=(
  icon.drawing=off
  padding_left=0
  padding_right=0
  width=0
  label.color="$GREY"
  label.font="SF Pro:Regular:11.0"
  label.max_chars=35
  y_offset=15
  drawing=off
)

sketchybar --add item spotify.title  popup.spotify \
           --set spotify.title  "${spotify_title[@]}" \
           --add item spotify.artist popup.spotify \
           --set spotify.artist "${spotify_artist[@]}" \
           --add item spotify.album  popup.spotify \
           --set spotify.album  "${spotify_album[@]}"

# ────────────────────────────────────────────────────────────────
# Time + slider (current time on left, total on right, bar between)
# ────────────────────────────────────────────────────────────────
spotify_state=(
  icon.drawing=on
  icon.font="SF Pro:Light Italic:10.0"
  icon.width=35
  icon="00:00"
  icon.color="$GREY"

  label.drawing=on
  label.font="SF Pro:Light Italic:10.0"
  label.width=35
  label="00:00"
  label.color="$GREY"

  padding_left=0
  padding_right=0
  y_offset=-10
  width=0

  slider.background.height=6
  slider.background.corner_radius=3
  slider.background.color="$GREY"
  slider.highlight_color="$SPOTIFY_GREEN"
  slider.percentage=0
  slider.width=130

  script="$PLUGIN_DIR/spotify.sh"
  update_freq=1
  updates=when_shown

  drawing=off
)

sketchybar --add slider spotify.state popup.spotify \
           --set spotify.state "${spotify_state[@]}"

# ────────────────────────────────────────────────────────────────
# Controls row: prev | play/pause | next
# ────────────────────────────────────────────────────────────────
spotify_prev=(
  icon="􀊊"
  icon.color="$WHITE"
  label.drawing=off
  y_offset=-40
  drawing=off
  click_script='osascript -e "tell application \"Spotify\" to previous track"'
)

spotify_play=(
  icon="􀊈" 
  background.height=40
  width=40
  icon.color="$WHITE"
  label.drawing=off
  y_offset=-40
  drawing=off
  click_script='osascript -e "tell application \"Spotify\" to playpause"'
)

spotify_next=(
  icon="􀊌"
  icon.color="$WHITE"
  label.drawing=off
  y_offset=-40
  drawing=off
  click_script='osascript -e "tell application \"Spotify\" to next track"'
)

sketchybar --add item spotify.prev popup.spotify \
           --set spotify.prev "${spotify_prev[@]}" \
           --add item spotify.play popup.spotify \
           --set spotify.play "${spotify_play[@]}" \
           --add item spotify.next popup.spotify \
           --set spotify.next "${spotify_next[@]}"

# Small spacer at the end of controls row
sketchybar --add item spotify.spacer popup.spotify \
           --set spotify.spacer width=5 drawing=on

# Bracket to wrap the control row with a background
spotify_controls=(
  background.color="$SPOTIFY_GREEN"
  background.corner_radius=11
  background.drawing=on
  y_offset=-40
)

sketchybar --add bracket spotify.controls \
                           spotify.prev \
                           spotify.play \
                           spotify.next \
           --set spotify.controls "${spotify_controls[@]}"

