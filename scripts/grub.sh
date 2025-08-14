$EFI_DIR = "/boot"
sudo pacman -S --needed --noconfirm grub efibootmgr os-prober > /dev/null
sudo grub-install --target=x86_64-efi --efi-directory="$EFI_DIR" --bootloader-id=GRUB
sudo grub-mkconfig -o /boot/grub/grub.cfg