#!/bin/bash

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

if [ $response -eq 1 ]; then
    clear
    echo "The installation of ShuzzyOS was cancelled."
    kill $KEEPALIVE_PID
    exit 0
fi

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

if [ $response -eq 1 ]; then
    clear
    echo "The installation of ShuzzyOS was cancelled."
    kill $KEEPALIVE_PID
    exit 0
fi

# Select drivers
choices_drivers=$(dialog --stdout --checklist "Select additional packages you wish to install." 12 50 5 \
    pipewire "Audio and Bluetooth" off \
    pavucontrol "Gui audio control" off \
    nvidia "NVIDIA graphic drivers" off \
    amd "AMD graphic drivers" off)

response=?

if [ $response -eq 1 ]; then
    clear
    echo "The installation of ShuzzyOS was cancelled."
    kill $KEEPALIVE_PID
    exit 0
fi

#------------------------------------------
clear
echo -e "You have selected:
    Packages: $choices_packages
    Drivers: $choices_drivers"
echo "Installing packages..."

#------------------------------------------

# Needed installs
sudo pacman -Syu --needed --noconfirm > /dev/null
sudo pacman -S --needed --noconfirm hyprland > /dev/null
sudo pacman -S --needed --noconfirm git > /dev/null

# Cloning GitHub Repository.



# Selected installs

#--------------------EXIT------------------
kill $KEEPALIVE_PID
#-------------------------------------------