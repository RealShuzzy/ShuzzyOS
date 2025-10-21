# 💧 ShuzzyOS
!["Preview of ShuzzyOS"](assets/preview.png)

## 💿 Getting the ISO

<details>
  <summary><strong>📥 Download</strong></summary>
    
  ### Download
    
  > ⚠️ **Note:** Every **month** there is a new ISO, it is recommended to use the latest.
  
  To download the ISO, head over to the official [ShuzzyOS Download Page](https://shuzzy.duckdns.org/download).

  ---
</details>

<details>
  <summary><strong>🛠️ Build It Yourself</strong></summary>
    
  ### Build
    
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

---
</details>



## 💿 Prepare the Installation

To install **ShuzzyOS**, we need to make the ISO bootable:
You can either use a **Ventoy** USB-Stick, or use programs **Rufus** or **Balena Etcher** to create your boot device..

<details>
  <summary><strong>💾 Ventoy</strong></summary>
    
  ### Ventoy
    
  > ⚠️ **Note: Ventoy** is a great way to create a **bootable** USB Device, simply by copying the ISO to the USB-Stick.
  
  #### 1. 📦 Download Ventoy

  Go to the official [Ventoy Download Page](https://www.ventoy.net/en/download.html).
  And install whichever fits your current OS and unzip it.
  
  #### 2. 📦 Format USB-Stick with Ventoy
  
  Now execute the `Ventoy2Disk` and continue by selecting your USB-Stick and hitting `Install`.
  
  #### 3. 📦 Copy ISO onto the USB-Stick
  
  Now we can finally use the ease of Ventoy by copying the ISO to the USB-Stick.
  
  ---
</details>

<details>
  <summary><strong>💾 Rufus / Balena Etcher</strong></summary>
    
  ### Rufus / Balena Etcher
    
  > ⚠️ **Note: Ventoy** is a great way to create a **bootable** USB Device, simply by copying the ISO to the USB-Stick.
  
  #### 1. 📦 Download Ventoy

  Go to the official [Ventoy Download Page](https://www.ventoy.net/en/download.html).
  And install whichever fits your current OS and unzip it.
  
  #### 2. 📦 Format USB-Stick with Ventoy
  
  Now execute the `Ventoy2Disk` and continue by selecting your USB-Stick and hitting `Install`.
  
  #### 3. 📦 Copy ISO onto the USB-Stick
  
  Now we can finally use the ease of Ventoy by copying the ISO to the USB-Stick.
  
  ---
</details>
