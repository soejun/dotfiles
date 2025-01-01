#!/bin/bash

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

source "$HOME/.config/sketchybar/colors.sh"

VOLUME=$INFO

volume_change() {
	source "$HOME/.config/sketchybar/icons.sh"
	case $INFO in
	[6-9][0-9] | 100)
		ICON=$VOLUME_100
    COLOR=$TEXT
		;;
	[3-5][0-9])
		ICON=$VOLUME_66
    COLOR=$TEXT
		;;
	[1-2][0-9])
		ICON=$VOLUME_33
    COLOR=$TEXT
		;;
	[1-9])
		ICON=$VOLUME_10
    COLOR=$TEXT
		;;
	0)
		ICON=$VOLUME_0
    COLOR=$RED
		;;
	*) ICON=$VOLUME_100 ;;
	esac

	# sketchybar --set $NAME icon=$ICON label="$VOLUME%"
	sketchybar --set $NAME icon=$ICON icon.color=$COLOR
}

case "$SENDER" in
"volume_change")
	volume_change
	;;
esac
