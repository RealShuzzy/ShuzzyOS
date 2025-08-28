# Z-Shell
sudo pacman -S --needed --noconfirm zsh > /dev/null
sudo chsh -s /usr/bin/zsh $USER
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/git/
echo 'source ~/git/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
echo '[[ ! -f ~/git/ShuzzyOS/assets/.p10k.zsh ]] || source ~/git/ShuzzyOS/assets/.p10k.zsh' >> ~/.zshrc