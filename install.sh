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
if ! grep -q '^\[multilib\]' /etc/pacman.conf; then
    echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
else
    sed -i '/^\[multilib\]/,/^Include = \/etc\/pacman.d\/mirrorlist/ s/^#//' /etc/pacman.conf
fi

# Needed installs
sudo pacman -Syu --needed --noconfirm > /dev/null
sudo pacman -S --needed --noconfirm hyprland > /dev/null
sudo pacman -S --needed --noconfirm git > /dev/null

# Cloning GitHub Repository.
git clone https://github.com/RealShuzzy/ShuzzyOS.git ~/.ShuzzyOS

# Seperate choices into arrays
read -r -a pkg_array <<< "$choices_packages"
read -r -a driver_array <<< "$choices_drivers"

# Add drivers to choice
for driver in "${driver_array[@]}"; do
    [[ "$driver" == "pipewire" ]] && driver_array+=("pipewire-alsa" "pipewire-jack" "pipewire-pulse" "wireplumber")
    [[ "$driver" == "nvidia" ]] && driver_array+=("nvidia-utils" "nvidia-settings")
    [[ "$driver" == "amd" ]] && driver_array+=("xf86-video-amdgpu" "linux-firmware" "mesa" "vulkan-radeon")
    [[ "$driver" == "vmware" ]] && driver_array+=("xf86-video-amdgpu" "linux-firmware" "mesa" "vulkan-radeon")
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
    sudo pacman -S --needed --noconfirm "$pkg" > /dev/null
done

for driver in "${driver_array[@]}"; do
    sudo pacman -S --needed --noconfirm "$driver" > /dev/null
done

#--------------------------------------------
#Editing Configs
sudo mkdir ~.config2
sudo cp -rf ~/.ShuzzyOS/assets/ ~/.config2/

#getmonitors
monitors=""

while IFS= read -r line; do
    if [[ $line =~ ^Monitor[[:space:]]+([A-Za-z0-9+]) ]]; then
        name="${BASH_REMATCH[1]}"
    elif [[ $line =~ ^[[:space:]]*([0-9]+x[0-9]+)@ ]]; then
        size="${BASH_REMATCH[1]}"
    elif [[ $line =~ ^[[:space:]]*Position:[[:space:]]*([0-9]+x[0-9]+) ]]; then
        offset="${BASH_REMATCH[1]}"
        monitors+="monitor = ${name},${size},${offset},1.0"
    fi
done < <(hyprctl monitors)
#
for monitor in "${monitors[@]}"; do
    echo $monitor >> ~/.config2/hypr/test.conf
done

#--------------------EXIT------------------
kill $KEEPALIVE_PID
#-------------------------------------------