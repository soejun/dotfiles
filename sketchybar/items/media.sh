#!/bin/bash
media=(
  background.padding_right=20
  icon.background.drawing=off
  icon.background.image=media.artwork
  icon.background.image.corner_radius=16
  icon.background.image.scale=0.9
  icon.background.image.padding_right=12
  script="$PLUGIN_DIR/media.sh"
  label.color=$GREEN
  label.max_chars=255
  scroll_texts=on
  updates=on
)

sketchybar --add item media right   \
           --set media "${media[@]}" \
           --subscribe media media_change
