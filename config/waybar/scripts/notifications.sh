#!/usr/bin/env bash
# Reports mako's do-not-disturb state for the waybar custom/notification module.

BELL=""
BELL_SLASH=""

if makoctl mode 2>/dev/null | grep -q "do-not-disturb"; then
    printf '{"text": "%s", "tooltip": "Do not disturb (click to enable notifications)", "class": "dnd"}\n' "$BELL_SLASH"
else
    printf '{"text": "%s", "tooltip": "Notifications enabled (click to mute)", "class": "active"}\n' "$BELL"
fi
