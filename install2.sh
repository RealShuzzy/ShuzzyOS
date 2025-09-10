#!/bin/bash

programs="gnu-free-fonts hyprland git rsync go grub sddm kitty nvim thunar zsh waybar fastfetch swww firefox pipewire pipewire-jack pipewire-alsa pipewire-pulse wireplumber xdg-user-dirs jq wofi"
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
LOGFILE=~/logfile.log
exec 3>&1
{
  echo 5
  sudo pacman -Syu --needed --noconfirm >>"$LOGFILE" 2>&1
  echo 10
  sudo pacman -S --needed --noconfirm $graphic $programs >>"$LOGFILE" 2>&1
  echo 25
  [[ $graphic != "open-vm-tools" ]] && sudo pacman -S $programs_electron >>"$LOGFILE" 2>&1
  echo 30
  mkdir -p ~/documents ~/downloads ~/git ~/music ~/pictures/wallpaper ~/videos >>"$LOGFILE" 2>&1
  echo 35
  git clone --recurse-submodules --depth=1 https://github.com/RealShuzzy/ShuzzyOS.git ~/git/ShuzzyOS >>"$LOGFILE" 2>&1
  echo 40
  rsync -r ~/git/ShuzzyOS/config/ ~/.config/ >>"$LOGFILE" 2>&1
  rsync ~/git/ShuzzyOS/assets/wallpaper.png ~/pictures/wallpaper/ >>"$LOGFILE" 2>&1
  sudo rsync -r ~/git/ShuzzyOS/bin/ /bin/ >>"$LOGFILE" 2>&1
  xdg-user-dirs-update >>"$LOGFILE" 2>&1
  echo 50
  source ~/git/ShuzzyOS/scripts/zsh.sh >>"$LOGFILE" 2>&1
  echo 53
  source ~/git/ShuzzyOS/scripts/font.sh >>"$LOGFILE" 2>&1
  echo 56
  source ~/git/ShuzzyOS/scripts/grub.sh >>"$LOGFILE" 2>&1
  echo 60
  source ~/git/ShuzzyOS/scripts/sddm.sh >>"$LOGFILE" 2>&1
  echo 65
  source ~/git/ShuzzyOS/scripts/yay.sh >>"$LOGFILE" 2>&1
  echo 85
  source ~/git/ShuzzyOS/scripts/wlogout.sh >>"$LOGFILE" 2>&1
  echo 90
  source ~/git/ShuzzyOS/scripts/swaylock.sh >>"$LOGFILE" 2>&1
  echo 95
  if [[ $graphic != "open-vm-tools" ]]; then
    source ~/git/ShuzzyOS/scripts/vscode.sh >>"$LOGFILE" 2>&1
  else
    source ~/git/ShuzzyOS/scripts/vm-update.sh >>"$LOGFILE" 2>&1
  fi
  echo 100
} | dialog --gauge "Installing ShuzzyOS" 6 100

echo done