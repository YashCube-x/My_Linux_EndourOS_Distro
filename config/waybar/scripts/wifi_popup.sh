#!/bin/bash
# WiFi scan + connect popup using nmcli + wofi.

IFACE=$(nmcli -t -f DEVICE,TYPE device | awk -F: '$2=="wifi"{print $1; exit}')
RADIO_STATE=$(nmcli radio wifi)

if [ "$RADIO_STATE" != "enabled" ]; then
    CHOICE=$(echo "Turn WiFi On" | wofi --dmenu --prompt "WiFi" -I)
    [ "$CHOICE" = "Turn WiFi On" ] && nmcli radio wifi on
    exit 0
fi

nmcli device wifi rescan ifname "$IFACE" >/dev/null 2>&1
sleep 1.5

CURRENT_SSID=$(nmcli -t -f active,ssid dev wifi | awk -F: '$1=="yes"{print $2; exit}')

MENU_FILE=$(mktemp)
echo "Turn WiFi Off" >> "$MENU_FILE"

nmcli -t -f SSID,SIGNAL,SECURITY device wifi list ifname "$IFACE" 2>/dev/null \
    | awk -F: '$1!=""' \
    | sort -t: -k2 -rn \
    | awk -F: '!seen[$1]++' \
    | while IFS=: read -r ssid signal security; do
        label="$ssid  ${signal}%"
        [ -n "$security" ] && label="$label [secured]"
        [ "$ssid" = "$CURRENT_SSID" ] && label="$label (connected)"
        echo "$label" >> "$MENU_FILE"
    done

CHOICE=$(wofi --dmenu --prompt "WiFi Networks" -I < "$MENU_FILE")
rm -f "$MENU_FILE"

[ -z "$CHOICE" ] && exit 0
[ "$CHOICE" = "Turn WiFi Off" ] && { nmcli radio wifi off; exit 0; }

# Strip trailing "  NN% [secured] (connected)" annotations to recover the SSID
SSID=$(echo "$CHOICE" | sed -E 's/  [0-9]+%.*$//')

if [ "$SSID" = "$CURRENT_SSID" ]; then
    notify-send "WiFi" "Already connected to $SSID"
    exit 0
fi

if nmcli -t -f NAME connection show | grep -qxF "$SSID"; then
    nmcli connection up id "$SSID" \
        && notify-send "WiFi" "Connected to $SSID" \
        || notify-send "WiFi" "Failed to connect to $SSID"
    exit 0
fi

SECURED=$(nmcli -t -f SSID,SECURITY device wifi list ifname "$IFACE" | awk -F: -v s="$SSID" '$1==s{print $2; exit}')

if [ -n "$SECURED" ]; then
    PASS=$(wofi --dmenu --prompt "Password for $SSID" -P -I)
    [ -z "$PASS" ] && exit 0
    nmcli device wifi connect "$SSID" password "$PASS" ifname "$IFACE" \
        && notify-send "WiFi" "Connected to $SSID" \
        || notify-send "WiFi" "Failed to connect to $SSID"
else
    nmcli device wifi connect "$SSID" ifname "$IFACE" \
        && notify-send "WiFi" "Connected to $SSID" \
        || notify-send "WiFi" "Failed to connect to $SSID"
fi
