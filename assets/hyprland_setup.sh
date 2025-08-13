#!/bin/bash
swww img ~/pictures/wallpaper/wallpaper.png

monitors=()

while IFS= read -r line; do
    if [[ $line =~ ^Monitor[[:space:]]+([A-Za-z0-9\+\-]+) ]]; then
        name="${BASH_REMATCH[1]}"
    elif [[ $line =~ ^[[:space:]]*([0-9]+x[0-9]+)@ ]]; then
        size="${BASH_REMATCH[1]}"
    elif [[ $line =~ ^[[:space:]]*Position:[[:space:]]*([0-9]+x[0-9]+) ]]; then
        offset="${BASH_REMATCH[1]}"
        monitors+=("monitor = ${name},${size},${offset},1.0")
    fi
done < <(hyprctl monitors)

# Write to the config file
for monitor in "${monitors[@]}"; do
    echo "$monitor" >> ~/.config/hypr/test.conf
done

LIBGL_ALWAYS_SOFTWARE=1 kitty


rsync ~/.ShuzzyOS/assets/hyprland.conf ~/.config/hypr/hyprland.conf