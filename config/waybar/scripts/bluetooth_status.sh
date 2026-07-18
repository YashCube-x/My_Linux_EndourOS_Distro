#!/bin/bash
POWERED=$(timeout 2 bluetoothctl show 2>/dev/null | grep -oP 'Powered: \K\w+')

if [ "$POWERED" != "yes" ]; then
    printf '{"text": " Off", "class": "off", "tooltip": "Bluetooth disabled (or bluetooth.service not running)"}\n'
    exit 0
fi

CONNECTED=$(timeout 2 bluetoothctl devices Connected 2>/dev/null | head -1 | cut -d' ' -f3-)

if [ -n "$CONNECTED" ]; then
    printf '{"text": " %s", "class": "connected", "tooltip": "Connected: %s"}\n' "$CONNECTED" "$CONNECTED"
else
    printf '{"text": " On", "class": "on", "tooltip": "No device connected"}\n'
fi
