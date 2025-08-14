sudo pacman -S --needed --noconfirm sddm qt5-base qt5-declarative qt5-quickcontrols2 qt5-wayland qt5-graphicaleffects > /dev/null
sudo systemctl enable sddm.service
sudo tee /etc/sddm.conf > /dev/null <<EOF
[Autologin] 
User=$USER
Session=Hyprland

[Theme]
Current=sddm_shuzzyOS
EOF

#Theme
sudo rsync -r ~/.ShuzzyOS/assets/sddm_shuzzyOS /usr/share/sddm/themes/