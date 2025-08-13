#swww wallpaper,get monitor config and maybe before get grum and sddm I guess
LIBGL_ALWAYS_SOFTWARE=1 kitty
echo "Setting up hyprland"

swww img ~/pictures/wallpaper/wallpaper.png

#getmonitors
monitors=""

while IFS= read -r line; do
    if [[ $line =~ ^Monitor[[:space:]]+([A-Za-z0-9+]) ]]; then
        name="${BASH_REMATCH[1]}"
    elif [[ $line =~ ^[[:space:]]*([0-9]+x[0-9]+)@ ]]; then
        size="${BASH_REMATCH[1]}"
    elif [[ $line =~ ^[[:space:]]*Position:[[:space:]]*([0-9]+x[0-9]+) ]]; then
        offset="${BASH_REMATCH[1]}"
        monitors+="monitor = ${name},${size},${offset},1.0"
    fi
done < <(hyprctl monitors)
#
for monitor in "${monitors[@]}"; do
    sudo echo $monitor >> ~/.config/hypr/test.conf
done

rsync ~/.ShuzzyOS/assets/hyprland.conf ~/.config/hypr/hyprland.conf