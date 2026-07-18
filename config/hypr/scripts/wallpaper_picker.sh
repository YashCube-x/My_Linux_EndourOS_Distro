#!/bin/bash
# Pick a wallpaper via wofi and switch to it. hyprpaper's IPC protocol
# (Hyprwire) isn't a simple CLI-scriptable command set in this version, so
# we rewrite the static config and restart the daemon instead — a brief
# flash, but reliable (confirmed working, unlike the IPC preload/wallpaper
# commands which just error with "invalid hyprpaper request").

WALLPAPER_DIR="$HOME/.config/hypr/wallpaper"
CONF="$HOME/.config/hypr/hyprpaper.conf"

CHOICE=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -printf "%f\n" | sort | wofi --dmenu --prompt "Wallpaper" -I)

[ -z "$CHOICE" ] && exit 0

sed -i "s#path = .*#path = $WALLPAPER_DIR/$CHOICE#" "$CONF"

pkill hyprpaper
sleep 0.3
hyprpaper &
disown

notify-send "Wallpaper" "Switched to $CHOICE"
