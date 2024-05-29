#!/bin/bash

volume=(
  padding_right=-2
	background.border_width=0
	background.height=24
	script="$PLUGIN_DIR/volume/scripts/volume.sh"
	update_freq=1
)

sketchybar --add item volume right \
           --set volume "${volume[@]}" \
	         --subscribe volume volume_change
