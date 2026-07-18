#!/bin/bash
# Volume slider popup (yad). Live-updates wpctl as the slider moves.

if pgrep -f "yad.*Volume" >/dev/null; then
    pkill -f "yad.*Volume"
    exit 0
fi

CURRENT=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}')

yad --title="Volume" --scale --text="Volume" \
    --min-value=0 --max-value=100 --value="$CURRENT" --step=1 \
    --width=280 --height=90 --center --undecorated --skip-taskbar --on-top \
    --print-partial --button="Close:0" 2>/dev/null |
while read -r val; do
    wpctl set-volume @DEFAULT_AUDIO_SINK@ "${val}%"
done
