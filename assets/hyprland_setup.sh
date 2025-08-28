#!/bin/bash
for mon in $(hyprctl monitors | grep "Monitor" | awk '{print $2}'); do
    echo "monitor = $mon,preferred,auto,1.0" >> ~/.config/hypr/monitor.conf
done

rsync ~/git/ShuzzyOS/assets/hyprland.conf ~/.config/hypr/hyprland.conf