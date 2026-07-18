#!/bin/bash
# Keeps quickshell running, auto-restarting it if it ever exits unexpectedly.
# toggle_bar.sh disables respawning (by touching the stop file) before its
# own `pkill quickshell`, so switching to the waybar fallback isn't fought by
# this loop bringing quickshell back.

STOP_FILE="$XDG_RUNTIME_DIR/quickshell_supervisor_stop"
rm -f "$STOP_FILE"

while [ ! -f "$STOP_FILE" ]; do
    quickshell --path ~/.config/quickshell/shell.qml
    [ -f "$STOP_FILE" ] && break
    sleep 2
done
