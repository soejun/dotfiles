#!/bin/bash

STATE=$(blueutil -p)

if [ "$STATE" = "0" ]; then
	blueutil -p 1
  sketchybar --set $NAME icon=󰂯
else
	blueutil -p 0
  sketchybar --set $NAME icon=󰂲
fi
