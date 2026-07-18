#!/bin/bash
# Browse clipboard history (cliphist) and paste a selected entry back onto
# the clipboard. Works regardless of whether quickshell or waybar is active.
cliphist list | wofi --dmenu --prompt "Clipboard" -I | cliphist decode | wl-copy
