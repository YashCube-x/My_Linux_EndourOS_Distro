#!/bin/bash
# Bluetooth connect/disconnect popup (wofi + bluetoothctl), mirroring the
# WiFi popup's design.

if [ "$(bluetoothctl show | grep -oP 'Powered: \K\w+')" != "yes" ]; then
    CHOICE=$(echo "Turn Bluetooth On" | wofi --dmenu --prompt "Bluetooth" -I)
    [ "$CHOICE" = "Turn Bluetooth On" ] && bluetoothctl power on
    exit 0
fi

MENU_FILE=$(mktemp)
echo "Turn Bluetooth Off" >> "$MENU_FILE"
echo "Scan for New Devices" >> "$MENU_FILE"

bluetoothctl devices Paired 2>/dev/null | while IFS= read -r line; do
    mac=$(echo "$line" | awk '{print $2}')
    name=$(echo "$line" | cut -d' ' -f3-)
    if bluetoothctl info "$mac" 2>/dev/null | grep -q "Connected: yes"; then
        echo "$name (connected)" >> "$MENU_FILE"
    else
        echo "$name" >> "$MENU_FILE"
    fi
done

CHOICE=$(wofi --dmenu --prompt "Bluetooth Devices" -I < "$MENU_FILE")
rm -f "$MENU_FILE"

[ -z "$CHOICE" ] && exit 0

if [ "$CHOICE" = "Turn Bluetooth Off" ]; then
    bluetoothctl power off
    exit 0
fi

if [ "$CHOICE" = "Scan for New Devices" ]; then
    notify-send "Bluetooth" "Scanning for 10 seconds..."
    bluetoothctl --timeout 10 scan on >/dev/null 2>&1

    SCAN_FILE=$(mktemp)
    bluetoothctl devices 2>/dev/null | cut -d' ' -f3- >> "$SCAN_FILE"

    NEW_CHOICE=$(wofi --dmenu --prompt "Connect to" -I < "$SCAN_FILE")
    rm -f "$SCAN_FILE"
    [ -z "$NEW_CHOICE" ] && exit 0

    NEW_MAC=$(bluetoothctl devices 2>/dev/null | grep -F " $NEW_CHOICE" | awk '{print $2}' | head -1)
    [ -z "$NEW_MAC" ] && exit 0

    bluetoothctl pair "$NEW_MAC" >/dev/null 2>&1
    bluetoothctl trust "$NEW_MAC" >/dev/null 2>&1
    if bluetoothctl connect "$NEW_MAC" >/dev/null 2>&1; then
        notify-send "Bluetooth" "Connected to $NEW_CHOICE"
    else
        notify-send "Bluetooth" "Couldn't auto-connect to $NEW_CHOICE — may need blueman-manager for PIN confirmation" -u normal
    fi
    exit 0
fi

# Strip " (connected)" suffix to recover the real device name
DEVICE_NAME=$(echo "$CHOICE" | sed 's/ (connected)$//')
MAC=$(bluetoothctl devices Paired 2>/dev/null | grep -F " $DEVICE_NAME" | awk '{print $2}' | head -1)
[ -z "$MAC" ] && exit 0

if echo "$CHOICE" | grep -q " (connected)$"; then
    bluetoothctl disconnect "$MAC" >/dev/null 2>&1 && notify-send "Bluetooth" "Disconnected from $DEVICE_NAME"
else
    if bluetoothctl connect "$MAC" >/dev/null 2>&1; then
        notify-send "Bluetooth" "Connected to $DEVICE_NAME"
    else
        notify-send "Bluetooth" "Failed to connect to $DEVICE_NAME"
    fi
fi
