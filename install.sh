#!/bin/sh
# Puts this setup in place by linking, not copying:
#
#     ~/.config/hypr  ->  <this folder>/config/hypr     (the same for each folder in config/)
#
# so a change made in ~/.config is a change in this repo.
# Whatever was there before is kept, renamed with ".bak-<date>" at the end.
# It installs no packages and never uses sudo. The packages are in README.md.

set -eu

repo=$(cd "$(dirname "$0")" && pwd)
stamp=$(date +%Y%m%d-%H%M%S)

# link <thing in this repo> <place where it should appear>
link() {
    src=$1
    dest=$2

    if [ "$(readlink "$dest" 2>/dev/null)" = "$src" ]; then
        echo "already linked:  $dest"
        return
    fi

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        mv "$dest" "$dest.bak-$stamp"
        echo "kept the old one: $dest.bak-$stamp"
    fi

    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
    echo "linked:          $dest -> $src"
}

for dir in "$repo"/config/*/; do
    name=$(basename "$dir")
    link "$repo/config/$name" "$HOME/.config/$name"
done

link "$repo/bin/wallpaper-toggle" "$HOME/.local/bin/wallpaper-toggle"

# The wallpaper folder is a real folder, not a link: your own picture goes in it.
mkdir -p "$HOME/.wallpapers"
if [ ! -e "$HOME/.wallpapers/black.png" ]; then
    cp "$repo/wallpapers/black.png" "$HOME/.wallpapers/black.png"
fi

echo
if [ ! -e "$HOME/.wallpapers/wallpaper.jpg" ]; then
    echo "No wallpaper yet. Put a picture at ~/.wallpapers/wallpaper.jpg"
fi
echo "Done. If Hyprland is running now, run:  hyprctl reload"
