-- Hyprland config for this laptop (Acer Aspire Lite AL15-52H).
--
-- The look is Max Hu's, from the video "the most BEAUTIFUL desktop you'll ever see".
-- His file (dotfiles-old, commit 6b4cf61) was in Hyprland's old format.
-- This is the same values in today's Lua format, plus what a laptop needs.
--
-- Hyprland re-reads this file every time it is saved.
-- Wiki: https://wiki.hypr.land/


------------------
---- MONITORS ----
------------------

-- The laptop's own screen.
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = 1,
})

-- Any other screen I plug in: its best mode, placed automatically.
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local fileManager = "nemo"
local menu        = "wofi --show drun"


-------------------
---- AUTOSTART ----
-------------------

-- Started once, when Hyprland starts.
hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")                              -- wallpaper
    hl.exec_cmd("waybar")                                 -- top bar
    hl.exec_cmd("mako")                                   -- notifications
    hl.exec_cmd("hypridle")                               -- lock and sleep when idle
    hl.exec_cmd("nm-applet --indicator")                  -- Wi-Fi menu, in the bar's tray
    hl.exec_cmd("systemctl --user start hyprpolkitagent") -- the "enter your password" pop-up

    -- Low battery warning: a notification at 20% and again at 10%.
    -- Plasma has its own. Hyprland has none, so batsignal does it.
    -- "pidof batsignal ||" means: start it only if it is not running already.
    hl.exec_cmd("pidof batsignal || batsignal -w 20 -c 10 -d 0")

    -- Cursor (Hyprland passes this on to GTK apps too)
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 24")

    -- Theme for GTK apps such as Nemo
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme Arc-Dark")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme prefer-dark")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- KDE apps (KWrite, Dolphin, ...) take KDE's own theme, as they do in Plasma.
-- Without this they fall back to a plain light look.
hl.env("QT_QPA_PLATFORMTHEME", "kde")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 5,  -- between windows
        gaps_out = 10, -- between windows and the screen edge

        border_size = 2,

        col = {
            -- focused window: light grey to mid grey, at 45 degrees. Matches the grey stone wallpaper.
            -- (His, for the blue sea wallpaper: "rgba(67e8f9ee)", "rgba(4f46e5ee)", cyan to indigo.)
            active_border   = { colors = { "rgba(e5e5e5ee)", "rgba(737373ee)" }, angle = 45 },
            -- other windows: grey
            inactive_border = "rgba(595959aa)",
        },

        layout = "dwindle",

        allow_tearing = false,
    },

    decoration = {
        rounding = 10,

        -- What shows through see-through windows (kitty) gets blurred.
        -- More passes = more smeared. His value was 6, which hid the wallpaper completely.
        -- At 2 the stones show through clearly, at 3 they are softer. Fewer passes is lighter on the battery.
        -- This is for everything see-through: kitty, Nemo and the power menu.
        blur = {
            enabled = true,
            size    = 3,
            passes  = 3,
        },

        shadow = {
            enabled = false,
        },
    },

    animations = {
        enabled = true,
    },
})

-- His animation curve and speeds.
hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

hl.animation({ leaf = "windows",     enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,  bezier = "default" })

-- Dwindle: each new window splits the focused one in two.
hl.config({
    dwindle = {
        preserve_split = true, -- a split keeps its direction when windows are resized
    },
})

hl.config({
    misc = {
        -- No built-in Hyprland wallpaper or logo behind hyprpaper's.
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout = "us",

        follow_mouse = 1, -- the window under the cursor gets focus

        sensitivity = 0, -- -1.0 to 1.0, 0 means no change

        touchpad = {
            natural_scroll = true, -- the page follows the fingers, like Windows. false flips it.
            tap_to_click   = true,
        },
    },
})

-- Three fingers left or right: switch workspace.
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- the Windows key

-- His keys
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit()) -- log out, straight away, no question asked
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

-- Move focus with the arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Workspaces: Super + number goes there, Super + Shift + number sends the window there.
-- (He used "hyprsome" for this. That tool is only for two monitors.)
for i = 1, 10 do
    local key = i % 10 -- 10 is the 0 key
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scratchpad: a hidden workspace that slides over the current one
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Super + scroll: go through the workspaces that have windows
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Super + drag with the left button moves a window, with the right button resizes it
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop additions, not in the video --

-- Lock the screen
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))

-- Screenshots go to ~/Pictures/Screenshots and to the clipboard.
-- Print: drag to choose an area. Shift + Print: the whole screen.
local shot = 'f="$HOME/Pictures/Screenshots/$(date +%F_%H-%M-%S).png"; '
hl.bind("Print",         hl.dsp.exec_cmd(shot .. 'grim -g "$(slurp)" "$f" && wl-copy < "$f"'))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd(shot .. 'grim "$f" && wl-copy < "$f"'))

-- Volume and brightness keys. "locked" means they also work on the lock screen.
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Media keys
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Apps cannot maximize themselves. (His "nomaximizerequest" rule.)
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

-- Fixes dragging in some older (XWayland) apps. From Hyprland's own example config.
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- The file manager (Nemo) a little see-through, so the blurred wallpaper shows faintly.
-- This fades the whole window, text and icons too, so keep it mild.
-- 1.0 is solid. Much below 0.8 the text gets hard to read.
hl.window_rule({
    name  = "glass-files",
    match = { class = "nemo" },

    opacity = "0.82",
})

-- Blur the desktop behind the power menu (wlogout), so its buttons are easy to read.
hl.layer_rule({
    name  = "blur-power-menu",
    match = { namespace = "logout_dialog" },

    blur = true,
})
