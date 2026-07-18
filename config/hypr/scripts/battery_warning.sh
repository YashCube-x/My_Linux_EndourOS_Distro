#!/bin/bash
# Watches battery capacity and fires a mako notification once per threshold
# crossing (not every poll) — complements waybar's color-only warning, which
# is easy to miss if you're not glancing at the bar.

BAT="/sys/class/power_supply/BAT1"
WARN=30
CRIT=15
last_state="ok"

while true; do
    if [ -f "$BAT/capacity" ]; then
        capacity=$(cat "$BAT/capacity")
        status=$(cat "$BAT/status")

        if [ "$status" = "Charging" ] || [ "$status" = "Full" ]; then
            last_state="ok"
        elif [ "$capacity" -le "$CRIT" ]; then
            if [ "$last_state" != "critical" ]; then
                notify-send -u critical "Battery critical" "${capacity}% remaining — plug in now" -i battery-caution
                last_state="critical"
            fi
        elif [ "$capacity" -le "$WARN" ]; then
            if [ "$last_state" = "ok" ]; then
                notify-send -u normal "Battery low" "${capacity}% remaining" -i battery-low
                last_state="warning"
            fi
        else
            last_state="ok"
        fi
    fi
    sleep 60
done
