#!/bin/bash

# Add the aerospace events we specified in aerospace.toml
sketchybar --add event aerospace_workspace_change
sketchybar --add event aerospace_monitor_change

for sid in $(aerospace list-workspaces --all); do
  sketchybar --add item space.$sid left \
    --set space.$sid \
    display="$(
      v=$(aerospace list-windows --workspace "$sid" --format "%{monitor-appkit-nsscreen-screens-id}" | cut -c1)
      echo "${v:-1}"
    )" \
    drawing=off \
    background.corner_radius=5 \
    background.drawing=on \
    background.border_width=1 \
    background.border_color="$TEXT_WHITE" \
    background.height=23 \
    background.padding_right=5 \
    background.padding_left=5 \
    icon="$sid" \
    icon.shadow.drawing=off \
    icon.padding_left=10 \
    label.font="sketchybar-app-font:Regular:16.0" \
    label.padding_right=20 \
    label.padding_left=0 \
    label.y_offset=-1 \
    label.shadow.drawing=off \
    click_script="aerospace workspace $sid"
done

# Load Icons on startup
for mid in $(aerospace list-monitors | cut -c1); do
  for sid in $(aerospace list-workspaces --monitor $mid --empty no); do
    apps=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

    sketchybar --set space.$sid drawing=on

    icon_strip=" "
    if [ "${apps}" != "" ]; then
      while read -r app; do
        icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
      done <<<"${apps}"
    else
      icon_strip=""
    fi
    sketchybar --set space.$sid label="$icon_strip"
  done
done

# Set color for currently focused space
sketchybar --set space."$(aerospace list-workspaces --focused)" background.color=$HIGHLIGHT_BACKGROUND label.color=$TEXT_WHITE icon.color=$TEXT_WHITE background.border_color=$TEXT_GREY
sketchybar --add item spacePaddingRight left --set spacePaddingRight padding_left=-18
