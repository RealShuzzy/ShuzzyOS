#!/bin/bash

programs="hyprland git rsync go grub sddm kitty nvim thunar zsh waybar fastfetch swww firefox pipewire pipewire-jack pipewire-alsa pipewire-pulse wireplumber xdg-user-dirs jq wofi"
programs_electron="code discord"
# Functions
cancel()
{
  sudo pacman -Rns --noconfirm dialog > /dev/null
  clear
  echo "The installation of ShuzzyOS was cancelled. No Changes were made to your system."
  exit 0
}

# Sudo verify
echo "ShuzzyOS installer - please verify once for the entire installation."
sudo -v

# Check if System is arch-based
if ! grep -qi arch /etc/os-release 2>/dev/null; then
  clear
  echo "ShuzzyOS is only available for arch-based systems. No changes were made to your system."
  exit 0
fi

# Install dialog if its not installed
if ! command -v dialog &>/dev/null; then
  sudo pacman -S --needed --noconfirm dialog > /dev/null
fi

### DIALOG START ###

# Welcome
dialog --title "ShuzzyOS" --yesno "Welcome to the ShuzzyOS installer for Archlinux." 5 52
response=$?
[ "$response" -eq 1 ] && cancel

# Select graphic driver
graphic=$(dialog --title "ShuzzyOS" --radiolist "Please select your graphic driver." 10 38 3 \
  "amd" "" on \
  "nvidia" "" off \
  "open-vm-tools" "" off 2>&1 >/dev/tty)
response=$?
[ "$response" -eq 1 ] && cancel

[[ $graphic == "amd" ]] && graphic="xf86-video-amdgpu vulkan-radeon"
[[ $graphic == "nvidia" ]] && graphic="nvidia nvidia-utils nvidia-settings"

# Confirm
dialog --title "ShuzzyOS" --yesno "All selections have been made.\nWould you like to continue with the installation?" 6 53
response=$?
[ "$response" -eq 1 ] && cancel

### DIALOG END ###

### INSTALLATION START ###

sudo pacman -Syu --needed --noconfirm > /dev/null
sudo pacman -S $graphic $programs > /dev/null
[[ $graphic != "open-vm-tools" ]] && sudo pacman -S $programs_electron > /dev/null

#-----Keep going! mkdir and clone and so on, all programs are installed!

### INSTALLATION END ###