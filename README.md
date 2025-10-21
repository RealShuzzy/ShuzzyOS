# 💧 ShuzzyOS
!["Preview of ShuzzyOS"](assets/preview.png)

## Features 
### Core System 
🔧 Grub  
💧 Hyprland  
🔒 Sddm  
🔒 Swaylock  
⚙ Waybar  
⚙ Wlogout  
### Applications 
🗨 Discord  
✏ Neovim  
✏ Visual Studio Code  
📁 Thunar  
▶ Kitty  
▶ Wofi  
### Package Management 
📦 Pacman  
📦 Yay   
### Drivers 
🔊 Pipewire  

## Install
### Automated
Run this command to start the installer:
```
bash <(curl -sL https://raw.githubusercontent.com/RealShuzzy/ShuzzyOS/main/install.sh)
```
### Manual
Clone the GitHub Repository and start the script:

This script creates folder structures, so its recommended to clone the repo under `~/git` with the original name. 
```
mkdir -p ~/git
git clone https://github.com/RealShuzzy/ShuzzyOS.git ~/git/ShuzzyOS/
bash ~/git/ShuzzyOS/install.sh
```

# Getting the ISO
There are two ways of obtaining the ISO for ShuzzyOS. 
Either download it from the official website, or build it on your own.
## Download
To download the ISO go to the official website of [ShuzzyOS][https://shuzzy.duckdns.org/download]
Select the ISO of your choice, the latest is recommended.

## Build
Alternatively you can build the ISO yourself. (This requires an Arch-based system.)
### Packages
```
sudo pacman -S archiso
```

### Git Repository
This holds all the data to build and modify the iso, alongside all the dotfiles.
```
git clone https://github.com/RealShuzzy/ShuzzyOS.git
```


