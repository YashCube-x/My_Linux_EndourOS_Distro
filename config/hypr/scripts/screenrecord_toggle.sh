#!/bin/bash
# Toggle screen recording with wf-recorder. Same keybind starts and stops.
OUT_DIR="$HOME/Videos/Recordings"
mkdir -p "$OUT_DIR"

if pgrep -x wf-recorder >/dev/null; then
    pkill -INT -x wf-recorder
    notify-send "Screen recording" "Stopped — saved to $OUT_DIR"
else
    FILE="$OUT_DIR/recording-$(date +%Y%m%d-%H%M%S).mp4"
    notify-send "Screen recording" "Started — press the same key to stop"
    wf-recorder -f "$FILE" >/dev/null 2>&1 &
    disown
fi
