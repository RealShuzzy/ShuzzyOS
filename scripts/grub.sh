sudo pacman -S --needed --noconfirm grub efibootmgr os-prober > /dev/null
sudo grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
sudo grub-mkconfig -o /boot/grub/grub.cfg