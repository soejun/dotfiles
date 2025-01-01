#!/usr/bin/env bash

op=$(echo -e " Shutdown \n Reboot\n Suspend\n Lock\n Logout" | wofi -i --dmenu | awk '{print tolower($2)}')

echo '$op'

case $op in
shutdown)
  systemctl poweroff
  ;;
reboot)
  systemctl reboot
  ;;
suspend)
  loginctl suspend
  ;;
lock)
  swaylock --config ~/.config/swaylock/config \
    --ignore-empty-password \
    --daemonize \
    --indicator-caps-lock \
    --show-failed-attempts \
    --indicator-idle-visible
  ;;
logout)
  swaymsg exit
  ;;
esac
