#!/usr/bin/env python3
"""Generates a keybind cheat-sheet from hyprland.lua and shows it via wofi.
Parsed dynamically (comments become section headers, every hl.bind() under
that comment gets its own line) so it never drifts out of sync as bindings
are added. The for-loop workspace binds are collapsed to one line each.
"""
import re
import subprocess
from pathlib import Path

CONFIG = Path.home() / ".config/hypr/hyprland.lua"

bind_re = re.compile(r'hl\.bind\(\s*(.+?)\s*,\s*hl\.dsp')
comment_re = re.compile(r'^\s*--\s*(.+)$')
loop_key_re = re.compile(r'mainMod \.\. " \+ " \.\. key')
loop_shift_key_re = re.compile(r'mainMod \.\. " \+ SHIFT \+ " \.\. key')


def format_key(expr):
    expr = expr.strip()
    if loop_shift_key_re.search(expr):
        return "SUPER + SHIFT + [0-9]"
    if loop_key_re.search(expr):
        return "SUPER + [0-9]"
    expr = expr.replace('mainMod .. " + ', "SUPER + ").replace('"', "")
    return expr


divider_re = re.compile(r'^-+$')


def main():
    lines = CONFIG.read_text().splitlines()
    out = []
    seen_loop_keys = set()
    in_keybindings = False

    for line in lines:
        cm = comment_re.match(line)
        if cm:
            text_c = cm.group(1).strip()
            if divider_re.match(text_c):
                continue
            if "KEYBINDINGS" in text_c:
                in_keybindings = True
                continue
            if "WINDOWS AND WORKSPACES" in text_c:
                break
            if in_keybindings:
                out.append(f"\n== {text_c} ==")
            continue

        if not in_keybindings:
            continue

        bm = bind_re.search(line)
        if bm:
            key = format_key(bm.group(1))
            if key in ("SUPER + [0-9]", "SUPER + SHIFT + [0-9]"):
                if key in seen_loop_keys:
                    continue
                seen_loop_keys.add(key)
            out.append(f"  {key}")

    text = "\n".join(l for l in out if l.strip())
    subprocess.run(
        ["wofi", "--dmenu", "--prompt", "Keybinds", "-I", "--width", "500", "--height", "700",
         "--allow-markup"],
        input=text,
        text=True,
    )


if __name__ == "__main__":
    main()
