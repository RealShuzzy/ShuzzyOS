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

## 💿 Getting the ISO

There are two ways to obtain the ISO for **ShuzzyOS**:  
You can either **download it from the official website**, or **build it yourself**.

---

### 📥 Download

To download the ISO, head over to the official [ShuzzyOS Download Page](https://shuzzy.duckdns.org/download).

From there, select the ISO of your choice — the **latest version** is recommended for most users.

---

### 🛠️ Build It Yourself

Alternatively, you can build the ISO manually.  
> ⚠️ **Note:** This requires an **Arch-based system**.

#### 1. 📦 Install Required Packages

ShuzzyOS uses the official `archiso` package to build the custom ISO:

```bash
sudo pacman -S archiso
```
#### 2. 📁 Clone the Git Repository

The repository contains everything you need to build, modify, and configure the ISO — including all relevant dotfiles.

```bash
git clone https://github.com/RealShuzzy/ShuzzyOS.git
```

#### 3. 🔨 Build the ISO

Run the following commands to build the ISO:

```bash
cd ShuzzyOS
mkarchiso -v -w ./iso/output -o ./iso/output ./iso/baseline/
```

After the build completes, your ISO file will be located in:

```bash
./iso/output/
```


