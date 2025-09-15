sudo pacman -S --needed --noconfirm efibootmgr os-prober
sudo grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

git clone https://github.com/dracula/grub.git ~/git/dracula-grub
sudo rsync -r ~/git/dracula-grub/dracula /boot/grub/themes/
sudo rsync ~/git/ShuzzyOS/assets/grub /etc/default/grub

sudo grub-mkconfig -o /boot/grub/grub.cfg