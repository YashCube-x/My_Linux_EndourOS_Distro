# Hyprland dotfiles — calm-slate rice

A full Hyprland desktop setup for Arch/EndeavourOS: Hyprland (native Lua config) +
Waybar (with Quickshell as an on-demand alternate shell) + Kitty + Wofi + Mako +
Neovim + zsh/Starship, all on one consistent "calm slate" color palette.

## What's in here

| Path | What it is |
|---|---|
| `config/hypr/` | `hyprland.lua` (compositor config, 80+ keybinds, animations, blur, tiling controls), `hyprlock.conf`, `hyprpaper.conf`, `hypridle.conf` (auto lock/dim/suspend), `scripts/` (smart volume/brightness/menu/powermenu wrappers, wallpaper picker, keybind cheat-sheet, battery warning, screen-record toggle), `wallpaper/` (4 wallpapers, switch with `SUPER+W`) |
| `config/waybar/` | Bar config + calm-slate `style.css` + `scripts/` (volume/brightness sliders via `yad`, WiFi popup via `nmcli`+`wofi`, clipboard picker via `cliphist`, notification toggle) |
| `config/kitty/` | Terminal config, Catppuccin Mocha colors, JetBrains Mono Nerd Font |
| `config/wofi/` | App launcher styling |
| `config/mako/` | Notification daemon styling |
| `config/quickshell/` | Alternate native shell (QML) — control center, OSD, GPU switcher, clipboard manager. Toggle with `SUPER+SHIFT+Q` or the waybar power-menu's "battery mode" button. Adapted from [matteogini/dotfiles](https://github.com/matteogini/dotfiles). |
| `config/wlogout/` | Centered 4-option power menu (shutdown/restart/sleep/logout) |
| `config/wob/` | Volume/brightness OSD bar used when Quickshell isn't running |
| `config/swappy/` | Screenshot annotation (crop/draw/copy) — `Print`/`SUPER+Print` pipe `grim` into it |
| `config/nvim/` | Neovim config: `lazy.nvim`, LSP via `mason.nvim`, `nvim-cmp` autocomplete, `nvim-tree`, Catppuccin Mocha theme |
| `config/starship.toml` | Shell prompt |
| `zshrc` | `.zshrc` |
| `install.sh` | Installs every package below and symlinks everything into place |

Press `SUPER+H` any time for the full, always-current keybind cheat-sheet (generated live from `hyprland.lua`, not a static list that can drift).

## Prerequisite: a working Arch or EndeavourOS install

This assumes you already have a **base Linux system booted and logged in** —
this repo only configures the desktop on top of it, it doesn't install the OS
itself. Two ways to get there:

1. **EndeavourOS (recommended, easiest)** — download the ISO from
   [endeavouros.com](https://endeavouros.com/), flash it to a USB drive
   (e.g. with `dd` or [Rufus](https://rufus.ie/) on Windows), boot from it,
   and run through the graphical installer. Pick any desktop option (or
   "No Desktop"/terminal-only) — this repo replaces whatever DE/WM it sets
   up. EndeavourOS ships with `yay` (AUR helper) already installed, which
   this repo's `install.sh` needs.
2. **Plain Arch Linux** — follow the
   [Arch install guide](https://wiki.archlinux.org/title/Installation_guide),
   then install an AUR helper yourself before continuing:
   ```bash
   sudo pacman -S --needed base-devel git
   git clone https://aur.archlinux.org/yay.git
   cd yay && makepkg -si
   ```

Once you can log in and reach a terminal (with internet working), continue below.

## Bootstrapping on a fresh machine

```bash
git clone https://github.com/YashCube-x/My_Linux_EndourOS_Distro.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

That's it — `install.sh` installs every package this setup needs and symlinks
all the configs into place automatically. Reboot (or log out and back in)
once it finishes.

The script:
1. Installs all official-repo packages via `pacman`.
2. Installs AUR packages (`supergfxctl`, `wlogout`, `catppuccin-gtk-theme-mocha`, `catppuccin-cursors-mocha`) via `yay` — **install `yay` first** if it's not already on the machine.
3. Symlinks each config directory from `~/dotfiles/config/` into `~/.config/`, moving anything already there into a timestamped `~/.config-backup-.../` first (never deletes).
4. Enables the `bluetooth` and `supergfxd` system services.
5. Sets `zsh` as the login shell if it isn't already.

Because configs are **symlinked**, editing a file under `~/.config/...` after install is the same as editing it in `~/dotfiles/config/...` — commit from either place.

## Known limitations / before reusing on a different machine or username

- Four files hardcode the absolute path `/home/suyash/...`: `config/hypr/hyprpaper.conf` and three `config/quickshell/*.qml` files (`AppLauncher.qml`, `ThemeSwitcher.qml`, `shell.qml`). If you ever restore this under a **different username**, run:
  ```bash
  grep -rl '/home/suyash' ~/dotfiles/config | xargs sed -i 's#/home/suyash#'"$HOME"'#g'
  ```
  before symlinking.
- `hyprpaper.conf` targets a specific monitor name (`eDP-1`). On different hardware, check `hyprctl monitors` and adjust.
- Neovim plugins (via `lazy.nvim`) aren't vendored here — they install automatically the first time you launch `nvim` (needs internet).
- Bluetooth requires the `bluetooth` service (handled by `install.sh`); the GPU switcher needs `supergfxd` (also handled) **and** actual hybrid Intel/Nvidia graphics to do anything useful.
- GTK apps (Thunar, blueman-manager, yad, pavucontrol) use Catppuccin Mocha (blue accent) + Papirus-Dark icons + matching cursor, applied via `gsettings` (handled by `install.sh`). This isn't pixel-matched to the custom calm-slate hex palette used in the bar/launcher/lock-screen/power-menu, but it's dark and cohesive rather than the jarring default light GTK theme. Quickshell isn't affected either way — it draws its own UI directly in QML, not via system GTK/Qt theming.

## Package list

**Official repo:** `hyprland hyprlock hyprpaper hyprpolkitagent hypridle waybar wofi mako kitty neovim zsh starship ttf-jetbrains-mono-nerd thunar thunar-volman gvfs grim slurp swappy wf-recorder brightnessctl playerctl wob cliphist wl-clipboard blueman bluez bluez-utils quickshell jq socat yad networkmanager pavucontrol papirus-icon-theme mpv imv`

`mimeapps.list` sets `mpv` as the default handler for common video formats and `imv` for images (both lightweight, Wayland-native, keyboard-driven — matches the rest of the toolchain).

**AUR:** `supergfxctl wlogout catppuccin-gtk-theme-mocha catppuccin-cursors-mocha`
