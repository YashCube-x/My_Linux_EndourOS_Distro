#!/bin/bash
# Toggles quickshell's native app launcher if it's running, or falls back
# to wofi (used in battery-saver mode, see toggle_bar.sh).
if pgrep -x "quickshell" > /dev/null; then
    quickshell ipc call qsIpc toggleAppLauncher
else
    wofi --show drun -I
fi
