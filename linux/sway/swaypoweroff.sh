#!/usr/bin/env bash

op=$( echo -e " Poweroff\n Reboot\n Suspend\n Lock\n Logout" | wofi -i --dmenu | awk '{print tolower($2)}' )

case $op in
        poweroff)
          systemctl poweroff
                ;&
        reboot)
          systemctl reboot
                ;&
        suspend)
          loginctl suspend
          ;&
        lock)
				swaylock
                ;;
        logout)
                swaymsg exit
                ;;
esac
