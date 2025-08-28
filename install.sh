#!/bin/bash

# Functions
cancel_install()
{
    clear
    echo "The installation of ShuzzyOS was cancelled."
    kill $KEEPALIVE_PID
    exit 0
}

#--------------------START------------------
sudo -v
while true; do sudo -v; sleep 60; done &
KEEPALIVE_PID=$!

# Check if Distro is arch-based
if ! grep -qi arch /etc/os-release 2>/dev/null; then
    clear
    echo "This installer is only available for arch-based systems."
    kill $KEEPALIVE_PID
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
choices_packages=$(dialog --stdout --checklist "Select packages you wish to install." 18 50 5 \
    grub "Bootloader" on \
    sddm "Display manager" on \
    kitty "Terminal" on \
    thunar "File Manager" on \
    zsh "Z-Shell + p10k-Theme" on \
    waybar "Wayland status bar" on \
    fastfetch "Display system info" on \
    swww "Wallpaper manager" on \
    firefox "Firefox internet browser" on \
    code "Visual Studio Code" off \
    discord "Internet Messenger" off)

response=$?

[ "$response" -eq 1 ] && cancel_install

# Select drivers
choices_drivers=$(dialog --stdout --checklist "Select additional packages you wish to install." 12 50 5 \
    pipewire "Audio and Bluetooth" off \
    pavucontrol "Gui audio control" off \
    nvidia "NVIDIA graphic drivers" off \
    amd "AMD graphic drivers" off \
    vmware "VMware graphic drivers" off)

response=$?

[ "$response" -eq 1 ] && cancel_install
    
clear
#------------------------------------------

# Check if multilib is enabled
if ! sudo grep -q '^\[multilib\]' /etc/pacman.conf; then
    sudo echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
else
    sudo sed -i '/^\[multilib\]/,/^Include = \/etc\/pacman.d\/mirrorlist/ s/^#//' /etc/pacman.conf
fi

# Needed installs
sudo pacman -Syu --needed --noconfirm 
sudo pacman -S --needed --noconfirm rsync git hyprland 

# Creating directory structure
mkdir -p ~/git

# Cloning GitHub Repository.
git clone --recurse-submodules --depth=1 https://github.com/RealShuzzy/ShuzzyOS.git ~/git/ShuzzyOS

# Seperate choices into arrays
read -r -a pkg_array <<< "$choices_packages"
read -r -a driver_array <<< "$choices_drivers"

# Add drivers to choice
for driver in "${driver_array[@]}"; do
    [[ "$driver" == "pipewire" ]] && driver_array+=("pipewire-alsa" "pipewire-jack" "pipewire-pulse" "wireplumber")
    [[ "$driver" == "nvidia" ]] && driver_array+=("nvidia-utils" "nvidia-settings")
    [[ "$driver" == "amd" ]] && driver_array+=("xf86-video-amdgpu" "linux-firmware" "mesa" "vulkan-radeon")
    [[ "$driver" == "vmware" ]] && driver_array+=() # vmware graphic drivers
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
#Editing Configs
rsync -r ~/git/ShuzzyOS/config/ ~/.config/
mkdir -p ~/pictures/wallpaper
rsync ~/git/ShuzzyOS/assets/wallpaper.png ~/pictures/wallpaper/


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

#--------------------EXIT------------------
reboot