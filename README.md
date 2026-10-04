# hyprland-dotfiles

My Hyprland desktop on EndeavourOS: the config files, and a script that puts them in place.

The look started from [Max Hu's config](https://github.com/maxhu08/dotfiles-old) (commit `6b4cf61`),
shown in [his video](https://www.youtube.com/watch?v=XK7gal3Wrtk). His Hyprland file was in the old
format. Here it is rewritten in the Lua format, with the things a laptop needs added.

## What is in it

| Part | Program | Folder |
| --- | --- | --- |
| Desktop (window manager) | Hyprland | `config/hypr` |
| Wallpaper, idle rules, lock screen | hyprpaper, hypridle, hyprlock | `config/hypr` |
| Top bar | waybar | `config/waybar` |
| App launcher | wofi | `config/wofi` |
| Power menu | wlogout | `config/wlogout` |
| Notifications | mako | `config/mako` |
| Terminal and shell | kitty, fish | `config/kitty`, `config/fish` |
| `wallpaper-toggle` command | switches the wallpaper to black and back | `bin` |

Also set up in `config/hypr/hyprland.lua`: file manager (Nemo), low battery warning (batsignal),
Wi-Fi tray icon, screenshots, volume, brightness and media keys.

## Tested on

One laptop only.

| | |
| --- | --- |
| System | EndeavourOS, installed with the KDE Plasma desktop |
| Hyprland | 0.56.2 |
| waybar | 0.15.0 |
| Laptop | Acer Aspire Lite AL15-52H, Intel CPU, 1920x1080 screen |

It should work on other Arch-based systems, but I have not tried one.
`hyprland.lua` needs a Hyprland that reads Lua configs.

## Install

Read `install.sh` first. It is short. It only makes links and never uses `sudo`.

1. Packages from the official repos:

   ```
   sudo pacman -S --needed - < packages.txt
   ```

2. Two packages from the AUR. The AUR is run by users, so read each recipe before you build it:

   ```
   yay -S --needed - < packages-aur.txt
   ```

3. Link the configs into place:

   ```
   git clone https://github.com/Akarshit294/hyprland-dotfiles.git ~/dotfiles
   ~/dotfiles/install.sh
   ```

   Every folder in `config/` becomes a link in `~/.config`. If a folder of that name is already
   there, it is kept and renamed to `<name>.bak-<date>`.

4. Put a wallpaper at `~/.wallpapers/wallpaper.jpg`. No picture comes with this repo.

5. Log out. On the login screen choose the session named **Hyprland**.

## Change these for your machine

| File | Value | Why |
| --- | --- | --- |
| `config/waybar/config` | `"interface": "wlan0"` | The name of the Wi-Fi card. `ip link` shows yours. |
| `config/waybar/config` | `"hwmon-path-abs"` | Where the CPU temperature is read. This path is for Intel. |
| `config/hypr/hyprland.lua` | `eDP-1`, `1920x1080@60` | My screen. Any other screen uses the second monitor rule, so this often needs no change. |
| `config/hypr/hyprland.lua` | `QT_QPA_PLATFORMTHEME` = `kde` | KDE apps take the Plasma theme. Remove the line if Plasma is not installed. |
| `packages.txt` | `arc-gtk-theme-eos` | The EndeavourOS name. On plain Arch the package is `arc-gtk-theme`. |

Hibernate in the power menu only works on a machine that is set up to hibernate.

## Not in this repo

- Installing the system, dual boot, disks.
- The wallpaper picture.
- Apps such as the browser and the editor, and which app opens which file type.

## Keys

Super is the Windows key. All of these are in `config/hypr/hyprland.lua`.

| Keys | Action |
| --- | --- |
| Super + Q | Terminal |
| Super + R | App launcher |
| Super + E | Files |
| Super + C | Close the window |
| Super + F | Fullscreen |
| Super + V | Float the window |
| Super + J | Flip a split |
| Super + Arrow keys | Move focus |
| Super + 1 ... 0 | Go to workspace 1 ... 10 |
| Super + Shift + 1 ... 0 | Send the window to that workspace |
| Super + S | Show or hide the scratchpad |
| Super + Shift + S | Send the window to the scratchpad |
| Super + L | Lock |
| Super + M | Log out at once, no question asked |
| Print | Screenshot of an area |
| Shift + Print | Screenshot of the whole screen |
| Three fingers sideways | Switch workspace |

Screenshots go to `~/Pictures/Screenshots` and to the clipboard.

## The bar

Left to right: clock, workspaces, tray, media controls, window title, then Wi-Fi, temperature,
memory, CPU, volume, battery and the power menu.

The media controls show when something is playing: previous, play / pause, next, and the title.
A click on the title goes to the window that is playing.

After a change to the bar's config, restart the bar. Do not reload it with a signal: with the
media controls on, that crashed it for me.

```
pkill waybar
hyprctl dispatch 'hl.dsp.exec_cmd("waybar")'
```

## Credits

- [Max Hu](https://github.com/maxhu08/dotfiles-old): the look, and the original waybar, wofi, kitty and fish configs.
- Terminal colours: [Tokyo Night](https://github.com/enkia/tokyo-night-vscode-theme).
- Power menu icons: recoloured copies of the icons that come with wlogout.
