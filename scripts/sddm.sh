sudo pacman -S --needed --noconfirm sddm > /dev/null
sudo systemctl enable sddm.service
sudo tee /etc/sddm.conf > /dev/null <<EOF
[Autologin] 
User=$USER
Session=Hyprland
EOF

#Theme
sudo rsync -r ~/.ShuzzyOS/assets/sddm_shuzzyOS /usr/share/sddm/themes/