# Z-Shell
sudo pacman -S --needed --noconfirm zsh > /dev/null
sudo chsh -s /usr/bin/zsh $USER
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
rsync ~/.ShuzzyOS/assets/.p10k.zsh ~/
echo 'source ~/.powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc