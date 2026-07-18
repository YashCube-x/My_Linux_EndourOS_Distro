#!/bin/bash
# Toggles quickshell's native power menu if it's running, or falls back
# to the wofi-based power menu (used in battery-saver mode).
if pgrep -x "quickshell" > /dev/null; then
    quickshell ipc call qsIpc togglePowerMenu
else
    ~/.config/waybar/scripts/powermenu.sh
fi
