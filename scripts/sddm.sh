sudo pacman -S --needed --noconfirm sddm > /dev/null
sudo systemctl enable sddm.service
sudo tee /etc/sddm.conf > /dev/null <<EOF
[Autologin] 
User=$USER
Session=Hyprland
EOF