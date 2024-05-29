#!/bin/bash

SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12")

# Destroy space on right click, focus space on left click.
# New space by left clicking separator (>)

sid=0
spaces=()
for i in "${!SPACE_ICONS[@]}"
do
  sid=$(($i+1))

  space=(
    space=$sid
    # padding_left=4
    # padding_right=4
    icon.font="Liga SFMono Nerd Font:Bold:16.0"
    icon="${SPACE_ICONS[i]}"
    icon.padding_left=7
    icon.padding_right=7
    icon.color=$GREY
    icon.highlight_color=$WHITE
    background.padding_left=2
    background.padding_right=2
    # background.height=22
    # background.color=$BACKGROUND_1
    # background.border_color=$BACKGROUND_2
    # background.border_width=1
    # background.corner_radius=5
    label.font="sketchybar-app-font:Regular:16.0"
    label.background.height=26
    label.background.corner_radius=8
    label.padding_right=20
    label.background.color="$SURFACE1"
    label.drawing=on
    label.color=$GREY
    label.highlight_color=$WHITE
    # label.y_offset=-1
    script="$PLUGIN_DIR/space.sh"
  )

  sketchybar --add space space.$sid left    \
             --set space.$sid "${space[@]}" \
             --subscribe space.$sid mouse.clicked
done

space_creator=(
  # icon=􀆊
  # icon.font="$FONT:Heavy:12.0"
  padding_left=0
  padding_right=0
  label.drawing=on
  label.color=$GREY
  display=active
  click_script='yabai -m space --create'
  script="$PLUGIN_DIR/space_windows.sh"
  icon.color=$WHITE
)

sketchybar --add item space_creator left               \
           --set space_creator "${space_creator[@]}"   \
           --subscribe space_creator space_windows_change
