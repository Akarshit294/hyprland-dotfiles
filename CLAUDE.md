# CLAUDE.md

This file is a guide for an AI agent that works in this repo.
`README.md` is the guide for people.

Last update: 5 Oct 2026.

## What this repo is

- This repo contains the config files of one Hyprland desktop on EndeavourOS.
- This repo is public.
- The user is the owner of this repo and of the laptop.

## The config files are live

`install.sh` made links from the home folder to this repo:

| Link | Target |
|---|---|
| `~/.config/hypr` | `config/hypr` |
| `~/.config/waybar` | `config/waybar` |
| `~/.config/wofi` | `config/wofi` |
| `~/.config/wlogout` | `config/wlogout` |
| `~/.config/mako` | `config/mako` |
| `~/.config/kitty` | `config/kitty` |
| `~/.config/fish` | `config/fish` |
| `~/.local/bin/wallpaper-toggle` | `bin/wallpaper-toggle` |

Each program reads its config file from this repo. A second copy does not exist.
A change to a file in `config/` changes the desktop of the user.

## Rules

1. Do not write private data into a file of this repo. Private data includes names, email addresses, passwords, tokens, and paths that contain a user name.
2. Change a file only when the user asks for that change.
3. When the user asks how to do a task, answer the question. Do not change files as part of the answer.
4. Commit only when the user asks. Push only when the user asks.
5. Do not delete a file before the user approves. First, show the user what you will delete.
6. Tell the user before you run a command that changes the screen or the sound.
7. Write each command for the user in fish syntax. Do not use heredocs. The user types commands in kitty with the fish shell.
8. Explain each part of a command before the user runs it.
9. Test each claim on the laptop before you write it. If you did not test a claim, say that.
10. Update `README.md` when you change a key bind, a package list, or a value that is specific to the laptop.

## How a change becomes active

| File | Action |
|---|---|
| `config/hypr/hyprland.lua` | None. Hyprland reads the file again when you save it. |
| `config/hypr/hyprlock.conf` | None. The lock screen reads the file each time it starts. |
| `config/hypr/hyprpaper.conf` | Restart `hyprpaper`. |
| `config/hypr/hypridle.conf` | Restart `hypridle`. |
| `config/waybar/config`, `config/waybar/style.css` | Restart the bar. See "The bar". |
| `config/kitty/kitty.conf` | Press Ctrl + Shift + F5 in kitty. |
| `config/fish/config.fish` | Open a new terminal. |
| `config/mako/config` | Run `makoctl reload`. |
| `config/wofi/*`, `config/wlogout/*` | None. Each program reads its files each time it starts. |

## How to check Hyprland

- `Hyprland --verify-config` checks `hyprland.lua`. The expected result is `config ok`.
- `hyprctl configerrors` prints the errors of the desktop. An empty result means zero errors.
- `hyprctl eval` applies a setting without a file change. `hyprctl reload` restores the settings from the config file.

  ```
  hyprctl eval 'hl.config({ decoration = { blur = { passes = 3 } } })'
  ```

- `hyprctl dispatch` takes Lua code.

  ```
  hyprctl dispatch 'hl.dsp.exec_cmd("waybar")'
  ```

- `/usr/share/hypr/stubs/hl.meta.lua` lists the Lua functions. A wrong argument name causes an error message that lists the valid names.

## The bar

The bar is `waybar`.

To restart the bar, run these two commands:

```
pkill waybar
hyprctl dispatch 'hl.dsp.exec_cmd("waybar")'
```

Do not send the signal `SIGUSR2` to the bar. On 4 Oct 2026 the bar crashed after that signal. The signal is the probable cause. Nobody repeated the crash to prove the cause.

The bar has four media modules: `mpris#prev`, `mpris#play`, `mpris#next`, and `mpris#title`.

- All four modules use the `mpris` module of `waybar`.
- A click on `mpris#title` runs `config/waybar/media-goto`. That script moves the focus to the window of the media player.
- `mpris#prev` and `mpris#next` have no effect when the media player reports that it cannot change the track. A page with one YouTube video reports that.
- Brave can appear as two media players for one video. This occurs when the KDE browser add-on is in Brave. The title in the bar then changes between two forms.

## How to add a command

1. Write the script as a file in `bin/`.
2. Run `chmod +x bin/NAME`.
3. Run `ln -s ~/dotfiles/bin/NAME ~/.local/bin/NAME`.
4. Add a `link` line for the script to `install.sh`. `install.sh` contains a `link` line only for `wallpaper-toggle`.

A script cannot change the folder of the terminal that starts it. For that task, add an `alias` line to `config/fish/config.fish`. That file contains an example: `alias D: "cd /mnt/d"`.

## Known problems

| Problem | Status |
|---|---|
| The password prompt does not appear. | The program `hyprpolkitagent` shows the prompt. After the user ends a session and starts a new session, the program can have the status `failed`. To repair one session, run `systemctl --user reset-failed hyprpolkitagent`. Then run `systemctl --user start hyprpolkitagent`. |
| The autostart line for `hyprpolkitagent` contains only `start`. | The proposed change adds `reset-failed` before `start`. Nobody tested the proposed change. |
| A program asks for the KDE Wallet password one time in each session. | Hyprland does not open the wallet when a session starts. The proposed change adds `hl.exec_cmd("/usr/lib/pam_kwallet_init")` to the autostart block. Nobody tested the proposed change. |
| The install steps in `README.md` have one test only. | Nobody ran the install steps on a second computer. |

## Facts that prevent errors

- The font name is `FiraCode Nerd Font`. The name `Fira Code` selects a different font and gives no error.
- `hyprpaper` 0.8 uses `wallpaper { ... }` blocks in its config file.
- `hyprctl hyprpaper listactive` prints the active wallpaper. `hyprctl hyprpaper wallpaper ", /path/to/picture"` changes the wallpaper.
- A window rule with `opacity` fades the full window. The text in the window fades too.
- `hyprctl setcursor` also changes the cursor setting of GTK.
- fish is not the login shell. kitty starts fish because of the line `shell fish` in `kitty.conf`.
- fish uses vi key binds. Write a new bind inside the function `fish_user_key_bindings`. Use `-M insert` for the typing mode.
- The wallpaper picture is `~/.wallpapers/wallpaper.jpg`. The picture is not in this repo. Do not add the picture, because the user does not own it.

## Tested versions

| Program | Version |
|---|---|
| Hyprland | 0.56.2 |
| waybar | 0.15.0 |
| hyprpaper | 0.8.4 |
| hypridle | 0.1.8 |
| hyprlock | 0.9.6 |
| mako | 1.11.0 |
| wofi | 1.5.3 |
| wlogout | 1.2.2 |
| kitty | 0.49.2 |
| fish | 4.9.3 |
