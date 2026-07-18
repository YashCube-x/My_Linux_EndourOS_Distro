# Hyprland dotfiles — calm-slate rice

A full Hyprland desktop setup for Arch/EndeavourOS: Hyprland (native Lua config) +
Waybar (with Quickshell as an on-demand alternate shell) + Kitty + Wofi + Mako +
Neovim + zsh/Starship, all on one consistent "calm slate" color palette.

## What's in here

| Path | What it is |
|---|---|
| `config/hypr/` | `hyprland.lua` (compositor config, keybinds, animations, blur), `hyprlock.conf`, `hyprpaper.conf`, `scripts/` (smart volume/brightness/menu/powermenu wrappers), `wallpaper/` |
| `config/waybar/` | Bar config + calm-slate `style.css` + `scripts/` (volume/brightness sliders via `yad`, WiFi popup via `nmcli`+`wofi`, notification toggle) |
| `config/kitty/` | Terminal config, Catppuccin Mocha colors, JetBrains Mono Nerd Font |
| `config/wofi/` | App launcher styling |
| `config/mako/` | Notification daemon styling |
| `config/quickshell/` | Alternate native shell (QML) — control center, OSD, GPU switcher, clipboard manager. Toggle with `SUPER+SHIFT+Q` or the waybar power-menu's "battery mode" button. Adapted from [matteogini/dotfiles](https://github.com/matteogini/dotfiles). |
| `config/wlogout/` | Centered 4-option power menu (shutdown/restart/sleep/logout) |
| `config/wob/` | Volume/brightness OSD bar used when Quickshell isn't running |
| `config/nvim/` | Neovim config: `lazy.nvim`, LSP via `mason.nvim`, `nvim-cmp` autocomplete, `nvim-tree`, Catppuccin Mocha theme |
| `config/starship.toml` | Shell prompt |
| `zshrc` | `.zshrc` |
| `install.sh` | Installs every package below and symlinks everything into place |

## Bootstrapping on a fresh machine

```bash
git clone <this-repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

The script:
1. Installs all official-repo packages via `pacman`.
2. Installs AUR packages (`supergfxctl`, `wlogout`) via `yay` — **install `yay` first** if it's not already on the machine.
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
- `blueman-manager` and default `yad` dialogs use the system GTK theme, not the calm-slate palette — only the bar/launcher/lock-screen/power-menu are custom-themed.

## Package list

**Official repo:** `hyprland hyprlock hyprpaper hyprpolkitagent waybar wofi mako kitty neovim zsh starship ttf-jetbrains-mono-nerd thunar thunar-volman gvfs grim slurp brightnessctl playerctl wob cliphist wl-clipboard blueman bluez bluez-utils quickshell jq socat yad networkmanager pavucontrol`

**AUR:** `supergfxctl wlogout`
