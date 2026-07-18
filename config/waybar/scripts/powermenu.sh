#!/usr/bin/env bash
# Simple wofi-based power menu for the waybar power button.

options="⏻ Shutdown\n Reboot\n Logout"
chosen=$(echo -e "$options" | wofi --dmenu --prompt "Power" --width 220 --height 150 | xargs)

case "$chosen" in
    "⏻ Shutdown") systemctl poweroff ;;
    " Reboot") systemctl reboot ;;
    " Logout") hyprctl dispatch exit ;;
esac
