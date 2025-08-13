#!/bin/bash
swww img ~/pictures/wallpaper/wallpaper.png

for mon in $(hyprctl monitors | grep "Monitor" | awk '{print $2}'); do
    echo "monitor = $mon,preferred,auto,1.0" >> ~/.config/hypr/monitor.conf
done

rsync ~/.ShuzzyOS/assets/hyprland.conf ~/.config/hypr/hyprland.conf