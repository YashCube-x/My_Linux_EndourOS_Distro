#!/bin/bash
# Toggle between Waybar (default) and Quickshell (native OSD/menus, GPU
# switcher control center). Doesn't touch decoration/animation settings —
# those are just whatever hyprland.lua's base config says, independent of
# which bar happens to be running. wob is autostarted at session start and
# stays running whenever quickshell isn't (see hyprland.lua).

if pgrep -x quickshell >/dev/null; then
    echo "Switching to waybar..."
    touch "$XDG_RUNTIME_DIR/quickshell_supervisor_stop"
    pkill quickshell

    waybar &
    disown
else
    echo "Switching to quickshell..."
    pkill waybar 2>/dev/null
    pkill wob 2>/dev/null

    ~/.config/quickshell/supervisor.sh &
    disown
fi
