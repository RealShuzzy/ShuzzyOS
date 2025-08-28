sudo pacman -S --needed --noconfirm sddm qt5-base qt5-declarative qt5-quickcontrols2 qt5-wayland qt5-graphicaleffects qt5-svg > /dev/null
sudo systemctl enable sddm.service
sudo tee /etc/sddm.conf > /dev/null <<EOF
[Autologin] 
User=$USER
Session=Hyprland

[Theme]
Current=shuzzyOS
EOF

#Theme
sudo mkdir -p "/usr/share/sddm/themes/shuzzyOS"
sudo rsync -r ~/git/ShuzzyOS/themes/sddm/ /usr/share/sddm/themes/shuzzyOS/