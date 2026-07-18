#!/bin/bash
# Adjusts brightness, then shows quickshell's native OSD if it's running,
# or falls back to wob (used in battery-saver mode, see toggle_bar.sh).
ACTION=$1

case $ACTION in
    up) brightnessctl s 5%+ ;;
    down) brightnessctl s 5%- ;;
esac

PCT=$(brightnessctl i | grep -oP '\(\K[^%]+')

if pgrep -x "quickshell" > /dev/null; then
    quickshell ipc call qsIpc showOsd B "$PCT"
else
    echo "$PCT" > "$XDG_RUNTIME_DIR/wob.fifo"
fi
