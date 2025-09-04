#!/bin/bash

# Functions
cancel_install()
{
    clear
    echo "The installation of ShuzzyOS was cancelled."
    exit 0
}

#--------------------START------------------
sudo -v

# Check if Distro is arch-based
if ! grep -qi arch /etc/os-release 2>/dev/null; then
    clear
    echo "This installer is only available for arch-based systems."
    exit 0
fi

# Check if Dialog is installed / Installs if necessary
if ! command -v dialog &>/dev/null; then
    echo "Dialog is not installed... installing"
    sudo pacman -S --needed --noconfirm dialog
fi
#-------------------------------------------

# Launch installer
dialog --title "ShuzzyOS" --yesno "Welcome to the ShuzzyOS installer for Archlinux.\n  Would you like to continue with the install?" 6 52
response=$?

[ "$response" -eq 1 ] && cancel_install

# Select packages
choices_packages=$(dialog --stdout --checklist "Additional programs." 18 50 5 \
  code "Visual Studio Code" off \
  discord "Internet Messenger" off)

response=$?

[ "$response" -eq 1 ] && cancel_install

# Select drivers
choices_drivers=$(dialog --stdout --checklist "Graphic drivers." 12 50 5 \
  nvidia "NVIDIA graphic drivers" off \
  amd "AMD graphic drivers" off \
  open-vm-tools "Graphic drivers for virtual machines" off)

response=$?

[ "$response" -eq 1 ] && cancel_install
    
clear
#------------------------------------------

# Needed installs
sudo pacman -Syu --needed --noconfirm 
sudo pacman -S --needed --noconfirm rsync git hyprland go grub sddm kitty thunar zsh waybar fastfetch swww firefox pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber nvim xdg-users-dirs

# Creating directory structure
mkdir -p ~/documents ~/downloads ~/git ~/music ~/pictures ~/videos

# Cloning GitHub Repository.
git clone --recurse-submodules --depth=1 https://github.com/RealShuzzy/ShuzzyOS.git ~/git/ShuzzyOS

# Seperate choices into arrays
read -r -a pkg_array <<< "$choices_packages"
read -r -a driver_array <<< "$choices_drivers"

# Add drivers to choice
for driver in "${driver_array[@]}"; do
    [[ "$driver" == "nvidia" ]] && driver_array+=("nvidia-utils" "nvidia-settings")
    [[ "$driver" == "amd" ]] && driver_array+=("xf86-video-amdgpu" "linux-firmware" "mesa" "vulkan-radeon")
    [[ "$driver" == "open-vm-tools" ]] && $vm=true
done

# Filter out "amd" since its not a package
filtered=()
for elem in "${driver_array[@]}"; do
  if [[ "$elem" != "amd" ]]; then
    filtered+=("$elem")
  fi
done
driver_array=("${filtered[@]}")

#-------------------------------------------

# Selected installs
for pkg in "${pkg_array[@]}"; do
    sudo pacman -S --needed --noconfirm "$pkg" 
done

for driver in "${driver_array[@]}"; do
    sudo pacman -S --needed --noconfirm "$driver" 
done

#--------------------------------------------
# Editing Configs
rsync -r ~/git/ShuzzyOS/config/ ~/.config/
mkdir -p ~/pictures/wallpaper
rsync ~/git/ShuzzyOS/assets/wallpaper.png ~/pictures/wallpaper/
sudo rsync -r ~/git/ShuzzyOS/bin/ /bin/

# Update paths
xdg-user-dirs-update

# z-shell
source ~/git/ShuzzyOS/scripts/zsh.sh

# font
source ~/git/ShuzzyOS/scripts/font.sh

# bootloader
source ~/git/ShuzzyOS/scripts/grub.sh

# sddm
source ~/git/ShuzzyOS/scripts/sddm.sh

# yay
source ~/git/ShuzzyOS/scripts/yay.sh

# wlogout
source ~/git/ShuzzyOS/scripts/wlogout.sh

# swaylock
source ~/git/ShuzzyOS/scripts/swaylock.sh

$vm && source ~/git/ShuzzyOS/scripts/vm-update.sh

#--------------------EXIT------------------
reboot