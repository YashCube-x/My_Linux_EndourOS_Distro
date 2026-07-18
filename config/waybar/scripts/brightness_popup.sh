#!/bin/bash
# Brightness slider popup (yad). Live-updates brightnessctl as the slider moves.

if pgrep -f "yad.*Brightness" >/dev/null; then
    pkill -f "yad.*Brightness"
    exit 0
fi

CURRENT=$(brightnessctl i | grep -oP '\(\K[^%]+')

yad --title="Brightness" --scale --text="Brightness" \
    --min-value=1 --max-value=100 --value="$CURRENT" --step=1 \
    --width=280 --height=90 --center --undecorated --skip-taskbar --on-top \
    --print-partial --button="Close:0" 2>/dev/null |
while read -r val; do
    brightnessctl set "${val}%" >/dev/null
done
